import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});
  static const langs = [
    'English', 'हिन्दी', 'Türkçe', 'العربية', 'Español', 'Português', 'Français', 'Bahasa Indonesia'
  ];
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: SingleChildScrollView(
        child: ValueListenableBuilder<String>(
            valueListenable: language,
            builder: (_, current, __) => staggered([
                  const TopBar('Language'),
                  for (final l in langs)
                    InkWell(
                        borderRadius: BorderRadius.circular(18),
                        // TODO: hook this value up to your localisation (Locale) setup.
                        onTap: () => language.value = l,
                        child: AppCard(
                            borderColor: l == current ? C.magenta : C.border,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(children: [
                              Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: l == current ? C.magenta : Colors.transparent,
                                      border: Border.all(
                                          color: l == current ? C.magenta : C.muted,
                                          width: 2))),
                              const SizedBox(width: 12),
                              Text(l, style: const TextStyle(fontWeight: FontWeight.w700)),
                            ]))),
                ], gap: 10)),
      ),
    );
  }
}
