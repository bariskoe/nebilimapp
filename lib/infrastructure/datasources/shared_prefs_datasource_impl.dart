import 'package:shared_preferences/shared_preferences.dart';

import '../exceptions/exceptions.dart';
import 'shared_prefs_datasource.dart';

class SharedPrefsDatasourceImpl implements SharedPrefsDatasource {
  SharedPreferences sharedPreferences;

  SharedPrefsDatasourceImpl({required this.sharedPreferences});

  static const numberOfQuestionsInDatabase = 'numberOfQuestionsInDatabase';

  @override
  Future<bool> saveIntInSharedprefs(
      {required String key, required int integerToSave}) async {
    return await sharedPreferences.setInt(key, integerToSave);
  }

  @override
  int getIntFromSharedprefs({required String key}) {
    final int? value = sharedPreferences.getInt(key);

    if (value != null) {
      return value;
    } else {
      throw SharedPrefsKeyNotExistingException();
    }
  }
}
