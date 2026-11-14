import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/app_locale_service.dart';
import '../services/country_currency_service.dart';
import '../theme.dart';
import '../widgets/common.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: ValueListenableBuilder<int>(
        valueListenable: AppLocaleService.revision,
        builder: (context, _, __) {
          final langs = AppLocaleService.availableLanguages;
          final current = AppLocaleService.languageCode.value;
          final country = AppLocaleService.country.value;
          final india = AppLocaleService.isIndia;
          return SingleChildScrollView(
            child: staggered([
              TopBar(context.tr('language')),
              AppCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Region',
                      style: TextStyle(
                        color: C.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _RegionChip(
                            label: 'India',
                            subtitle: '₹ INR',
                            selected: india,
                            onTap: () =>
                                AppLocaleService.applyCountryIso2('IN'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _RegionChip(
                            label: 'Other countries',
                            subtitle: india
                                ? 'USD / local'
                                : '${country.currencySymbol} ${country.currencyCode}',
                            selected: !india,
                            onTap: () => _pickOtherCountry(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      india
                          ? 'India shows Indian languages only. Other countries show English + 10 international languages.'
                          : 'International languages for ${country.name}. Currency: ${country.currencySymbol} ${country.currencyCode}.',
                      style: const TextStyle(
                        color: C.muted,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              for (final l in langs)
                InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () async {
                    await AppLocaleService.setLanguageCode(l.code);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.tr('language_updated'))),
                    );
                  },
                  child: AppCard(
                    borderColor: l.code == current ? C.magenta : C.border,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: l.code == current
                                ? C.magenta
                                : Colors.transparent,
                            border: Border.all(
                              color:
                                  l.code == current ? C.magenta : C.muted,
                              width: 2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.englishName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                              if (l.nativeName != l.englishName)
                                Text(
                                  l.nativeName,
                                  style: const TextStyle(
                                    color: C.muted,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ], gap: 10),
          );
        },
      ),
    );
  }

  Future<void> _pickOtherCountry(BuildContext context) async {
    final others = CountryCurrencyService.countries
        .where((c) => c.iso2 != 'IN')
        .toList();
    final selected = await showModalBottomSheet<CountryInfo>(
      context: context,
      backgroundColor: C.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: C.border2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose country',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: others.length,
                itemBuilder: (_, i) {
                  final c = others[i];
                  return ListTile(
                    title: Text(c.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${c.currencySymbol} ${c.currencyCode}'),
                    onTap: () => Navigator.pop(ctx, c),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    await AppLocaleService.applyCountryIso2(selected.iso2);
  }
}

class _RegionChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _RegionChip({
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? C.magenta.withValues(alpha: 0.15) : C.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? C.magenta : C.border2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: selected ? C.magenta : C.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(color: C.muted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
