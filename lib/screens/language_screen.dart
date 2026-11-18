import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/app_locale_service.dart';
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
              TopBar(context.l10n.language),
              AppCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.l10n.region,
                      style: const TextStyle(
                        color: C.muted,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      const Icon(Icons.public, color: C.teal, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${country.name} · ${country.currencySymbol} ${country.currencyCode}',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(context.l10n.auto,
                          style: const TextStyle(
                              color: C.teal,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ]),
                    const SizedBox(height: 10),
                    Text(
                      india
                          ? context.l10n.regionIndiaNote
                          : context.l10n.regionIntlNote(
                              '${country.currencySymbol} ${country.currencyCode}'),
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
                      SnackBar(content: Text(context.l10n.languageUpdated)),
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
                              color: l.code == current ? C.magenta : C.muted,
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
}
