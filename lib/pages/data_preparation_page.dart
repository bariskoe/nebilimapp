import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../bloc/data_preparation_bloc/data_preparation_bloc.dart';
import '../bloc/settings_bloc/bloc/settings_bloc.dart';
import '../custom_widgets/standard_page_widget.dart';
import '../dependency_injection.dart';
import '../locale/locale.dart';
import '../routing.dart';

class DataPreparationPage extends StatelessWidget {
  const DataPreparationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getIt<DataPreparationBloc>()
        .add(const DataPreparationEventInitializeSettingsDatabase());
    getIt<SettingsBloc>().add(const SettingsEventGetAllSettings());
    Future.delayed(Duration(seconds: 2), () async {
      getIt<DataPreparationBloc>()
          .add(const DataPreparationEventUpdateQuestionDatabaseIfNeccessary());
    });

    return BlocListener<DataPreparationBloc, DataPreparationState>(
      listener: (context, state) {
        if (state is DataPreparationStateQuestionDatabaseUpdateFinished) {
          Logger().d('pushing to SingleQuizPage');
          Navigator.pushNamed(context, Routing.singleQuizPage);
        }
      },
      child: StandardPageWidget(
        child: Center(
          //TODO: Make a widget for this
          child: Column(
            children: [
              Text(S.of(context).dataPreparationPagePreparingData),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
