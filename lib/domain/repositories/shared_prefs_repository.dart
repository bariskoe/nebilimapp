import 'package:dartz/dartz.dart';

import '../failures/failures.dart';

abstract class SharePrefsRepository {
  Future<Either<Failure, bool>> saveIntInSharedprefs({
    required String key,
    required int integerToSave,
  });

  Future<Either<Failure, int>> getIntFromSharedprefs({
    required String key,
  });
}
