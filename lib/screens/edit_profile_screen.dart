import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../services/auth_service.dart';
import '../services/country_currency_service.dart';
import '../services/profile_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _phone = TextEditingController();
  CountryInfo _country = CountryCurrencyService.countries.first;
  bool _busy = false;
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
      if (p != null) {
        final c = CountryCurrencyService.byIso2(p.countryIso2);
        if (c != null) _country = c;
        _lockedCountry = p.countryIso2;
        _phone.text = p.nationalNumber ?? '';
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy) return;
    final nat = _phone.text.trim();
    if (nat.isEmpty || nat.length < 6) {
      setState(() => _error = 'Enter a valid mobile number');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ProfileService.updateContact(
        callingCode: _country.callingCode,
        nationalNumber: nat,
        countryIso2: _country.iso2,
      );
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

  @override
  Widget build(BuildContext context) {
    final countryLocked = _lockedCountry != null && _lockedCountry!.isNotEmpty;
    return AppScaffold(
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: staggered([
                const TopBar('Edit profile'),
                ValueListenableBuilder(
                  valueListenable: ProfileService.current,
                  builder: (_, p, __) => AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Username',
                            style: TextStyle(color: C.muted, fontSize: 13)),
                        Text(p?.username ?? authDisplayName.value,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                const Text('Country',
                    style: TextStyle(color: C.muted, fontSize: 13)),
                AppCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<CountryInfo>(
                      value: _country,
                      isExpanded: true,
                      dropdownColor: C.surface,
                      items: [
                        for (final c in CountryCurrencyService.countries)
                          DropdownMenuItem(
                            value: c,
                            enabled: !countryLocked || c.iso2 == _lockedCountry,
                            child: Text(
                                '${c.name} (${c.callingCode})'),
                          ),
                      ],
                      onChanged: countryLocked
                          ? null
                          : (v) {
                              if (v == null) return;
                              setState(() => _country = v);
                            },
                    ),
                  ),
                ),
                if (countryLocked)
                  const Text(
                    'Country is locked after first save.',
                    style: TextStyle(color: C.muted, fontSize: 12),
                  ),
                const Text('Mobile number',
                    style: TextStyle(color: C.muted, fontSize: 13)),
                AppCard(
                  child: Row(
                    children: [
                      Text(_country.callingCode,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, color: C.teal)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(color: C.text),
                          decoration: const InputDecoration(
                            hintText: 'Mobile number',
                            hintStyle: TextStyle(color: C.muted),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: C.danger)),
                PrimaryButton(_busy ? 'Saving…' : 'Save',
                    onTap: _busy ? null : _save),
              ]),
            ),
    );
  }
}
