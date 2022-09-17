import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import '../bloc/question_bloc/bloc/question_bloc.dart';
import '../infrastructure/exceptions/exceptions.dart';
import 'settings_database_helper.dart';
import '../domain/entities/question_status_entity.dart';
import '../models/question_status_model.dart';
import '../domain/entities/question_entity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../dependency_injection.dart';
import '../domain/failures/failures.dart';
import '../domain/usecases/sharedprefs_usecases.dart';
import '../infrastructure/datasources/shared_prefs_datasource_impl.dart';
import '../models/question_insertion_model.dart';
import '../models/question_model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  static const String databaseName = 'question_database.db';

  ///Fields of the QuestionTable ----------------------------------------------
  static const String questionTableName = 'question_table';
  static const String questionTableFieldId = 'question_id';
  static const String questionTableFieldDifficulty = 'difficulty';
  static const String questionTableFieldCategory = 'category';
  static const String questionTableFieldImageName = 'image_name';
  static const String questionTableFieldImageEnding = 'image_ending';
  static const String questionTableFieldMusicName = 'music_name';
  static const String questionTableFieldMusicEnding = 'music_ending';
  static const String questionTableFieldQuestionTextGerman =
      'question_text_german';
  static const String questionTableFieldAnswerTextGerman = 'answer_text_german';
  static const String questionTableFieldAdditionalInfoGerman =
      'additional_info_german';
  static const String questionTableFieldMainWordPositionGerman =
      'main_word_position_german';
  static const String questionTableFieldQuestionTextEnglish =
      'question_text_english';
  static const String questionTableFieldAnswerTextEnglish =
      'answer_text_english';
  static const String questionTableFieldAdditionalInfoEnglish =
      'additional_info_english';
  static const String questionTableFieldMainWordPositionEnglish =
      'main_word_position_english';

  ///Fields of the QuestionStatusTable --------------------------------------------------
  static const String questionStatusTableName = 'question_status_table';

  /// Primary key
  static const String questionStatusTableFieldId = 'question_status_id';

  /// Foreign key
  static const String questionStatusTableFieldQuestionID = 'questionid_fk';

  /// i.e saved, blocked,
  static const String questionStatusTableFieldStatus = 'status';

  /// In Millisecondssinceepoch
  static const String questionStatusTableFieldLastTimeAsked =
      'last_time_asked ';

  /// Fields of the lastTimeAsked Table --------------------------------------------------
  static const String lastTimeAskedTableName = 'last_time_asekd_table';

  /// Foreign key
  static const String lastTimeAsekdTableFieldQuestionID = 'questionid_fk';
  static const String lastTimeAsekdTableLastTimeAskedInMsSinceEpoch =
      'last_time_asked';

  /// Fields of the recentyAsked Table ---------------------------------------------------
  static const String recentlyAskedTableName = 'recently_asekd_table';

  /// Foreign key
  static const String recentlyAskedTableFieldQuestionID = 'questionid_fk';

  /// This function attaches a database from another file to the provided database
  static Future<Database> attachDb(
      {required Database db,
      required String databaseName,
      required String databaseAlias}) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String absoluteEndPath = join(documentDirectory.path, databaseName);
    try {
      await db
          .rawQuery("ATTACH DATABASE '$absoluteEndPath' as '$databaseAlias'");
    } catch (e) {
      Logger().d('Caught error: $e');
    }
    return db;
  }

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $questionTableName(
          $questionTableFieldId INTEGER PRIMARY KEY UNIQUE,
          $questionTableFieldDifficulty INTEGER NOT NULL,
          $questionTableFieldCategory INTEGER NOT NULL,
          $questionTableFieldImageName TEXT,
          $questionTableFieldImageEnding INTEGER,
          $questionTableFieldMusicName TEXT,
          $questionTableFieldMusicEnding TEXT,
          $questionTableFieldQuestionTextGerman TEXT NOT NULL,
          $questionTableFieldAnswerTextGerman TEXT NOT NULL,
          $questionTableFieldAdditionalInfoGerman TEXT,
          $questionTableFieldMainWordPositionGerman INTEGER NOT NULL,
          $questionTableFieldQuestionTextEnglish  TEXT NOT NULL,
          $questionTableFieldAnswerTextEnglish TEXT NOT NULL,
          $questionTableFieldAdditionalInfoEnglish TEXT,
          $questionTableFieldMainWordPositionEnglish INTEGER NOT NULL

      );
      ''');
    //TODO questionStatusTableFieldLastTimeAsked diese Spalte hat hier eigentlich  nichts verloren
    await db.execute('''
      CREATE TABLE $questionStatusTableName(
          $questionStatusTableFieldId  INTEGER PRIMARY KEY AUTOINCREMENT,
          $questionStatusTableFieldStatus INTEGER,
          $questionStatusTableFieldLastTimeAsked INTEGER, 
          $questionStatusTableFieldQuestionID INTEGER,
          FOREIGN KEY ($questionStatusTableFieldQuestionID) REFERENCES $questionTableName($questionTableFieldId)
      );
      ''');
    await db.execute('''
      CREATE TABLE $lastTimeAskedTableName(
          $lastTimeAsekdTableFieldQuestionID  INTEGER PRIMARY KEY UNIQUE,
          $lastTimeAsekdTableLastTimeAskedInMsSinceEpoch INTEGER,
          FOREIGN KEY ($lastTimeAsekdTableFieldQuestionID) REFERENCES $questionTableName($questionTableFieldId)
      );
      ''');

    await db.execute('''
      CREATE TABLE $recentlyAskedTableName(
          $recentlyAskedTableFieldQuestionID  INTEGER PRIMARY KEY UNIQUE,
         
          FOREIGN KEY ($recentlyAskedTableFieldQuestionID) REFERENCES $questionTableName($questionTableFieldId)
      );
      ''');
    await _attachSettingsDatabase(db);
  }

  static Future _attachSettingsDatabase(Database db) async {
    /// Attach the [SettingsDatabase] to this [QuestionDatabase] (db) to be able to filter
    await attachDb(
      db: db,
      databaseName: SettingsDatabaseHelper.databaseName,
      databaseAlias: SettingsDatabaseHelper.databaseAlias,
    );
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    return await openDatabase(
      path,
      version: 1,
      onConfigure: onConfigure,
      onCreate: _onCreate,
    );
  }

  static Future<bool> updateQuestionDatabaseIfNecessary() async {
    final rawData =
        await rootBundle.loadString("assets/Aktive_Fragen_Flutter_Sheet2.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    int currentDatabaseLength = listData.length;

    ///Remove headline rows
    listData.removeAt(0);
    listData.removeAt(0);

    listData.removeWhere((element) => element.isEmpty);
    listData.removeWhere((element) => element.first == '');

    fillList() async {
      for (List list in listData) {
        final model = QuestionInsertionModel.fromList(list);
        await insertQuestionToQuestionTable(model);
      }
    }

    Either<Failure, int> failureOrOldDatabaseLength =
        await getIt<SharedPrefsUsecases>().getIntFromSharedprefs(
            key: SharedPrefsDatasourceImpl.numberOfQuestionsInDatabase);
    failureOrOldDatabaseLength.fold(
      (failure) {
        if (failure is SharedPrefsKeyDoesNotExistFailure) {
          fillList();
          getIt<SharedPrefsUsecases>().saveIntInSharedprefs(
            key: SharedPrefsDatasourceImpl.numberOfQuestionsInDatabase,
            integerToSave: currentDatabaseLength,
          );
          Logger().d('no key was present. filled list from scratch');
          return true;
        } else {
          Logger().d('Other failure: ${failure.toString()}');
          return false;
        }
      },
      (oldDatabaseLength) async {
        if (currentDatabaseLength != oldDatabaseLength) {
          getIt<SharedPrefsUsecases>().saveIntInSharedprefs(
            key: SharedPrefsDatasourceImpl.numberOfQuestionsInDatabase,
            integerToSave: currentDatabaseLength,
          );

          await deleteAllQuestions();

          await fillList();
          Logger().d('CSV file has changed. Updated QuestionDatabase.');

          getAllQuestions();
          return true;
        }
        return false;
      },
    );
    return true;
  }

  static Future<int> insertQuestionToQuestionTable(
    QuestionInsertionModel questionInsertionModel,
  ) async {
    Database db = await instance.database;
    return await db.insert(
      questionTableName,
      questionInsertionModel.toMap(),
    );
  }

  static getAllQuestions() async {
    Database db = await instance.database;
    List<Map> allQuestions =
        await db.rawQuery('SELECT * FROM $questionTableName');

    Logger().d('allquestions: $allQuestions');
  }

  static getAllQuestionStatuses() async {
    Database db = await instance.database;
    List<Map> allQuestionStatuses =
        await db.rawQuery('SELECT * FROM $questionStatusTableName');
    Logger().d('allQuestionStatuses is $allQuestionStatuses');
  }

  static Future<int> deleteAllQuestions() async {
    Database db = await instance.database;
    int count = await db.delete(questionTableName);
    return count;
  }

  static Future<int> deleteQuestionById(int id) async {
    Database db = await instance.database;
    return await db.rawDelete(
        'DELETE FROM $questionTableName WHERE $questionTableFieldId = ?', [id]);
  }

// QS means Query String
  static String recentlyAskedQuestionsQS =
      '(SELECT $recentlyAskedTableFieldQuestionID FROM $recentlyAskedTableName)';
  static String askableCategoriesQS =
      '(SELECT ${SettingsDatabaseHelper.categorySettingsTableFieldCategoryAsInt} FROM SettingsDatabase.category_settings_table WHERE ${SettingsDatabaseHelper.categorySettingsTableFieldAsk} = 1)';
  static String askableDifficultiesQS =
      '(SELECT ${SettingsDatabaseHelper.difficultySettingsTableFieldDifficultyAsInt} FROM SettingsDatabase.difficulty_settings_table WHERE ${SettingsDatabaseHelper.difficultySettingsTableFieldAsk} = 1)';
  static String orderByRandomAndLimit({int limit = 1}) =>
      'ORDER BY RANDOM() LIMIT $limit;';
  static String categoryAndDifficultyFilterQS =
      '$questionTableFieldCategory IN $askableCategoriesQS AND $questionTableFieldDifficulty IN $askableDifficultiesQS';
  static String questionIdsInQuestionStatusTableQS =
      '(SELECT $questionStatusTableFieldQuestionID FROM $questionStatusTableName)';
  static Future<QuestionModel> getFilterConformQuestion() async {
    Database db = await instance.database;
    try {
      _attachSettingsDatabase(db);
    } catch (e) {
      Logger().d('Error while attaching: $e');
    }

    final askableStatuses =
        await SettingsDatabaseHelper.getAllAskableStatusesAsInt();

    int askUnmarkedAsInt = await SettingsDatabaseHelper.getValueOfOtherSetting(
        nameOfOtherSetting:
            SettingsDatabaseHelper.otherSettingsAskUnmarkedStatus);
    bool askUnmarked = askUnmarkedAsInt == 0 ? false : true;
    final numberOfMarkedStatusesAsList =
        await db.rawQuery('SELECT COUNT(*) FROM $questionStatusTableName');
    int statusTableCount =
        int.parse(numberOfMarkedStatusesAsList.first['COUNT(*)'].toString());

    if (statusTableCount == 0) {
      // QuestionStatusTable is empty
      // This is i.e. the case right at the start when there is no question marked in any way.
      // Return a question which complies with the category and difficulty filter:
      Logger().d(
          'StatusTable is empty. Trying to find questions which satisfy the other filters...');
      List<Map<String, dynamic>> questionList = await db.rawQuery(
          'SELECT * FROM $questionTableName WHERE $questionTableFieldId NOT IN $recentlyAskedQuestionsQS AND $categoryAndDifficultyFilterQS ${orderByRandomAndLimit()}');
      if (questionList.isNotEmpty) {
        final model = QuestionEntity.fromMap(
          questionMap: questionList.first,
          // QuestionStatusMap muss hier nicht übergeben werden, weil es noch keinen Statuseintrag gibt
        ).toModel();
        Logger().d(
            'Status table is empty. Returning unmarked question which satisfies the other filters.');
        return model;
      } else {
        Logger().d(
            'No unmarked Questions left which satisfy the other filters. Returning NoQuestionLeftException');
        throw AllfilterConformQuestionsRecentlyAskedException();
      }
    } else {
      // QuestionStatusTable is not empty
      // 0 = unmarked, 1= favorited, 2 = dont ask again
      List<Map<String, dynamic>> mapOfFilterConformQuestions = [];
      List<Map<String, dynamic>> mapOfAskableQuestions = [];
      String mapOfFilterConformQuestionsQS = '';

      if (askableStatuses.length == 1 && askableStatuses.contains(1)) {
        // favorite is the only status which is selected
        String favoritedQuestionIdsQS =
            '(SELECT $questionStatusTableFieldQuestionID FROM $questionStatusTableName WHERE $questionStatusTableFieldStatus = 1)';

        mapOfFilterConformQuestionsQS =
            'SELECT * FROM $questionTableName WHERE $questionTableFieldId IN $favoritedQuestionIdsQS AND $categoryAndDifficultyFilterQS';
      }

      if (askableStatuses.length == 1 && askableStatuses.contains(0)) {
        // unmarked is the only status which is selected
        // 0 = unmarked, 1= favorited, 2 = dont ask again
        // Unmarked questions are not saved in the questionStatusTable. Therefor they
        // must not be present in the questionStatusTable

        mapOfFilterConformQuestionsQS =
            'SELECT * FROM $questionTableName WHERE $questionTableFieldId NOT IN $questionIdsInQuestionStatusTableQS AND $categoryAndDifficultyFilterQS';
      }

      if (askableStatuses.length == 1 && askableStatuses.contains(2)) {
        // don't ask again is the only status which is selected
        // 0 = unmarked, 1= favorited, 2 = dont ask again
        String dismissedQuestionIdsQS =
            '(SELECT $questionStatusTableFieldQuestionID FROM $questionStatusTableName WHERE $questionStatusTableFieldStatus = 2)';

        mapOfFilterConformQuestionsQS =
            'SELECT * FROM $questionTableName WHERE $questionTableFieldId IN $dismissedQuestionIdsQS AND $categoryAndDifficultyFilterQS';
      }

      if (askableStatuses.length == 2 &&
          askableStatuses.contains(0) &&
          askableStatuses.contains(1)) {
        // unmarked and favorited are selected
        // 0 = unmarked, 1= favorited, 2 = dont ask again

        mapOfFilterConformQuestionsQS =
            'SELECT * FROM $questionTableName WHERE (($questionTableFieldId NOT IN $questionIdsInQuestionStatusTableQS AND $categoryAndDifficultyFilterQS) OR ($questionTableFieldId IN (SELECT $questionStatusTableFieldQuestionID FROM $questionStatusTableName WHERE $questionStatusTableFieldStatus = 1 AND $categoryAndDifficultyFilterQS)))';
      }

      if (askableStatuses.length == 2 &&
          askableStatuses.contains(0) &&
          askableStatuses.contains(2)) {
        // unmarked and dont ask again are selected
        // 0 = unmarked, 1= favorited, 2 = dont ask again

        mapOfFilterConformQuestionsQS =
            'SELECT * FROM $questionTableName WHERE (($questionTableFieldId NOT IN $questionIdsInQuestionStatusTableQS AND $categoryAndDifficultyFilterQS) OR ($questionTableFieldId IN (SELECT $questionStatusTableFieldQuestionID FROM $questionStatusTableName WHERE $questionStatusTableFieldStatus = 2 AND $categoryAndDifficultyFilterQS)))';
      }

      if (askableStatuses.length == 2 &&
          askableStatuses.contains(1) &&
          askableStatuses.contains(2)) {
        // favorited and dont ask again are selected
        // 0 = unmarked, 1= favorited, 2 = dont ask again

        mapOfFilterConformQuestionsQS =
            'SELECT * FROM $questionTableName WHERE (($questionTableFieldId IN (SELECT $questionStatusTableFieldQuestionID FROM $questionStatusTableName WHERE $questionStatusTableFieldStatus = 1 AND $categoryAndDifficultyFilterQS) OR ($questionTableFieldId IN (SELECT $questionStatusTableFieldQuestionID FROM $questionStatusTableName WHERE $questionStatusTableFieldStatus = 2 AND $categoryAndDifficultyFilterQS))))';
      }

      if (askableStatuses.length == 3) {
        // all 3 statuses are selected
        // 0 = unmarked, 1= favorited, 2 = dont ask again

        mapOfFilterConformQuestionsQS =
            'SELECT * FROM $questionTableName WHERE $categoryAndDifficultyFilterQS';
      }

//----------------------------------------------------------------------------------------------------------------
//! Problem: This could lead to performance Problems if there are thousands of filterconform questions
      mapOfFilterConformQuestions =
          await db.rawQuery(mapOfFilterConformQuestionsQS);
      if (mapOfFilterConformQuestions.isEmpty) {
        Logger().d('Es gibt keine filterkonformen Fragen');
        throw NoFilterConformQuestionsExistException();
      } else {
        mapOfAskableQuestions = await db.rawQuery(
            '$mapOfFilterConformQuestionsQS AND $questionTableFieldId NOT IN $recentlyAskedQuestionsQS ${orderByRandomAndLimit()}');

        if (mapOfAskableQuestions.isEmpty) {
          Logger().d('Alle filter konformen Fragen wurden kürzlich gestellt');
          throw AllfilterConformQuestionsRecentlyAskedException();
        } else {
          final questionStatusMap = await getQuestionStatusById(
              questionId: mapOfAskableQuestions
                  .first[DatabaseHelper.questionTableFieldId]);
          final model = QuestionEntity.fromMap(
            questionMap: mapOfAskableQuestions.first,
            questionStatusMap: questionStatusMap,
          ).toModel();
          return model;
        }
      }
    }
  }

  static Future<QuestionModel> getRandomQuestion() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> list = await db.rawQuery(
        'SELECT * FROM $questionTableName ORDER BY RANDOM() LIMIT 1;');

    final questionStatusMap = await getQuestionStatusById(
        questionId: list.first[DatabaseHelper.questionTableFieldId]);

    final model = QuestionEntity.fromMap(
            questionMap: list.first, questionStatusMap: questionStatusMap)
        .toModel();

    return model;
  }

  static Future<QuestionModel> getQuestionById(
      {required int questionId}) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> list = await db.rawQuery(
        'SELECT * FROM $questionTableName WHERE $questionTableFieldId = ?',
        [questionId]);

    final questionStatusMap = await getQuestionStatusById(
        questionId: list.first[DatabaseHelper.questionTableFieldId]);

    final model = QuestionEntity.fromMap(
            questionMap: list.first, questionStatusMap: questionStatusMap)
        .toModel();
    return model;
  }

  static Future<int> insertStatusToQuestionStatusTable(
      {required QuestionStatusModel questionStatusModel}) async {
    QuestionStatusEntity entity = QuestionStatusEntity.fromModel(
      questionStatusModel: questionStatusModel,
    );
    Database db = await instance.database;
    return await db.insert(
      questionStatusTableName,
      entity.toMap(),
    );
  }

  /// Deletes an entry if a question is marked as unmarked
  static Future<int> deleteQuestionFromQuestionStatusTable(
      {required int questionId}) async {
    Database db = await instance.database;
    final entryExists = await checkIfStatusExists(questionId: questionId);

    if (entryExists) {
      final deleted = await db.rawDelete(
          'DELETE FROM $questionStatusTableName WHERE $questionStatusTableFieldQuestionID = ?',
          [questionId]);
      return deleted;
    } else {
      return 0;
    }
  }

  static Future<bool> checkIfStatusExists({required int questionId}) async {
    Database db = await instance.database;
    final list = await db.rawQuery(
        'SELECT * FROM $questionStatusTableName WHERE $questionStatusTableFieldQuestionID = ?',
        [questionId]);

    return list.isNotEmpty;
  }

  static Future<Map<String, dynamic>?> getQuestionStatusById(
      {required int questionId}) async {
    Database db = await instance.database;
    final list = await db.rawQuery(
        'SELECT * FROM $questionStatusTableName WHERE $questionStatusTableFieldQuestionID = ?',
        [questionId]);

    return list.isEmpty ? null : list.first;
  }

  static Future<int> updateQuestionStatus(
      {required QuestionStatusModel questionStatusModel}) async {
    QuestionStatusEntity entity = QuestionStatusEntity.fromModel(
      questionStatusModel: questionStatusModel,
    );
    Database db = await instance.database;
    final bool exists =
        await checkIfStatusExists(questionId: entity.questionId);

    if (exists) {
      if (questionStatusModel.questionStatus == QuestionStatus.unmarked) {
        return await deleteQuestionFromQuestionStatusTable(
            questionId: questionStatusModel.questionId);
      } else {
        final updated = await db.rawUpdate(
            'UPDATE $questionStatusTableName SET $questionStatusTableFieldStatus = ?, $questionStatusTableFieldLastTimeAsked = ? WHERE $questionStatusTableFieldQuestionID= ?',
            [
              entity.questionStatusAsInt,
              entity.lastTimeAskedAsInt,
              entity.questionId,
            ]);
        return updated;
      }
    } else {
      final inserted = await insertStatusToQuestionStatusTable(
          questionStatusModel: questionStatusModel);
      return inserted;
    }
  }

  static Future<int> toggleFavoriteStatus({required int questionId}) async {
    final statusMap = await getQuestionStatusById(questionId: questionId);
    QuestionStatus? newQuestionStatus;
    if (statusMap == null) {
      /// statusMap == null means there is no status entry for this question
      /// in [QuestionStatusTable]
      QuestionStatusModel newQuestionStatusModel = QuestionStatusModel(
        questionId: questionId,
        questionStatus: QuestionStatus.favorited,
        lastTimeAsked: DateTime.now(),
      );
      final inserted = await insertStatusToQuestionStatusTable(
          questionStatusModel: newQuestionStatusModel);
      return inserted;
    } else {
      final QuestionStatusModel? model =
          QuestionStatusEntity.fromMap(statusMap)?.toModel();

      if (model?.questionStatus == QuestionStatus.favorited) {
        newQuestionStatus = QuestionStatus.unmarked;
      } else if (model?.questionStatus == QuestionStatus.unmarked) {
        newQuestionStatus = QuestionStatus.favorited;
      } else if (model?.questionStatus == QuestionStatus.dontAskAgain) {
        newQuestionStatus = QuestionStatus.favorited;
      }
      QuestionStatusModel newQuestionStatusModel = QuestionStatusModel(
        questionId: questionId,
        questionStatus: newQuestionStatus ?? QuestionStatus.unmarked,
        lastTimeAsked: DateTime.now(),
      );
      final updated = await updateQuestionStatus(
          questionStatusModel: newQuestionStatusModel);

      return updated;
    }
  }

  static Future<int> toggleDontAskAgain({required int questionId}) async {
    final statusMap = await getQuestionStatusById(questionId: questionId);

    QuestionStatusModel newQuestionStatusModel;
    if (statusMap == null) {
      /// statusMap == null means there is no status entry for this question
      /// in [QuestionStatusTable]
      newQuestionStatusModel = QuestionStatusModel(
        questionId: questionId,
        questionStatus: QuestionStatus.dontAskAgain,
        lastTimeAsked: DateTime.now(),
      );
      final inserted = await insertStatusToQuestionStatusTable(
          questionStatusModel: newQuestionStatusModel);
      return inserted;
    } else {
      QuestionStatusModel oldQuestionStatusModel =
          QuestionStatusEntity.fromMap(statusMap)!.toModel();
      QuestionStatus newQuestionStatus;
      if (oldQuestionStatusModel.questionStatus.isDontAskagain) {
        newQuestionStatus = QuestionStatus.unmarked;
      } else {
        newQuestionStatus = QuestionStatus.dontAskAgain;
      }
      newQuestionStatusModel = QuestionStatusModel(
        questionId: questionId,
        questionStatus: newQuestionStatus,
        lastTimeAsked: DateTime.now(),
      );
      final updated = await updateQuestionStatus(
          questionStatusModel: newQuestionStatusModel);
      return updated;
    }
  }

  static Future<bool> checkIfLastTimeAskedExists(
      {required int questionId}) async {
    Database db = await instance.database;
    final mapList = await db.rawQuery(
        'SELECT $lastTimeAsekdTableLastTimeAskedInMsSinceEpoch FROM $lastTimeAskedTableName WHERE $lastTimeAsekdTableFieldQuestionID = ?',
        [questionId]);
    // returns true if an entry exists for this questionId.
    return mapList.isNotEmpty;
  }

  static Future<int> insertTimeToLastTimeAskedTable(
      {required int questionId}) async {
    Database db = await instance.database;
    final lastTimeAsked = DateTime.now().millisecondsSinceEpoch;
    final map = {
      lastTimeAsekdTableFieldQuestionID: questionId,
      lastTimeAsekdTableLastTimeAskedInMsSinceEpoch: lastTimeAsked,
    };
    return await db.insert(
      lastTimeAskedTableName,
      map,
    );
  }

  static Future<int> insertQuestionIdToRecentlyAskedTable(
      {required int questionId}) async {
    Database db = await instance.database;
    final alreadyExists = await db.rawQuery(
        'SELECT * FROM $recentlyAskedTableName WHERE $recentlyAskedTableFieldQuestionID =?',
        [questionId]);
    if (alreadyExists.isEmpty) {
      final map = {recentlyAskedTableFieldQuestionID: questionId};
      final inserted = await db.insert(recentlyAskedTableName, map);

      return inserted;
    } else {
      return 0;
    }
  }

  static Future<int> deleteQuestionIdFromRecentlyAskedQuestionsTable(
      {required int questionId}) async {
    Database db = await instance.database;
    final deleted = db.rawDelete(
        'DELETE * FROM $recentlyAskedTableName WHERE $recentlyAskedTableFieldQuestionID = ?',
        [questionId]);
    return deleted;
  }

  static Future<int> clearRecentlyAskedTable() async {
    Database db = await instance.database;
    int count = await db.delete(recentlyAskedTableName);
    return count;
  }

  static getAllRecentlyAskedQuestionIds() async {
    Database db = await instance.database;
    final mapList = await db.rawQuery('SELECT * from $recentlyAskedTableName');
    Logger().d('recently asked questions ist: $mapList');
  }

  static getAllTimesFromLastTimeAskedTable() async {
    Database db = await instance.database;
    final mapList = await db.rawQuery('SELECT * from $lastTimeAskedTableName');
    Logger().d('all last time asked : $mapList');
  }
}
