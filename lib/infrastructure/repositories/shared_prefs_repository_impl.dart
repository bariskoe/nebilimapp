import 'package:logger/logger.dart';
import '../../domain/failures/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/shared_prefs_repository.dart';
import '../datasources/shared_prefs_datasource.dart';
import '../exceptions/exceptions.dart';

class SharedPrefsRepositoryImpl implements SharePrefsRepository {
  SharedPrefsDatasource sharedPrefsDatasource;

  SharedPrefsRepositoryImpl({required this.sharedPrefsDatasource});

  @override
  Future<Either<Failure, bool>> saveIntInSharedprefs(
      {required String key, required int integerToSave}) async {
    try {
      final bool success = await sharedPrefsDatasource.saveIntInSharedprefs(
          key: key, integerToSave: integerToSave);
      return Right(success);
    } catch (e) {
      Logger().d(e.toString());
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getIntFromSharedprefs(
      {required String key}) async {
    try {
      final integer = sharedPrefsDatasource.getIntFromSharedprefs(key: key);
      return Right(integer);
    } catch (e) {
      if (e is SharedPrefsKeyNotExistingException) {
        Logger().d(e.toString());
        return Left(SharedPrefsKeyDoesNotExistFailure());
      } else {
        Logger().d(e.toString());
        return Left(DatabaseFailure());
      }
    }
  }
}
