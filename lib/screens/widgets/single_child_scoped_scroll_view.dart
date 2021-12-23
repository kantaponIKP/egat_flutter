import 'package:flutter/widgets.dart';

class SingleChildScopedScrollView extends StatelessWidget {
  final Widget child;

  const SingleChildScopedScrollView({required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
