import 'package:equatable/equatable.dart';

abstract class Failure {}

class GeneralFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class DatabaseFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class AllfilterConformQuestionsRecentlyAskedFailure extends Failure
    with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class NotYetCoveredCaseExceptionFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class NoFilterConformQuestionsExistFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class SharedPrefsKeyDoesNotExistFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}
