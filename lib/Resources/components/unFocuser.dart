import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class UnFocuser extends StatelessWidget {
  /// • Deals with focus problems of text fields.
  UnFocuser({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (e) {
        final rb = context.findRenderObject() as RenderBox;
        final result = BoxHitTestResult();
        rb.hitTest(result, position: e.position);

        for (final e in result.path) {
          if (e.target is RenderEditable || e.target is IgnoreUnfocuserRenderBox) {
            return;
          }
        }

        final primaryFocus = FocusManager.instance.primaryFocus;

        if (primaryFocus.context.widget is EditableText) {
          primaryFocus.unfocus();
        }
      },
      child: child,
    );
  }
}

class IgnoreUnfocuser extends SingleChildRenderObjectWidget {
  IgnoreUnfocuser({@required this.child}) : super(child: child);

  final Widget child;

  @override
  IgnoreUnfocuserRenderBox createRenderObject(BuildContext context) => IgnoreUnfocuserRenderBox();
}

class IgnoreUnfocuserRenderBox extends RenderPointerListener {}
