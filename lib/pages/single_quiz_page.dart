import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../bloc/animation_bloc/bloc/animation_bloc.dart';
import '../bloc/question_bloc/bloc/question_bloc.dart';
import '../bloc/settings_bloc/bloc/settings_bloc.dart';
import '../constants/assets.dart';
import '../custom_widgets/standard_page_widget.dart';
import '../custom_widgets/thinking_time_indicator.dart';
import '../database/settings_database_helper.dart';
import '../dependency_injection.dart';
import '../domain/entities/question_status_entity.dart';
import '../locale/locale.dart';
import '../models/question_insertion_model.dart';
import '../models/question_model.dart';
import '../routing.dart';
import '../ui/standard_widgets/dialog_scaffold.dart';
import '../ui/standard_widgets/standard_ui_widgets.dart';
import '../ui/ui_constants/ui_constants.dart';
import '../utils/utils.dart';

class SingleQuizPage extends StatelessWidget {
  const SingleQuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // getIt<QuestionBloc>().add(QuestionEventGetFilterConfromQuestion());

    String currentLocale = Intl.getCurrentLocale();
    Logger().d('currentlocale is $currentLocale');
    return BlocConsumer<QuestionBloc, QuestionState>(
      listener: (context, state) async {
        if (state is QuestionStateAllfilterConformQuestionsRecentlyAsked) {
          getIt<AnimationBloc>().add(AnimationEventResetAnimation());
          await dialogScaffold(context,
              cancelButtonChild: Text(S.of(context).cancel),
              onCancelPressed: () {
                getIt<QuestionBloc>()
                    .add(QuestionEventTurnBackToInitialState());
              },
              content: Text(S.of(context).noQuestionsLeftDialogContent),
              onOkpressed: () {
                getIt<QuestionBloc>()
                    .add(QuestionEventClearRecentlyAskedTable());
                getIt<QuestionBloc>()
                    .add(QuestionEventGetFilterConfromQuestion());
              });
        } else if (state is QuestionStateNoFilterConformQuestionsExist) {
          Navigator.pushNamed(context, Routing.settingsPage);

          await dialogScaffold(context,
              cancelButtonChild: Text(S.of(context).cancel),
              onCancelPressed: () {},
              content:
                  Text(S.of(context).noFilterConformQuestionsDialogContent),
              onOkpressed: () {});
        }
      },
      builder: (context, state) {
        return StandardPageWidget(
            appbarActions: [
              IconButton(
                  onPressed: (() =>
                      Navigator.pushNamed(context, Routing.settingsPage)),
                  icon: const Icon(Icons.settings))
            ],
            willPop: false,
            appBarTitle: AppLocalizations.of(context)!.appTitle,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: UiConstantsPadding.xxlarge),
              child: state is QuestionStateLoaded
                  ? QuestionLoadedWidget(
                      state: state,
                    )
                  : state is QuestionStateInitial
                      ? const QuestionInitialWidget()
                      : state is QuestionStateAllfilterConformQuestionsRecentlyAsked
                          ? const QuestionInitialWidget()
                          : state is QuestionStateNoFilterConformQuestionsExist
                              ? const QuestionInitialWidget()
                              : state is QuestionStateNotYetCoveredFailure
                                  ? const CaseNotYetCoveredWidget()
                                  : const Text('State not yet covered'),
            ));
      },
    );
  }
}

class QuestionInitialWidget extends StatelessWidget {
  const QuestionInitialWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () {
        getIt<QuestionBloc>().add(QuestionEventClearRecentlyAskedTable());
        getIt<QuestionBloc>().add(QuestionEventGetFilterConfromQuestion());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 10),
            borderRadius: BorderRadius.circular(UiConstantsRadius.large)),
        child: Text(
          S.of(context).questionInitialWidgetStartPlaying,
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }
}

class CaseNotYetCoveredWidget extends StatelessWidget {
  const CaseNotYetCoveredWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('State not yet covered'),
        IconButton(
            onPressed: () {
              getIt<QuestionBloc>()
                  .add(QuestionEventGetFilterConfromQuestion());
            },
            icon: const Icon(Icons.play_arrow))
      ],
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
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          height: UiConstantsPadding.xlarge,
        ),
        const QuestionImageContainer(),
        const SizedBox(
          height: UiConstantsPadding.xlarge,
        ),
        QuestionContainer(questionModel: state.questionModel),
        const SizedBox(
          height: UiConstantsPadding.xlarge,
        ),
        AnswerContainer(
            child: state.showAnswer
                ? AnswerBox(text: state.questionModel.questionAnswerText)
                : GestureDetector(
                    child: AnswerBox(
                      text: S.of(context).questionLoadedWidgetTapForAnswer,
                      backgrondColor: Colors.grey.shade300,
                    ),
                    onTap: () {
                      getIt<QuestionBloc>().add(const QuestionEventShowAnswer(
                          afterPressingShowAnswer: true));
                    },
                  )),
        const Spacer(),
        SettingsBar(),
        const Spacer()
      ],
    );
  }
}

class SettingsBar extends StatelessWidget {
  const SettingsBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SettingsBloc, SettingsState>(builder: ((context, state) {
      if (state is SettingsStateLoaded) {
        final ttsOn = state.settingsModel.textToSpeechOn;
        final primaryColor = Theme.of(context).colorScheme.primary;
        final inactiveColor = Theme.of(context).colorScheme.tertiary;

        return Container(
          height: size.height * 0.05,
          child: FittedBox(
            child: Row(
              children: [
                GestureDetector(
                  onTap: (() => getIt<SettingsBloc>().add(
                        SettingsEventUpdateOtherSetting(
                          otherSettingsName: SettingsDatabaseHelper
                              .otherSettingsTextToSpeechOn,
                          newValue:
                              boolToInt(!state.settingsModel.textToSpeechOn),
                        ),
                      )),
                  child: Icon(
                    Icons.hearing,
                    color: ttsOn
                        ? Theme.of(context).colorScheme.primary
                        : inactiveColor,
                  ),
                )
              ],
            ),
          ),
        );
      } else {
        return Container();
      }
    }));
  }
}

class AnswerBox extends StatelessWidget {
  final String text;
  final Color? backgrondColor;
  const AnswerBox({
    required this.text,
    this.backgrondColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UiConstantsRadius.large),
          color: backgrondColor,
        ),
        margin: const EdgeInsets.all(UiConstantsPadding.regular),
        padding: const EdgeInsets.all(UiConstantsPadding.large),
        height: 60,
        child: Text(text));
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
  Logger().d('hasimage ist ${questionStateLoaded.questionModel.hasImage}');
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
                          questionModel.questionCategory.getCategoryIcon(),
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
                        Text('${questionModel.getOneBasedDifficulty}',
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
                    child: AutoSizeText(
                      questionModel.questionText,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: QuestionHeadlineWidget(
                    child: IconButton(
                      icon: questionModel.questionStatusModel == null
                          ? const Icon(Icons.delete_outline)
                          : questionModel.questionStatusModel!.questionStatus
                                  .isDontAskagain
                              ? const Icon(Icons.delete)
                              : const Icon(Icons.delete_outline),
                      onPressed: () {
                        getIt<QuestionBloc>().add(
                            QuestionEventToggleDontShowAgain(
                                questionId: questionModel.questionId));
                      },
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  )),
                  Expanded(
                      child: QuestionHeadlineWidget(
                          child: IconButton(
                    onPressed: () {
                      getIt<AnimationBloc>()
                          .add(AnimationEventResetAnimation());
                      getIt<QuestionBloc>()
                          .add(QuestionEventGetFilterConfromQuestion());
                    },
                    icon: const Icon(Icons.play_arrow,
                        key: ValueKey('playButton')),
                    color: Theme.of(context).colorScheme.onSecondary,
                  ))),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        getIt<QuestionBloc>().add(
                            QuestionEventToggleFavoriteStatus(
                                questionId: questionModel.questionId));
                      },
                      child: QuestionHeadlineWidget(
                        child: questionModel.questionStatusModel == null
                            ? Icon(
                                Icons.favorite_border,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              )
                            : questionModel.questionStatusModel!.questionStatus
                                    .isFavorited
                                ? Icon(
                                    Icons.favorite,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                  ),
                      ),
                    ),
                  ),
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
  final Function()? onTap;
  final Widget? child;
  const AnswerContainer({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: StandardUiWidgets.standardBoxDecoration(context: context),
      height: height * 0.2,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(
          UiConstantsRadius.regular,
        )),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuestionHeadlineWidget(
                child: Text(S.of(context).questionLoadedWidgetAnswerBoxTitle,
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary))),
            const Spacer(),
            child ?? Container(),
            BlocBuilder<AnimationBloc, AnimationState>(
              builder: (context, animationState) {
                if (animationState is AnimationInitial) {
                  return Align(
                    alignment: Alignment.bottomLeft,
                    child: ThinkingTimeIndicator(
                        height: 20,
                        totalAnimationDuration:
                            animationState.totalAnimationDuration,
                        width: 0,
                        onEnd: () {}),
                  );
                }
                if (animationState
                    is AnimationStateThinkingTimeAnimationRunning) {
                  return Align(
                    alignment: Alignment.bottomLeft,
                    child: ThinkingTimeIndicator(
                        height: 20,
                        totalAnimationDuration:
                            animationState.totalAnimationDuration,
                        width: MediaQuery.of(context).size.width -
                            UiConstantsPadding.xxlarge * 2,
                        onEnd: () {
                          getIt<AnimationBloc>().add(
                              AnimationEventThinkingTimeAnimationHasFinished());
                        }),
                  );
                }
                return Text(S.of(context).error);
              },
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
