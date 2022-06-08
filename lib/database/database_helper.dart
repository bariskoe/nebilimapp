import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelperGerman {
  DatabaseHelperGerman._privateConstructor();
  static final DatabaseHelperGerman instance =
      DatabaseHelperGerman._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  static const String databaseName = 'germanQuestionDatabase.db';

  ///Fields of the QuestionTable ----------------------------------------------
  static const String questionTableName = 'questionTable';
  static const String questionTableFieldId = 'questionId';
  static const String questionTableFieldQuestionText = 'questionText';
  static const String questionTableFieldAnswerText = 'answerText';
  static const String questionTableFieldAdditionalInfo = 'additionalInfo';
  static const String questionTableFieldMainWordPosition = 'mainWordPosition';
  static const String questionTableFieldDifficulty = 'difficulty';
  static const String questionTableFieldCategory = 'category';
  static const String questionTableFieldImageName = 'imageName';
  static const String questionTableFieldImageEnding = 'imageEnding';
  static const String questionTableFieldMusicName = 'musicName';
  static const String questionTableFieldMusicEnding = 'musicEnding';

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
          $questionTableFieldQuestionText TEXT NOT NULL,
          $questionTableFieldAnswerText TEXT NOT NULL,
          $questionTableFieldAdditionalInfo TEXT,
          $questionTableFieldMainWordPosition INTEGER NOT NULL,
          $questionTableFieldDifficulty INTEGER NOT NULL,
          $questionTableFieldCategory INTEGER NOT NULL,
          $questionTableFieldImageName TEXT,
          $questionTableFieldImageEnding INTEGER,
          $questionTableFieldMusicName TEXT,
          $questionTableFieldMusicEnding TEXT



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

  static Future<int> insertQuestionToQuestionTable(
    QuestionModel questionModel,
  ) async {
    Database db = await instance.database;
    return await db.insert(
        questionTableName, todoListModel.toMapForInsertNewListIntoDatabase());
  }
}
