import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:nebilimapp/models/difficulty_settings_model.dart';
import '../domain/entities/category_settings_entity.dart';
import '../domain/entities/difficulty_settings_entity.dart';
import '../models/category_settings_model.dart';
import '../models/question_insertion_model.dart';
import '../models/settings_model.dart';
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

  //!Fields of the DifficultySettingsTable --------------------------------------------------
  static const String difficultySettingsTableName = 'difficulty_settings_table';

  /// Primary key
  static const String difficultySettingsTableFieldId = 'row_id';
  static const String difficultySettingsTableFieldDifficultyAsInt =
      'difficulty_as_int';
  static const String difficultySettingsTableFieldAsk = 'ask';

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

    await db.execute('''
      CREATE TABLE $difficultySettingsTableName(
          $difficultySettingsTableFieldId  INTEGER PRIMARY KEY AUTOINCREMENT,
          $difficultySettingsTableFieldDifficultyAsInt INTEGER NOT NULL,
          $difficultySettingsTableFieldAsk INTEGER NOT NULL 
          
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
    await setupAskOfCategoriesIfNotExists(db);
    await setupAskOfDifficultiesIfNotExists(db);
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

  setupAskOfCategoriesIfNotExists(Database db) async {
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
        Logger().d('setupAskOfCategoriesIfNotExists executec');
      }
    }
  }

  setupAskOfDifficultiesIfNotExists(Database db) async {
    final list = await db.rawQuery(
      'SELECT * FROM $difficultySettingsTableName ',
    );

    if (list.isNotEmpty) {
      return;
    } else {
      for (var difficulty in DifficultyEnum.values) {
        await db.insert(
          difficultySettingsTableName,
          {
            difficultySettingsTableFieldDifficultyAsInt:
                difficulty.getDifficultyAsInt,
            difficultySettingsTableFieldAsk: 1
          },
        );
        Logger().d('setupAskOfDifficultiesIfNotExist executed');
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

    return int.parse(ask[0].values.first.toString());
  }

  static Future<int> toggleAskCategory({required int categoryAsInt}) async {
    Database db = await instance.database;
    int currentAsk = await getAskOfCategory(categoryAsInt: categoryAsInt);

    /// When only 1 selected category is left, deselecting must not be allowed, because at least one category
    /// has to be selecte at any time. Therefor we need to count the selected categories before we decide
    /// if we can deselect it or not
    final numberOfaskableCategories = await db.rawQuery(
        'SELECT COUNT(*) FROM $categorySettingsTableName WHERE $categorySettingsTableFieldAsk = ?',
        [1]);

    bool deselectingAllowed = false;
    if (int.parse(numberOfaskableCategories.first['COUNT(*)'].toString()) > 1) {
      deselectingAllowed = true;
    }
    final updated = await db.rawUpdate(
        'UPDATE $categorySettingsTableName SET $categorySettingsTableFieldAsk = ? WHERE $categorySettingsTableFieldCategoryAsInt= ?',
        [
          currentAsk == 0
              ? 1
              : deselectingAllowed
                  ? 0
                  : 1,
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
      Logger().d('allCategorySettings isNotEmpty');
      for (Map<String, dynamic> rowMap in allCategorySettings) {
        Logger().d('rowmap: $rowMap');
        Logger().d('categoryentity ${CategorySettingsEntity.fromMap(rowMap)}');

        categorySettingsModelList
            .add(CategorySettingsEntity.fromMap(rowMap)!.toModel());
      }
    }

    List<Map<String, dynamic>> allDifficultySettings =
        await db.rawQuery('SELECT * FROM $difficultySettingsTableName');
    Logger().d('allDifficultySettings: $allDifficultySettings');
    List<DifficultySettingsModel> difficultySettingsModelList = [];

    if (allDifficultySettings.isEmpty) {
      for (DifficultyEnum element in DifficultyEnum.values) {
        difficultySettingsModelList.add(
            DifficultySettingsEntity.fromEnumValue(difficultyEnum: element)
                .toModel());
      }
    } else {
      Logger().d('allDifficultySettings isNotEmpty');
      for (Map<String, dynamic> rowMap in allDifficultySettings) {
        Logger().d('rowmap: $rowMap');
        Logger()
            .d('difficultyEntity ${DifficultySettingsEntity.fromMap(rowMap)}');

        difficultySettingsModelList
            .add(DifficultySettingsEntity.fromMap(rowMap).toModel());
      }
    }

    return SettingsModel(
        categorySettingsModelList: categorySettingsModelList,
        difficultySettingsModelList: difficultySettingsModelList);
  }
}
