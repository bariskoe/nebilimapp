part of 'data_preparation_bloc.dart';

abstract class DataPreparationState extends Equatable {
  const DataPreparationState();

  @override
  List<Object> get props => [];
}

class DataPreparationInitial extends DataPreparationState {}

class DataPreparationStateQuestionDatabaseUpdateFinished
    extends DataPreparationState {
  final bool questionDatabaseUpdateWasNecessary;

  const DataPreparationStateQuestionDatabaseUpdateFinished({
    required this.questionDatabaseUpdateWasNecessary,
  });

  @override
  List<Object> get props => [
        questionDatabaseUpdateWasNecessary,
      ];
}

class DataPreparationStateQuestionDatabaseUpdateWentWrong
    extends DataPreparationState {}
