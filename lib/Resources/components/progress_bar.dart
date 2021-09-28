// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sort_constructors_first

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProgressBar extends StatelessWidget {
  int step;
  Gradient gradient;
  int currentValue;

  /// • Progress bar for user profile.
  ///
  /// • For now please do not edit [step] parameter which is equal to 7.
  ///
  /// • TODO: This component needs rework. [#1]
  ProgressBar({
    this.step = 7,
    this.currentValue = 0,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(gradient: gradient ?? LinearGradient(colors: [Color(0xFFff4d00), Color(0xFFff9a00)])),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < currentValue; i++) ProgressTile(selected: true),
                  for (int i = 0; i < step - currentValue; i++) ProgressTile(selected: false),
                ],
              ),
            ),
          ),

          /// [#1]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProgressIcon(selected: currentValue >= 0 ? true : false, activeColor: Colors.deepOrange, show: true),
              for (int i = 0; i < 3; i++) ProgressIcon(),
              ProgressIcon(selected: currentValue >= 4 ? true : false, activeColor: Color(0xFFff9800), show: true),
              for (int i = 0; i < 2; i++) ProgressIcon(),
              ProgressIcon(
                selected: currentValue >= 7 ? true : false,
                activeColor: Colors.orangeAccent,
                show: true,
                icon: Icons.star_border_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ProgressTile extends StatelessWidget {
  bool selected;
  ProgressTile({this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        width: 50,
        height: 20,
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        foregroundDecoration: BoxDecoration(
          color: selected ? Colors.transparent : Colors.grey[300],
          border: Border.all(color: Colors.white),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProgressIcon extends StatefulWidget {
  bool selected;
  bool show;
  IconData icon;
  Color activeColor;

  ProgressIcon({
    this.selected = false,
    this.show = false,
    this.icon = Icons.check,
    this.activeColor = Colors.green,
  });

  @override
  State<ProgressIcon> createState() => _ProgressIconState();
}

class _ProgressIconState extends State<ProgressIcon> {
  final ConfettiController _confettiController = ConfettiController(duration: Duration(seconds: 1));

  @override
  void didUpdateWidget(covariant ProgressIcon oldWidget) {
    if (widget.selected && !oldWidget.selected) {
      _confettiController.play();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.show ? 1 : 0,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        colors: [Colors.deepOrange, Color(0xFFff9800), Colors.orangeAccent],
        child: widget.show
            ? Tooltip(
                message: widget.selected ? 'Keep Up the Good Work!' : 'Complete More Steps!',
                triggerMode: TooltipTriggerMode.tap,
                decoration: BoxDecoration(
                  color: widget.selected ? widget.activeColor : Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _getBody())
            : _getBody(),
      ),
    );
  }

  _getBody() => AnimatedContainer(
        duration: const Duration(milliseconds: 700),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: widget.selected ? widget.activeColor : Colors.grey, width: 3),
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(1, 1))],
        ),
        child: Icon(widget.icon, size: widget.selected ? 28 : 24, color: widget.selected ? widget.activeColor : Colors.grey),
      );
}
