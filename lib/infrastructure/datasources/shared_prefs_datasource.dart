abstract class SharedPrefsDatasource {
  Future<bool> saveIntInSharedprefs(
      {required String key, required int integerToSave});

  int getIntFromSharedprefs({required String key});
}
