import 'package:egat_flutter/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HorizontalStepIndicator extends StatelessWidget {
  final int index;
  final List<HorizontalStepItem> steps;
  final HorizontalStepIndicatorTheme theme;
  final bool scrollable;
  final bool highlightDoneStep;

  HorizontalStepIndicator({
    required this.steps,
    this.scrollable = true,
    this.highlightDoneStep = false,
    this.index = 0,
    this.theme = HorizontalStepIndicatorTheme.White,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    // Padding(
      // padding: const EdgeInsets.only(left:60,right:60,),
      // child: 
      _buildStepper();
    // );
  }

  Widget _buildStep(
    HorizontalStepItem step, {
    required int stepIndex,
    bool done = false,
    bool selected = false,
    required HorizontalStepIndicatorTheme theme,
  }) {
    if (done) {
      if (highlightDoneStep) {
        return _buildStepDoneHighlighted(
          step,
          theme: theme,
        );
      } else {
        return _buildStepDone(
          step,
          theme: theme,
        );
      }
    }

    if (selected) {
      return _buildStepSelected(
        step: step,
        stepIndex: stepIndex,
        theme: theme,
      );
    }

    return _buildStepNotSelected(
      step: step,
      stepIndex: stepIndex,
      theme: theme,
    );
  }

  Widget _buildStepDone(
    HorizontalStepItem step, {
    required HorizontalStepIndicatorTheme theme,
  }) {
    return Row(
      children: [
        AnimatedContainer(
          width: 20.0,
          height: 12.0,
          alignment: Alignment.center,
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      ],
    );
  }

  Widget _buildStepDoneHighlighted(
    HorizontalStepItem step, {
    required HorizontalStepIndicatorTheme theme,
  }) {
    return Row(
      children: [
         AnimatedContainer(
          width: 20.0,
          height: 12.0,
          alignment: Alignment.center,
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      ],
    );
  }

  Widget _buildStepNotSelected({
    required int stepIndex,
    required HorizontalStepItem step,
    required HorizontalStepIndicatorTheme theme,
  }) {
    return Row(
      children: [
        AnimatedContainer(
          width: 20.0,
          height: 12.0,
          alignment: Alignment.center,
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      ],
    );
  }

  Widget _buildStepper() {
    if (scrollable) {
      return _buildStepperScrollable();
    } else {
      return _buildStepperExpanded();
    }
  }

  Padding _buildStepperExpanded() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ..._loopSteps(
              selectedStep: index,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildStepperScrollable() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 30,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ..._loopSteps(
                      selectedStep: index,
                      theme: theme,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepSelected({
    required int stepIndex,
    required HorizontalStepItem step,
    required HorizontalStepIndicatorTheme theme,
  }) {
    return Row(
      children: [
        AnimatedContainer(
          width: 40.0,
          height: 12.0,
          alignment: Alignment.center,
          duration: const Duration(seconds: 2),
          curve: Curves.fastOutSlowIn,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      ],
    );
  }

  List<Widget> _loopSteps({
    required int selectedStep,
    required HorizontalStepIndicatorTheme theme,
  }) {
    var list = <Widget>[];
    var index = 0;

    for (var step in steps) {
      bool done = false;
      bool selected = false;

      if (index == selectedStep) {
        selected = true;
      }

      if (index < selectedStep) {
        done = true;
      }

      list.add(
        _buildStep(
          step,
          stepIndex: index,
          done: done,
          selected: selected,
          theme: theme,
        ),
      );

      index += 1;
    }

    return list;
  }
}

enum HorizontalStepIndicatorTheme {
  White,
  Dark,
}

class HorizontalStepItem {
  String title;

  HorizontalStepItem({required this.title});
}
