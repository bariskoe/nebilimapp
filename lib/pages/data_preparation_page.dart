import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/data_preparation_bloc/data_preparation_bloc.dart';
import '../custom_widgets/standard_page_widget.dart';
import '../database/settings_database_helper.dart';
import '../dependency_injection.dart';
import '../routing.dart';

class DataPreparationPage extends StatelessWidget {
  const DataPreparationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () async {
      //Initialize settings database
      await SettingsDatabaseHelper.functionToInitializeSettingsDatabase();
      getIt<DataPreparationBloc>()
          .add(const DataPreparationEventUpdateQuestionDatabaseIfNeccessary());
    });

    return BlocListener<DataPreparationBloc, DataPreparationState>(
      listener: (context, state) {
        if (state is DataPreparationStateQuestionDatabaseUpdateFinished) {
          Navigator.pushNamed(context, Routing.singleQuizPage);
        }
      },
      child: StandardPageWidget(
        child: Center(
          //TODO: Make a widget for this
          child: Column(
            children: const [
              Text('Preparing data. Please wait...'),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
