part of 'data_preparation_bloc.dart';

abstract class DataPreparationEvent extends Equatable {
  const DataPreparationEvent();

  @override
  List<Object> get props => [];
}

class DataPreparationEventUpdateQuestionDatabaseIfNeccessary
    extends DataPreparationEvent {
  const DataPreparationEventUpdateQuestionDatabaseIfNeccessary();

  @override
  List<Object> get props => [];
}
