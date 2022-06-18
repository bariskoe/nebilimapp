import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:nebilimapp/models/question_model.dart';

import '../bloc/question_bloc/bloc/question_bloc.dart';
import '../constants/assets.dart';
import '../custom_widgets/standard_page_widget.dart';
import '../dependency_injection.dart';
import '../ui/standard_widgets/standard_ui_widgets.dart';
import '../ui/ui_constants/ui_constants.dart';
import '../models/question_insertion_model.dart';

class SingleQuizPage extends StatelessWidget {
  const SingleQuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getIt<QuestionBloc>().add(QuestionEventGetRandomQuestion());
    String currentLocale = Intl.getCurrentLocale();
    Logger().d('currentlocale is $currentLocale');
    return BlocBuilder<QuestionBloc, QuestionState>(
      builder: (context, state) {
        return StandardPageWidget(
            willPop: false,
            appBarTitle: AppLocalizations.of(context)!.appTitle,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: UiConstantsPadding.xxlarge),
              child: state is QuestionStateLoaded
                  ? QuestionLoadedWidget(
                      state: state,
                    )
                  : Container(
                      child: Text('error'),
                    ),
            ));
      },
    );
  }
}

class QuestionLoadedWidget extends StatelessWidget {
  final QuestionStateLoaded state;

  const QuestionLoadedWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: UiConstantsPadding.xlarge,
        ),
        QuestionImageContainer(),
        const SizedBox(
          height: UiConstantsPadding.xlarge,
        ),
        QuestionContainer(questionModel: state.questionModel),
        const SizedBox(
          height: UiConstantsPadding.xlarge,
        ),
        AnswerContainer(answerText: state.questionModel.questionAnswerText),
      ],
    );
  }
}

class QuestionImageContainer extends StatelessWidget {
  const QuestionImageContainer({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<QuestionBloc, QuestionState>(
      builder: (context, state) {
        return Container(
          height: height * 0.25,
          width: double.infinity,
          decoration: StandardUiWidgets.standardBoxDecoration(context: context),
          child: (state is QuestionStateLoaded)
              ? _buildImage(questionStateLoaded: state)
              : const Icon(
                  Icons.abc_outlined,
                  color: Colors.red,
                ),
        );
      },
    );
  }
}

_buildImage({required QuestionStateLoaded questionStateLoaded}) {
  if (questionStateLoaded.questionModel.hasImage) {
    return Image.asset(

        ///Todo: Make the extension work to make this more beautiful
        "assets/${questionStateLoaded.questionModel.questionImageName}.${questionStateLoaded.questionModel.questionImageEnding.toString().split('.').last}");
  } else {
    return Image.asset(Assets.resourceFragezeichen);
  }
}

class QuestionContainer extends StatelessWidget {
  final QuestionModel questionModel;
  const QuestionContainer({
    Key? key,
    required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(
        UiConstantsRadius.regular,
      )),
      clipBehavior: Clip.antiAlias,
      child: Container(
          height: height * 0.25,
          width: double.infinity,
          decoration: StandardUiWidgets.standardBoxDecoration(context: context),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: QuestionHeadlineWidget(
                      child: Icon(
                          QuestionCategoryExtension.deserialize(
                                  questionModel.questionCategory)
                              .getCategoryIcon(),
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ),
                  Expanded(
                    child: QuestionHeadlineWidget(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        Text('${questionModel.questionDifficulty}',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary)),
                      ],
                    )),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(UiConstantsPadding.regular),
                  child: Center(
                    child: Text(
                      questionModel.questionText,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(child: QuestionHeadlineWidget(child: Text('Weg'))),
                  Expanded(
                      child: QuestionHeadlineWidget(
                          child: IconButton(
                    onPressed: () {
                      getIt<QuestionBloc>()
                          .add(QuestionEventGetRandomQuestion());
                    },
                    icon: Icon(Icons.play_arrow),
                    color: Theme.of(context).colorScheme.onSecondary,
                  ))),
                  Expanded(
                      child: QuestionHeadlineWidget(child: Text('Speichern'))),
                ],
              )
            ],
          )),
    );
  }
}

class QuestionHeadlineWidget extends StatelessWidget {
  final Widget child;
  const QuestionHeadlineWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UiConstantsSize.regular,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          border: const Border(bottom: BorderSide(width: 1))),
      child: Container(
        child: child,
      ),
    );
  }
}

class AnswerContainer extends StatelessWidget {
  final String answerText;
  const AnswerContainer({Key? key, required this.answerText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(
        UiConstantsRadius.regular,
      )),
      child: Container(
          decoration: StandardUiWidgets.standardBoxDecoration(context: context),
          height: height * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const QuestionHeadlineWidget(child: Text('Antwort')),
              Center(
                child: AnimatedContainer(
                    color: Colors.red,
                    height: 30,
                    duration: const Duration(seconds: 1),
                    child: Text(
                      answerText,
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
              ),
              Container()
            ],
          )),
    );
  }
}
