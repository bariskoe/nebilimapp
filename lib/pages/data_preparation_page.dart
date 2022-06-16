import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nebilimapp/bloc/bloc/data_preparation_bloc.dart';
import 'package:nebilimapp/custom_widgets/standard_page_widget.dart';
import 'package:nebilimapp/dependency_injection.dart';
import 'package:nebilimapp/domain/usecases/data_preparation_usecases.dart';

import '../routing.dart';

class DataPreparationPage extends StatelessWidget {
  const DataPreparationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getIt<DataPreparationBloc>()
        .add(const DataPreparationEventUpdateQuestionDatabaseIfNeccessary());
    return BlocListener<DataPreparationBloc, DataPreparationState>(
      listener: (context, state) {
        if (state is DataPreparationStateQuestionDatabaseUpdateFinished) {
          Navigator.pushNamed(context, Routing.singleQuizPage);
        }
      },
      child: StandardPageWidget(
        child: Center(
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
