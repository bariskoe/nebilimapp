import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/settings_bloc/bloc/settings_bloc.dart';
import '../custom_widgets/standard_page_widget.dart';
import '../dependency_injection.dart';
import '../domain/entities/question_status_entity.dart';
import '../models/category_settings_model.dart';
import '../models/difficulty_settings_model.dart';
import '../models/question_insertion_model.dart';
import '../models/question_status_settings_model.dart';
import '../ui/ui_constants/ui_constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    getIt<SettingsBloc>().add(const SettingsEventGetAllSettings());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return StandardPageWidget(
          appBarTitle: 'Settings',
          child: SingleChildScrollView(
              child: Column(
            children: [
              /// Category selection container
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(UiConstantsPadding.large),
                      child: Text(
                        'Categories',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    _buildCategories(state),
                    const SizedBox(height: UiConstantsSize.large),
                    Padding(
                      padding: const EdgeInsets.all(UiConstantsPadding.large),
                      child: Text(
                        'Difficulties',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    _buildDifficulties(state),
                    const SizedBox(height: UiConstantsSize.large),
                    Padding(
                      padding: const EdgeInsets.all(UiConstantsPadding.large),
                      child: Text(
                        'Marked as...',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    _buildMarkedAs(state),
                  ],
                ),
              ),
            ],
          )),
        );
      },
    );
  }

  _buildCategories(SettingsState state) {
    _categorySymbolBuilder(SettingsStateLoaded state) {
      List<Widget> list = [];

      for (CategorySettingsModel model
          in state.settingsModel.categorySettingsModelList) {
        QuestionCategory questionCategory = model.questionCategory;
        list.add(GestureDetector(
          onTap: (() => getIt<SettingsBloc>().add(
              SettingsEventToggleAskCategory(
                  categoryAsInt: model.questionCategory.serialze()))),
          child: SettingsSymbol(
              name: model.questionCategory.name,
              icon: questionCategory.getCategoryIcon(),
              selected: model.ask),
        ));
      }
      return list;
    }

    if (state is SettingsStateLoaded) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstantsPadding.regular,
        ),
        child: Wrap(
          spacing: UiConstantsPadding.regular,
          runSpacing: UiConstantsPadding.regular,
          alignment: WrapAlignment.spaceEvenly,
          children: _categorySymbolBuilder(state),
        ),
      );
    } else {
      return Text('not Loaded state: $state');
    }
  }

  _buildDifficulties(SettingsState state) {
    _difficultySymbolBuilder(SettingsStateLoaded state) {
      List<Widget> list = [];

      for (DifficultySettingsModel model
          in state.settingsModel.difficultySettingsModelList) {
        DifficultyEnum difficultyEnum = model.difficultyEnum;
        list.add(GestureDetector(
          onTap: (() => getIt<SettingsBloc>().add(
              SettingsEventToggleAskDifficulty(
                  difficultyAsInt: difficultyEnum.getDifficultyAsInt))),
          child: SettingsSymbol(
              //TODO: make a name getter for the international name
              name:
                  '${difficultyEnum.getDifficultyAsInt + 1} : ${difficultyEnum.name}',
              icon: Icons.fitness_center,
              selected: model.ask),
        ));
      }
      return list;
    }

    if (state is SettingsStateLoaded) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstantsPadding.regular,
        ),
        child: Wrap(
          spacing: UiConstantsPadding.regular,
          runSpacing: UiConstantsPadding.regular,
          alignment: WrapAlignment.spaceEvenly,
          children: _difficultySymbolBuilder(state),
        ),
      );
    } else {
      return Text('not Loaded state: $state');
    }
  }

  _buildMarkedAs(SettingsState state) {
    _markedAsSymbolBuilder(SettingsStateLoaded state) {
      List<Widget> list = [];

      for (QuestionStatusSettingsModel model
          in state.settingsModel.questionStatusSettingsModelList) {
        QuestionStatus questionStatusEnum = model.questionStatus;
        list.add(GestureDetector(
          onTap: (() => getIt<SettingsBloc>().add(
              SettingsEventToggleAskMarkedAs(
                  statusName: questionStatusEnum.name))),
          child: SettingsSymbol(
              //TODO: make a name getter for the international name
              name: questionStatusEnum.getName(),
              icon: questionStatusEnum.getIcon(),
              selected: model.ask),
        ));
      }
      return list;
    }

    if (state is SettingsStateLoaded) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: UiConstantsPadding.regular,
        ),
        child: Wrap(
          spacing: UiConstantsPadding.regular,
          runSpacing: UiConstantsPadding.regular,
          alignment: WrapAlignment.spaceEvenly,
          children: _markedAsSymbolBuilder(state),
        ),
      );
    } else {
      return Text('not Loaded state: $state');
    }
  }
}

class SettingsSymbol extends StatelessWidget {
  const SettingsSymbol({
    Key? key,
    required this.name,
    required this.icon,
    required this.selected,
  }) : super(key: key);
  final String name;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UiConstantsPadding.regular),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(UiConstantsRadius.regular),
        border: Border.all(
            width: selected ? 4 : 1,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.tertiary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(width: UiConstantsPadding.small),
          Icon(icon,
              color: selected
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.tertiary)
        ],
      ),
    );
  }
}
