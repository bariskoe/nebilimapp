import 'package:flutter/material.dart';

import 'package:nebilimapp/ui/standard_widgets/standard_ui_widgets.dart';

import '../custom_widgets/standard_page_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../ui/ui_constants/ui_constants.dart';

class SingleQuizPage extends StatelessWidget {
  const SingleQuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StandardPageWidget(
        appBarTitle: AppLocalizations.of(context)!.appTitle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: UiConstantsPadding.xxlarge),
          child: Column(
            children: const [
              SizedBox(
                height: UiConstantsPadding.xlarge,
              ),
              QuestionImageContainer(),
              SizedBox(
                height: UiConstantsPadding.xlarge,
              ),
              QuestionContainer(),
              SizedBox(
                height: UiConstantsPadding.xlarge,
              ),
              AnswerContainer(),
            ],
          ),
        ));
  }
}

class QuestionImageContainer extends StatelessWidget {
  const QuestionImageContainer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.25,
      width: double.infinity,
      decoration: StandardUiWidgets.standardBoxDecoration(context: context),
      child: const Icon(
        Icons.abc_outlined,
        color: Colors.red,
      ),
    );
  }
}

class QuestionContainer extends StatelessWidget {
  const QuestionContainer({Key? key}) : super(key: key);

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
                  const Expanded(
                    child: QuestionHeadlineWidget(child: Text('Kategorie')),
                  ),
                  Expanded(
                    child: QuestionHeadlineWidget(child: Text('Schwierigkeit')),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(UiConstantsPadding.regular),
                      child: Center(
                          child: Text(
                              'Was ist die Hauptstadt von Deutschland?')))),
              Row(
                children: [
                  Expanded(child: QuestionHeadlineWidget(child: Text('Weg'))),
                  Expanded(child: QuestionHeadlineWidget(child: Text('Play'))),
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
  const AnswerContainer({Key? key}) : super(key: key);
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
            children: [
              QuestionHeadlineWidget(child: Text('Antwort')),
              Center(
                child: AnimatedContainer(
                    color: Colors.red,
                    height: 30,
                    duration: Duration(seconds: 1),
                    child: Text('Berlin')),
              ),
            ],
          )),
    );
  }
}
