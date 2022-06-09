import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:nebilimapp/models/question_insertion_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  static const String databaseName = 'germanQuestionDatabase.db';

  ///Fields of the QuestionTable ----------------------------------------------
  static const String questionTableName = 'questionTable';
  static const String questionTableFieldId = 'questionId';
  static const String questionTableFieldDifficulty = 'difficulty';
  static const String questionTableFieldCategory = 'category';
  static const String questionTableFieldImageName = 'imageName';
  static const String questionTableFieldImageEnding = 'imageEnding';
  static const String questionTableFieldMusicName = 'musicName';
  static const String questionTableFieldMusicEnding = 'musicEnding';
  static const String questionTableFieldQuestionTextGerman =
      'questionTextGerman';
  static const String questionTableFieldAnswerTextGerman = 'answerTextGerman';
  static const String questionTableFieldAdditionalInfoGerman =
      'additionalInfoGerman';
  static const String questionTableFieldMainWordPositionGerman =
      'mainWordPositionGerman';
  static const String questionTableFieldQuestionTextEnglish =
      'questionTextEnglish';
  static const String questionTableFieldAnswerTextEnglish = 'answerTextEnglish';
  static const String questionTableFieldAdditionalInfoEnglish =
      'additionalInfoEnglish';
  static const String questionTableFieldMainWordPositionEnglish =
      'mainWordPositionEnglish';

  ///Fields of the QuestionStatusTable --------------------------------------------------
  static const String questionStatusTableName = 'questionStatusTable';

  /// Primary key
  static const String questionStatusTableFieldId = 'questionStatusId';

  /// Foreign key
  static const String questionStatusTableFieldQuestionID = 'questionId';

  /// i.e saved, blocked,
  static const String questionStatusTableFieldStatus = 'status';

  /// In Millisecondssinceepoch
  static const String questionStatusTableFieldLastTimeAsked = 'lastTimeAsked ';

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $questionTableName(
          $questionTableFieldId INTEGER NOT NUll,
          $questionTableFieldDifficulty INTEGER NOT NULL,
          $questionTableFieldCategory INTEGER NOT NULL,
          $questionTableFieldImageName TEXT,
          $questionTableFieldImageEnding INTEGER,
          $questionTableFieldMusicName TEXT,
          $questionTableFieldMusicEnding TEXT
          $questionTableFieldQuestionTextGerman TEXT NOT NULL,
          $questionTableFieldAnswerTextGerman TEXT NOT NULL,
          $questionTableFieldAdditionalInfoGerman TEXT,
          $questionTableFieldMainWordPositionGerman INTEGER NOT NULL,



      );
      ''');
    await db.execute('''
      CREATE TABLE $questionStatusTableName(
          $questionStatusTableFieldId  INTEGER PRIMARY KEY AUTOINCREMENT,
          $questionStatusTableFieldStatus INTEGER,
          $questionStatusTableFieldLastTimeAsked INTEGER,
          FOREIGN KEY ($questionStatusTableFieldQuestionID) REFERENCES $questionTableName($questionTableFieldId) ON DELETE CASCADE
      );
      ''');
    print('Sollte jetzt ausführen');
    await fillDatabaseIfnecessary();
    getAllQuestions();
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

  static Future<void> fillDatabaseIfnecessary() async {
    final _rawData = await rootBundle
        .loadString("assets/Aktive Fragen Flutter - Sheet2.csv");
    List<List<dynamic>> _listData =
        const CsvToListConverter().convert(_rawData);

    ///Remove headline rows
    _listData.removeAt(0);
    _listData.removeAt(0);

    _listData.removeWhere((element) => element.isEmpty);
    // final firstRow = _listData[0];
    // final emptystringOrNull = firstRow[7];
    //Logger().d(_listData);
    // print(_listData);
    for (List list in _listData) {
      final model = QuestionInsertionModel.fromList(list);
      await insertQuestionToQuestionTable(model);
    }
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

  //static Future<List<dynamic>>
  getAllQuestions() async {
    Database db = await instance.database;
    List<Map> allQuestions =
        await db.rawQuery('SELECT * FROM $questionTableName');
    print(allQuestions);
  }
}
