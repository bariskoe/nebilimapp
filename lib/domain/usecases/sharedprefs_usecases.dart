import 'package:dartz/dartz.dart';

import '../failures/failures.dart';
import '../repositories/shared_prefs_repository.dart';

class SharedPrefsUsecases {
  final SharePrefsRepository sharedPrefsRepository;
  SharedPrefsUsecases({required this.sharedPrefsRepository});

  Future<Either<Failure, bool>> saveIntInSharedprefs({
    required String key,
    required int integerToSave,
  }) async {
    return await sharedPrefsRepository.saveIntInSharedprefs(
      key: key,
      integerToSave: integerToSave,
    );
  }

  Future<Either<Failure, int>> getIntFromSharedprefs({
    required String key,
  }) async {
    return await sharedPrefsRepository.getIntFromSharedprefs(
      key: key,
    );
  }
}
