import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:nebilimapp/domain/entities/category_settings_entity.dart';
import 'package:nebilimapp/models/category_settings_model.dart';
import 'package:nebilimapp/models/question_insertion_model.dart';
import 'package:nebilimapp/models/settings_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SettingsDatabaseHelper {
  SettingsDatabaseHelper._privateConstructor();
  static final SettingsDatabaseHelper instance =
      SettingsDatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  static const String databaseName = 'settings_database.db';
  static const String databaseAlias = 'SettingsDatabase';

  //!Fields of the CategorySettingsTable ---------------------------------------------------
  static const String categorySettingsTableName = 'category_settings_table';

  /// Primary key
  static const String categorySettingsTableFieldId = 'row_id';
  static const String categorySettingsTableFieldCategoryAsInt =
      'category_as_int';

  //Wether a question belonging to this category should be asked or not
  static const String categorySettingsTableFieldAsk = 'ask';

  // static const String categorySettingsTableFieldHistory = 'history';
  // static const String categorySettingsTableFieldGeography = 'geography';
  // static const String categorySettingsTableFieldScience = 'science';
  // static const String categorySettingsTableFieldSports = 'sports';
  // static const String categorySettingsTableFieldMedicine = 'medicine';
  // static const String categorySettingsTableFieldLiterature = 'literature';
  // static const String categorySettingsTableFieldCelebrities = 'celebrities';
  // static const String categorySettingsTableFieldFood = 'food';
  // static const String categorySettingsTableFieldMusic = 'music';
  // static const String categorySettingsTableFieldArts = 'arts';

  //!Fields of the DifficultySettingsTable --------------------------------------------------
  static const String difficultySettingsTableName = 'difficulty_settings_table';

  ///There will only be one row
  /// Primary key
  static const String difficultySettingsTableFieldId = 'difficulty_settings_id';

  static const String difficultySettingsTableFieldDifficulty1 = 'difficulty_1';
  static const String difficultySettingsTableFieldDifficulty2 = 'difficulty_2';
  static const String difficultySettingsTableFieldDifficulty3 = 'difficulty_3';
  static const String difficultySettingsTableFieldDifficulty4 = 'difficulty_4';
  static const String difficultySettingsTableFieldDifficulty5 = 'difficulty_5';

  //!Fields of the OtherSettingsTable ------------------------------------------------------
  static const String otherSettingsTableName = 'other_settings_table';

  ///There will only be one row
  /// Primary key
  static const String otherSettingsTableFieldId = 'other_settings_id';

  /// If this field holds a 0, questions which are marked as 'Don't ask again' will
  /// not be asked. The opposite will happen if it holds a 1. The standard value
  /// for this field is 0.
  static const String otherSettingsTableFieldAskDontAskAgainStatus =
      'ask_dont_ask_again';

  /// Unmarked questions should be asked if not explicitly determined differently
  /// by the user. So the standard value should be 1
  static const String otherSettingsTableFieldAskUnmarkedStatus = 'ask_unmarked';

  /// Standard value for this field: 1.
  static const String otherSettingsTableFieldAskFavoritedStatus =
      'ask_favorited';

  /// Seconds that will pass between the questions in order to give the user time
  /// to think. Standard value: 10.
  static const String otherSettingsTableFieldSecondsToThink =
      'seconds_to_think';

  /// Should the questions automatically be chained? If yes, one question will
  /// follow the other with the above thinking time in between. Standard: 0.
  static const String otherSettingsTableFieldChainQuestions = 'chain_questions';

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $categorySettingsTableName(
          $categorySettingsTableFieldId INTEGER PRIMARY KEY AUTOINCREMENT,
          $categorySettingsTableFieldCategoryAsInt INTEGER NOT NULL,
         
          $categorySettingsTableFieldAsk INTEGER NOT NULL
         

      );
      ''');
    await setupAskIfNotExists(db);

    await db.execute('''
      CREATE TABLE $difficultySettingsTableName(
          $difficultySettingsTableFieldId  INTEGER PRIMARY KEY AUTOINCREMENT,
          $difficultySettingsTableFieldDifficulty1 INTEGER,
          $difficultySettingsTableFieldDifficulty2 INTEGER, 
          $difficultySettingsTableFieldDifficulty3 INTEGER,
          $difficultySettingsTableFieldDifficulty4 INTEGER,
          $difficultySettingsTableFieldDifficulty5 INTEGER
      );
      ''');

    await db.execute('''
      CREATE TABLE $otherSettingsTableName(
          $otherSettingsTableFieldId  INTEGER PRIMARY KEY AUTOINCREMENT,
          $otherSettingsTableFieldAskDontAskAgainStatus INTEGER,
          $otherSettingsTableFieldAskUnmarkedStatus INTEGER,
          $otherSettingsTableFieldAskFavoritedStatus INTEGER,
          $otherSettingsTableFieldSecondsToThink INTEGER,
          $otherSettingsTableFieldChainQuestions INTEGER
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

  setupAskIfNotExists(Database db) async {
    final list = await db.rawQuery(
      'SELECT * FROM $categorySettingsTableName ',
    );

    if (list.isNotEmpty) {
      return;
    } else {
      for (var category in QuestionCategory.values) {
        await db.insert(
          categorySettingsTableName,
          {
            categorySettingsTableFieldCategoryAsInt: category.serialze(),
            categorySettingsTableFieldAsk: 1
          },
        );
        Logger().d('setupAskIfNotExists durchgeführt');
      }
    }
  }

  static Future<List> getListOfAskableCategories() async {
    Database db = await instance.database;
    final listOfMaps = await db.rawQuery(
        'SELECT $categorySettingsTableFieldCategoryAsInt FROM $categorySettingsTableName WHERE $categorySettingsTableFieldAsk = ?',
        [1]);
    List askableCategories = [];
    for (Map map in listOfMaps) {
      askableCategories.add(map[categorySettingsTableFieldCategoryAsInt]);
    }
    return askableCategories;
  }

  static Future<int> getAskOfCategory({required int categoryAsInt}) async {
    Database db = await instance.database;
    final ask = await db.rawQuery(
        'SELECT $categorySettingsTableFieldAsk FROM $categorySettingsTableName WHERE $categorySettingsTableFieldCategoryAsInt = ?',
        [categoryAsInt]);
    Logger().d('ask ist: ${int.parse(ask[0].values.first.toString())}');
    return int.parse(ask[0].values.first.toString());
  }

  static Future<int> toggleAskCategory({required int categoryAsInt}) async {
    Database db = await instance.database;
    int currentAsk = await getAskOfCategory(categoryAsInt: categoryAsInt);

    Logger().d('currentask is $currentAsk');
    final updated = await db.rawUpdate(
        'UPDATE $categorySettingsTableName SET $categorySettingsTableFieldAsk = ? WHERE $categorySettingsTableFieldCategoryAsInt= ?',
        [
          currentAsk == 0 ? 1 : 0,
          categoryAsInt,
        ]);

    return updated;
  }

  static Future<SettingsModel> getAllSettings() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> allCategorySettings =
        await db.rawQuery('SELECT * FROM $categorySettingsTableName');
    Logger().d('allCategorySettings: $allCategorySettings');
    List<CategorySettingsModel> categorySettingsModelList = [];

    if (allCategorySettings.isEmpty) {
      for (QuestionCategory element in QuestionCategory.values) {
        categorySettingsModelList.add(CategorySettingsEntity.fromEnumValue(
                questionCategoryEnumValue: element)
            .toModel());
      }
    } else {
      Logger().d('allCategorySettings.isNotEmpty');
      for (Map<String, dynamic> rowMap in allCategorySettings) {
        Logger().d('rowmap: $rowMap');
        Logger().d('categoryentity ${CategorySettingsEntity.fromMap(rowMap)}');

        categorySettingsModelList
            .add(CategorySettingsEntity.fromMap(rowMap)!.toModel());
      }
    }

    return SettingsModel(
      categorySettingsModelList: categorySettingsModelList,
    );
  }
}
