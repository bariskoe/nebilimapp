import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class S {
  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.of(context);
    assert(instance != null, '''
No instance of AppLocalizations present in the widget tree. Did you add S.delegate in localizationsDelegates?''');
    return instance!;
  }
}
