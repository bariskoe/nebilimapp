import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';
import 'package:nebilimapp/domain/entities/question_status_entity.dart';
import 'package:nebilimapp/models/question_status_model.dart';
import '../domain/entities/question_entity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../dependency_injection.dart';
import '../domain/failures/failures.dart';
import '../domain/usecases/sharedprefs_usecases.dart';
import '../infrastructure/datasources/shared_prefs_datasource_impl.dart';
import '../models/question_insertion_model.dart';

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
    await db.execute('''
      CREATE TABLE $questionStatusTableName(
          $questionStatusTableFieldId  INTEGER PRIMARY KEY AUTOINCREMENT,
          $questionStatusTableFieldStatus INTEGER,
          $questionStatusTableFieldLastTimeAsked INTEGER,
          $questionStatusTableFieldQuestionID INTEGER,
          FOREIGN KEY ($questionStatusTableFieldQuestionID) REFERENCES $questionTableName($questionTableFieldId)
      );
      ''');
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

    Logger().d('First Question in list: ${allQuestions.first}');
    Logger().d('Last Question in list: ${allQuestions.last}');
  }

  static getAllQuestionStatuses() async {
    Database db = await instance.database;
    List<Map> allQuestionStatuses =
        await db.rawQuery('SELECT * FROM $questionStatusTableName');
    Logger().d('allQuestionStatuses is ${allQuestionStatuses}');
    // Logger().d('First Question in list: ${allQuestionStatuses.first}');
    // Logger().d('Last Question in list: ${allQuestionStatuses.last}');
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

  static Future<QuestionEntity> getRandomQuestion() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> list = await db.rawQuery(
        'SELECT * FROM $questionTableName ORDER BY RANDOM() LIMIT 1;');
    Logger().d(list);

    final model = QuestionEntity.fromMap(map: list.first).toModel();

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

  static Future<bool> checkIfStatusExists({required int questionId}) async {
    Database db = await instance.database;
    final list = await db.rawQuery(
        'SELECT 1 FROM $questionStatusTableName WHERE $questionStatusTableFieldQuestionID = ?',
        [questionId]);
    Logger().d('list von id $questionId in checkIfStatusExists  ist $list');
    Logger().d('status existiert? ${list.isNotEmpty}');
    return list.isNotEmpty;
  }

  static Future updateQuestionStatus(
      {required QuestionStatusModel questionStatusModel}) async {
    QuestionStatusEntity entity = QuestionStatusEntity.fromModel(
      questionStatusModel: questionStatusModel,
    );
    Database db = await instance.database;
    final bool exists =
        await checkIfStatusExists(questionId: entity.questionId);
    Logger().d('exists von id in updateQuestionStatus  ist $exists');
    if (exists) {
      //final success = await db.rawUpdate(sql)

    } else {
      final inserted = await insertStatusToQuestionStatusTable(
          questionStatusModel: questionStatusModel);
    }
    getAllQuestionStatuses();
  }
}
