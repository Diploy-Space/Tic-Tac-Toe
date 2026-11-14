import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../services/app_locale_service.dart';
import '../services/auth_service.dart';
import '../services/country_currency_service.dart';
import '../services/profile_service.dart';
import '../services/storage.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/extras.dart';
import 'dialogs.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _username = TextEditingController();
  final _phone = TextEditingController();
  CountryInfo _country = AppLocaleService.country.value;
  bool _busy = false;
  bool _avatarBusy = false;
  bool _loading = true;
  String? _error;
  String? _lockedCountry;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final p = await ProfileService.loadMyProfile(retry: false);
      if (!mounted) return;
      _username.text =
          p?.username ?? authDisplayName.value;
      if (p != null) {
        final c = CountryCurrencyService.byIso2(p.countryIso2);
        if (c != null) _country = c;
        _lockedCountry = p.countryIso2;
        final nat = p.nationalNumber;
        if (nat != null && nat.isNotEmpty) {
          _phone.text = nat;
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    if (!AuthService.isSignedIn) {
      setState(() => _error = 'Sign in to change photo');
      return;
    }
    if (!await requireInternet(context)) return;
    if (!mounted) return;
    setState(() {
      _avatarBusy = true;
      _error = null;
    });
    try {
      await ProfileService.changeAvatarFromGallery();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo updated')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = AuthService.messageFromError(e));
    } finally {
      if (mounted) setState(() => _avatarBusy = false);
    }
  }

  Future<void> _save() async {
    if (_busy) return;
    final nameErr = ProfileService.validateUsername(_username.text);
    if (nameErr != null) {
      setState(() => _error = nameErr);
      return;
    }
    final nat = _phone.text.trim();
    final hasPhone = nat.isNotEmpty;
    if (hasPhone && nat.length < 6) {
      setState(() => _error = 'Enter a valid mobile number');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ProfileService.updateProfile(
        username: _username.text,
        callingCode: hasPhone ? _country.callingCode : null,
        nationalNumber: hasPhone ? nat : null,
        countryIso2: hasPhone ? _country.iso2 : null,
      );
      await AppLocaleService.applyCountryIso2(_country.iso2);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = AuthService.messageFromError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteAccount() async {
    final ok = await showDeleteDialog(context);
    if (ok == true && mounted) {
      await AppStorage.clearAccount();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: _loading
          ? const Center(child: CircularProgressIndicator(color: C.magenta))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TopBar('EDIT PROFILE'),
                        const SizedBox(height: 28),
                        Center(child: _AvatarEditor(
                          busy: _avatarBusy,
                          onCamera: _pickAvatar,
                        )),
                        const SizedBox(height: 28),
                        _FieldLabel('Username'),
                        _EditBox(
                          child: TextField(
                            controller: _username,
                            style: const TextStyle(
                              color: C.text,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9_]')),
                              LengthLimitingTextInputFormatter(20),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              hintText: 'username',
                              hintStyle: TextStyle(color: C.muted),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FieldLabel('Email'),
                        _EditBox(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AuthService.email.isEmpty
                                      ? '—'
                                      : AuthService.email,
                                  style: const TextStyle(
                                    color: C.text,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const Text(
                                'read only',
                                style: TextStyle(
                                  color: C.muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FieldLabel('Mobile number (optional)'),
                        _EditBox(
                          child: Row(
                            children: [
                              Text(
                                _country.callingCode,
                                style: const TextStyle(
                                  color: C.teal,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _phone,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(12),
                                  ],
                                  style: const TextStyle(
                                    color: C.text,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintText: '—',
                                    hintStyle: TextStyle(color: C.muted),
                                  ),
                                ),
                              ),
                              if (_lockedCountry == null ||
                                  _lockedCountry!.isEmpty)
                                PopupMenuButton<CountryInfo>(
                                  tooltip: 'Country',
                                  color: C.surface,
                                  onSelected: (c) {
                                    setState(() => _country = c);
                                    AppLocaleService.applyCountryIso2(c.iso2);
                                  },
                                  itemBuilder: (_) => [
                                    for (final c
                                        in CountryCurrencyService.countries)
                                      PopupMenuItem(
                                        value: c,
                                        child: Text(
                                            '${c.iso2} ${c.callingCode}'),
                                      ),
                                  ],
                                  child: const Icon(Icons.expand_more,
                                      color: C.muted, size: 20),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Private. Only you can see this.',
                          style: TextStyle(color: C.muted, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        _FieldLabel('Login method'),
                        _EditBox(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AuthService.loginMethodLabel,
                                  style: const TextStyle(
                                    color: C.text,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              const Text(
                                'read only',
                                style: TextStyle(
                                  color: C.muted,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 14),
                          Text(_error!,
                              style: const TextStyle(
                                  color: C.danger, fontSize: 13)),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                PrimaryButton(
                  _busy ? 'Saving…' : 'Save Changes',
                  onTap: _busy ? null : _save,
                ),
                const SizedBox(height: 14),
                Center(
                  child: TextButton(
                    onPressed: _busy ? null : _deleteAccount,
                    child: const Text(
                      'Delete account',
                      style: TextStyle(
                        color: C.danger,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: C.muted,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EditBox extends StatelessWidget {
  final Widget child;
  const _EditBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: C.surface2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

class _AvatarEditor extends StatelessWidget {
  final bool busy;
  final VoidCallback onCamera;
  const _AvatarEditor({required this.busy, required this.onCamera});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: authAvatarUrl,
      builder: (_, url, __) => ValueListenableBuilder<String>(
        valueListenable: authDisplayName,
        builder: (_, name, ___) {
          final letter =
              name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
          final hasUrl = url != null && url.trim().isNotEmpty;
          return SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: hasUrl
                      ? ClipOval(
                          child: ProfileAvatar(url: url, size: 120),
                        )
                      : Center(
                          child: Text(
                            letter,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 72,
                              fontWeight: FontWeight.w300,
                              height: 1,
                            ),
                          ),
                        ),
                ),
                if (busy)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.45),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: C.magenta,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 0,
                  bottom: 4,
                  child: Material(
                    color: C.magenta,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: busy ? null : onCamera,
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.photo_camera,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
