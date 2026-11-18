import 'package:flutter/widgets.dart';

import '../services/app_locale_service.dart';
import 'gen/l10n.dart';
import 'app_localizations.dart';

export 'gen/l10n.dart';

/// `context.l10n.someKey` — strings from the ARB files in `lib/l10n/arb/`.
/// The selected language comes from [AppLocaleService]; MaterialApp rebuilds
/// with the new locale, so every screen using this updates at once.
extension L10nX on BuildContext {
  L10n get l10n => L10n.of(this);

  /// Stored display name, with the guest placeholder translated.
  String nameOrGuest(String name) => name == 'Guest' ? l10n.guest : name;
}

/// For code without a BuildContext (services, notifications).
L10n get l10nNow => lookupL10n(Locale(AppLocaleService.languageCode.value));
