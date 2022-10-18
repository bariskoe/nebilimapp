import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';

import 'package:nebilimapp/utils/utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../domain/entities/category_settings_entity.dart';
import '../domain/entities/difficulty_settings_entity.dart';
import '../domain/entities/question_status_entity.dart';
import '../domain/entities/question_status_settings_entity.dart';
import '../domain/entities/thinking_time_entity.dart';
import '../models/category_settings_model.dart';
import '../models/difficulty_settings_model.dart';
import '../models/question_insertion_model.dart';
import '../models/question_status_settings_model.dart';
import '../models/settings_model.dart';

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
  /// This table will look like this:
  /// nameOfSetting     |  nameAsInt     valueAsInt   |   otherSettingsGroup
  /// dont_ask_again  |       2               0         |           0
  /// unmarked        |       0               1         |           0
  /// favorited       |       1               1         |           0
  /// seconds_to_think|                      15        |           1
  /// chain_questions |                      0         |           2
  ///                                 .
  ///                                 .
  ///                                 .

  static const String otherSettingsTableName = 'other_settings_table';

  static const String otherSettingsTableFieldNameOfSetting = 'nameOfSetting';
  static const String otherSettingsTableFieldValueAsInt = 'valueAsInt';
  static const String otherSettingsTableFieldGroup = 'otherSettingsGroup';

  /// If this field holds a 0, questions which are marked as 'Don't ask again' will
  /// not be asked. The opposite will happen if it holds a 1. The standard value
  /// for this field is 0.
  static String otherSettingsDontAskAgainStatus =
      QuestionStatus.dontAskAgain.name;

  /// Unmarked questions should be asked if not explicitly determined differently
  /// by the user. So the standard value should be 1
  static String otherSettingsAskUnmarkedStatus = QuestionStatus.unmarked.name;

  /// Standard value for this setting is: 1.
  static String otherSettingsAskFavoritedStatus = QuestionStatus.favorited.name;

  /// This field will will probably only be used by status settings. It was created
  /// in order to be able to translate status names to integers
  static String otherSettingsTableFieldNameAsInt = 'name_as_int';

  /// Whether the user should have unlimited time to Think or not. Standard value
  /// is 0, so there is no time limit by default
  static String otherSettingsSecondsToThinkActive =
      'other_settings_seconds_to_think_active';

  /// Seconds in which an animation will run after the question is visible
  /// After this duration, the answer will be visible
  static const String otherSettingsSecondsToThink = 'seconds_to_think';

  /// Should the questions automatically be chained? If yes, one question will
  /// follow the other with resting time in between. Standard: 0.
  static const String otherSettingsChainQuestions = 'chain_questions';

  /// The time that should pass between the questions if otherSettingsChainQuestions
  /// is true
  static const String otherSettingsRestingTime = 'resting_time';

  /// Wether text to speech is on or off. Standard: 0.
  static const String otherSettingsTextToSpeechOn = 'text_to_speech_on';

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
          $otherSettingsTableFieldNameOfSetting  TEXT NOT NULL UNIQUE,
          $otherSettingsTableFieldNameAsInt INTEGER,
          $otherSettingsTableFieldValueAsInt INTEGER NOT NULL,
          $otherSettingsTableFieldGroup INTEGER NOT NULL   
      );
      ''');

    await setupAskOfCategoriesIfNotExists(db);
    await setupAskOfDifficultiesIfNotExists(db);
    await setupOtherSettingsIfNotExists(db);
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
        Logger().d('setupAskOfCategoriesIfNotExists executed');
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

  setupOtherSettingsIfNotExists(Database db) async {
    var list = await db.rawQuery(
      'SELECT * FROM $otherSettingsTableName',
    );

    if (list.isNotEmpty) {
      return;
    } else {
      await db.insert(otherSettingsTableName, {
        otherSettingsTableFieldNameOfSetting: otherSettingsAskFavoritedStatus,
        otherSettingsTableFieldValueAsInt: 1,
        otherSettingsTableFieldGroup: 0,
        otherSettingsTableFieldNameAsInt: 1
      });
      await db.insert(otherSettingsTableName, {
        otherSettingsTableFieldNameOfSetting: otherSettingsAskUnmarkedStatus,
        otherSettingsTableFieldValueAsInt: 1,
        otherSettingsTableFieldGroup: 0,
        otherSettingsTableFieldNameAsInt: 0,
      });
      await db.insert(otherSettingsTableName, {
        otherSettingsTableFieldNameOfSetting: otherSettingsDontAskAgainStatus,
        otherSettingsTableFieldValueAsInt: 0,
        otherSettingsTableFieldGroup: 0,
        otherSettingsTableFieldNameAsInt: 2,
      });

      await db.insert(
        otherSettingsTableName,
        {
          otherSettingsTableFieldNameOfSetting:
              otherSettingsSecondsToThinkActive,
          otherSettingsTableFieldValueAsInt: 0,
          otherSettingsTableFieldGroup: 1,
        },
      );
      await db.insert(
        otherSettingsTableName,
        {
          otherSettingsTableFieldNameOfSetting: otherSettingsSecondsToThink,
          otherSettingsTableFieldValueAsInt: 10,
          otherSettingsTableFieldGroup: 1,
        },
      );
      await db.insert(otherSettingsTableName, {
        otherSettingsTableFieldNameOfSetting: otherSettingsChainQuestions,
        otherSettingsTableFieldValueAsInt: 0,
        otherSettingsTableFieldGroup: 2,
      });
      await db.insert(otherSettingsTableName, {
        otherSettingsTableFieldNameOfSetting: otherSettingsRestingTime,
        otherSettingsTableFieldValueAsInt: 2,
        otherSettingsTableFieldGroup: 3,
      });
      await db.insert(otherSettingsTableName, {
        otherSettingsTableFieldNameOfSetting: otherSettingsTextToSpeechOn,
        otherSettingsTableFieldValueAsInt: 0,
        otherSettingsTableFieldGroup: 4,
      });

      list = await db.rawQuery(
        'SELECT * FROM $otherSettingsTableName',
      );
      Logger().d('othersettingslist after default filling: $list');
    }
  }

  static Future<Database> functionToInitializeSettingsDatabase() async {
    /// The database is being created as soon as an instance of it is being
    /// created with instance.database.
    Database db = await instance.database;
    Logger().d('SettingsDatabase $db created');
    return db;
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

  static Future<int> getAskOfDifficulty({required int difficultyAsInt}) async {
    Database db = await instance.database;
    final ask = await db.rawQuery(
        'SELECT $difficultySettingsTableFieldAsk FROM $difficultySettingsTableName WHERE $difficultySettingsTableFieldDifficultyAsInt = ?',
        [difficultyAsInt]);

    return int.parse(ask[0].values.first.toString());
  }

  static Future<int> getValueOfOtherSetting(
      {required String nameOfOtherSetting}) async {
    Database db = await instance.database;
    final ask = await db.rawQuery(
        'SELECT $otherSettingsTableFieldValueAsInt FROM $otherSettingsTableName WHERE $otherSettingsTableFieldNameOfSetting = ?',
        [nameOfOtherSetting]);

    return int.parse(ask[0].values.first.toString());
  }

  static Future<int> updateValueOfOtherSetting(
      {required String nameOfOtherSetting, required int value}) async {
    Database db = await instance.database;
    final update = await db.rawUpdate(
        'UPDATE $otherSettingsTableName SET $otherSettingsTableFieldValueAsInt = ? WHERE $otherSettingsTableFieldNameOfSetting = ?',
        [value, nameOfOtherSetting]);
    return update;
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

  static Future<int> toggleAskDifficulty({required int difficultyAsInt}) async {
    Database db = await instance.database;
    int currentAsk = await getAskOfDifficulty(difficultyAsInt: difficultyAsInt);

    /// When only 1 selected difficulty is left, deselecting must not be allowed, because at least one difficulty
    /// has to be selecte at any time. Therefor we need to count the selected difficulties before we decide
    /// if we can deselect it or not
    final numberOfaskabledifficulties = await db.rawQuery(
        'SELECT COUNT(*) FROM $difficultySettingsTableName WHERE $difficultySettingsTableFieldAsk = ?',
        [1]);

    bool deselectingAllowed = false;
    if (int.parse(numberOfaskabledifficulties.first['COUNT(*)'].toString()) >
        1) {
      deselectingAllowed = true;
    }
    final updated = await db.rawUpdate(
        'UPDATE $difficultySettingsTableName SET $difficultySettingsTableFieldAsk = ? WHERE $difficultySettingsTableFieldDifficultyAsInt= ?',
        [
          currentAsk == 0
              ? 1
              : deselectingAllowed
                  ? 0
                  : 1,
          difficultyAsInt,
        ]);

    return updated;
  }

  static Future<int> toggleAskMarkedAs({required String statusName}) async {
    Database db = await instance.database;
    int currentAsk =
        await getValueOfOtherSetting(nameOfOtherSetting: statusName);

    /// When only 1 selected status is left, deselecting must not be allowed, because at least one status
    /// has to be selecte at any time. Therefor we need to count the selected statuses before we decide
    /// if we can deselect it or not

    ///otherSettingsTableFieldGroup 0 refers to the [questionStatuses]
    final numberOfaskableStatuses = await db.rawQuery(
        'SELECT COUNT(*) FROM $otherSettingsTableName WHERE $otherSettingsTableFieldGroup = ? AND $otherSettingsTableFieldValueAsInt =?',
        [0, 1]);

    bool deselectingAllowed = false;
    if (int.parse(numberOfaskableStatuses.first['COUNT(*)'].toString()) > 1) {
      deselectingAllowed = true;
    }
    final updated = await db.rawUpdate(
        'UPDATE $otherSettingsTableName SET $otherSettingsTableFieldValueAsInt = ? WHERE $otherSettingsTableFieldNameOfSetting= ?',
        [
          currentAsk == 0
              ? 1
              : deselectingAllowed
                  ? 0
                  : 1,
          statusName,
        ]);

    return updated;
  }

  static Future<List> getAllAskableStatusesAsInt() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> allAskableStatusesAsMap = await db.rawQuery(
        'SELECT $otherSettingsTableFieldNameAsInt FROM $otherSettingsTableName WHERE $otherSettingsTableFieldValueAsInt = ? AND $otherSettingsTableFieldGroup = ?',
        [1, 0]);
    final askableStatusesList = <int>[];
    for (Map map in allAskableStatusesAsMap) {
      askableStatusesList
          .add(map[SettingsDatabaseHelper.otherSettingsTableFieldNameAsInt]);
    }
    return askableStatusesList;
  }

  static Future<SettingsModel> getAllSettings() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> allCategorySettings =
        await db.rawQuery('SELECT * FROM $categorySettingsTableName');

    List<CategorySettingsModel> categorySettingsModelList = [];

    if (allCategorySettings.isEmpty) {
      for (QuestionCategory element in QuestionCategory.values) {
        categorySettingsModelList.add(CategorySettingsEntity.fromEnumValue(
                questionCategoryEnumValue: element)
            .toModel());
      }
    } else {
      for (Map<String, dynamic> rowMap in allCategorySettings) {
        categorySettingsModelList
            .add(CategorySettingsEntity.fromMap(rowMap)!.toModel());
      }
    }

    List<Map<String, dynamic>> allDifficultySettings =
        await db.rawQuery('SELECT * FROM $difficultySettingsTableName');

    List<DifficultySettingsModel> difficultySettingsModelList = [];

    if (allDifficultySettings.isEmpty) {
      for (DifficultyEnum element in DifficultyEnum.values) {
        difficultySettingsModelList.add(
            DifficultySettingsEntity.fromEnumValue(difficultyEnum: element)
                .toModel());
      }
    } else {
      for (Map<String, dynamic> rowMap in allDifficultySettings) {
        difficultySettingsModelList
            .add(DifficultySettingsEntity.fromMap(rowMap).toModel());
      }
    }

    /// Statuses are "marked as favorite", "marked as dont ask again" and "unmarked"
    List<Map<String, dynamic>> allStatusSettings = [];
    List<Map<String, dynamic>> askUnmarkedSetting = await db.rawQuery(
        'SELECT * FROM $otherSettingsTableName WHERE  $otherSettingsTableFieldNameOfSetting =?',
        [otherSettingsAskUnmarkedStatus]);

    List<Map<String, dynamic>> askDontAskAgainSetting = await db.rawQuery(
        'SELECT * FROM $otherSettingsTableName WHERE  $otherSettingsTableFieldNameOfSetting =?',
        [otherSettingsDontAskAgainStatus]);
    List<Map<String, dynamic>> askFavoritedSetting = await db.rawQuery(
        'SELECT * FROM $otherSettingsTableName WHERE  $otherSettingsTableFieldNameOfSetting =?',
        [otherSettingsAskFavoritedStatus]);

    allStatusSettings.addAll(askUnmarkedSetting);
    allStatusSettings.addAll(askDontAskAgainSetting);
    allStatusSettings.addAll(askFavoritedSetting);
    List<QuestionStatusSettingsModel> questionStatusSettingsModelList = [];

    for (Map<String, dynamic> rowMap in allStatusSettings) {
      questionStatusSettingsModelList
          .add(QuestionStatusSettingsEntity.fromMap(rowMap).toModel());
    }

    //! secondsToThink:
    final secondsToThinkIsActive = await getValueOfOtherSetting(
        nameOfOtherSetting: otherSettingsSecondsToThinkActive);

    final secondsToThink = await getValueOfOtherSetting(
        nameOfOtherSetting: otherSettingsSecondsToThink);

    final thinkingTimeModel = ThinkingTimeEntity(
            active: secondsToThinkIsActive, secondsToThink: secondsToThink)
        .toModel();

    //! Text to speech
    final textToSpeechOnAsInt = await getValueOfOtherSetting(
        nameOfOtherSetting: otherSettingsTextToSpeechOn);
    final textToSpeechOn = intToBool(textToSpeechOnAsInt);

    //! Resting time
    final restingTimeInSeconds = await getValueOfOtherSetting(
        nameOfOtherSetting: otherSettingsRestingTime);

    //! Chain questions
    final chainQuestionsAsInt = await getValueOfOtherSetting(
        nameOfOtherSetting: otherSettingsChainQuestions);
    final chainQuestionsOn = intToBool(chainQuestionsAsInt);

    //--------------------------------------------------------------------------
    return SettingsModel(
      categorySettingsModelList: categorySettingsModelList,
      difficultySettingsModelList: difficultySettingsModelList,
      questionStatusSettingsModelList: questionStatusSettingsModelList,
      thinkingTimeModel: thinkingTimeModel,
      textToSpeechOn: textToSpeechOn,
      restingTime: restingTimeInSeconds,
      chainQuestionsOn: chainQuestionsOn,
    );
  }
}
