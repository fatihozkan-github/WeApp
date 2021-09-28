// ignore_for_file: curly_braces_in_flow_control_structures, sort_child_properties_last

import 'package:flutter/material.dart';

class TextOverFlowHandler extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  /// • This widget automatically detects if a text widget reaches its overflow
  /// limit and makes the text slide.
  ///
  /// • [child] parameter is required.
  ///
  TextOverFlowHandler({
    @required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(seconds: 4),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(seconds: 1),
  });

  @override
  _TextOverFlowHandlerState createState() => _TextOverFlowHandlerState();
}

class _TextOverFlowHandlerState extends State<TextOverFlowHandler> {
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.child,
      scrollDirection: widget.direction,
      controller: scrollController,
    );
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients)
        await scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: widget.animationDuration, curve: Curves.ease);
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients)
        await scrollController.animateTo(0.0, duration: widget.backDuration, curve: Curves.easeOut);
    }
  }
}
