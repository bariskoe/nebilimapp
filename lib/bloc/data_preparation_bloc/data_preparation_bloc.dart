import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/failures/failures.dart';
import '../../domain/usecases/data_preparation_usecases.dart';

part 'data_preparation_event.dart';
part 'data_preparation_state.dart';

class DataPreparationBloc
    extends Bloc<DataPreparationEvent, DataPreparationState> {
  final DataPreparationUsecases dataPreparationUsecases;

  DataPreparationBloc({
    required this.dataPreparationUsecases,
  }) : super(DataPreparationInitial()) {
    // on<>((event, emit) {

    // });

    on<DataPreparationEventUpdateQuestionDatabaseIfNeccessary>(
        (event, emit) async {
      Either<Failure, bool> updated =
          await dataPreparationUsecases.updateQuestionDatabaseIfNeccessary();

      updated.fold(
        (l) => emit(
          DataPreparationStateQuestionDatabaseUpdateWentWrong(),
        ),
        (r) => emit(
          DataPreparationStateQuestionDatabaseUpdateFinished(
              questionDatabaseUpdateWasNecessary: r),
        ),
      );
    });

    on<DataPreparationEventInitializeSettingsDatabase>((event, emit) async {
      Either<Failure, Database> failureOrDatabaseInitialized =
          await dataPreparationUsecases.initializeSettingsDatabase();
      failureOrDatabaseInitialized.fold(
          (l) => emit(
                DataPreparationStateQuestionDatabaseUpdateWentWrong(),
              ),
          (r) => null);
    });
  }
}
