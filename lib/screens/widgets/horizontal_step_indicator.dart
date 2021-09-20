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
    this.index = 1,
    this.theme = HorizontalStepIndicatorTheme.White,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildStepper();
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
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: theme == HorizontalStepIndicatorTheme.White
                ? neutralColor
                : neutralColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10000),
          ),
          child: Align(
            alignment: Alignment.center,
            child: const Icon(
              Icons.done,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              step.title,
              style: TextStyle(
                fontSize: 13,
                color: theme == HorizontalStepIndicatorTheme.White
                    ? Colors.black
                    : Colors.white70,
              ),
            ),
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
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: theme == HorizontalStepIndicatorTheme.White
                ? primaryColor
                : primaryColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10000),
          ),
          child: Align(
            alignment: Alignment.center,
            child: const Icon(
              Icons.done,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              step.title,
              style: TextStyle(
                fontSize: 13,
                color: theme == HorizontalStepIndicatorTheme.White
                    ? Colors.black
                    : Colors.white70,
              ),
            ),
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
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: neutralColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10000),
            border: Border.all(
              width: 0,
              color: neutralColor.withOpacity(0.6),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "$stepIndex",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              step.title,
              style: TextStyle(
                fontSize: 13,
                color: theme == HorizontalStepIndicatorTheme.White
                    ? Colors.black
                    : Colors.white70,
              ),
            ),
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
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        height: 40,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10000),
            border: Border.all(
              width: 1,
              color: primaryColor,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "$stepIndex",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              step.title,
              style: TextStyle(
                fontSize: 13,
                color: theme == HorizontalStepIndicatorTheme.White
                    ? Colors.black
                    : Colors.white70,
              ),
            ),
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
    var index = 1;

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
