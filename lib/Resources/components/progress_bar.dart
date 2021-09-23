// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sort_constructors_first

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
              decoration: BoxDecoration(
                gradient: gradient ?? const LinearGradient(colors: [Colors.deepPurple, Colors.blue, Colors.greenAccent]),
              ),
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
              ProgressIcon(selected: currentValue >= 0 ? true : false, activeColor: Colors.deepPurple, show: true),
              for (int i = 0; i < 3; i++) ProgressIcon(),
              ProgressIcon(selected: currentValue >= 4 ? true : false, activeColor: Colors.blue, show: true),
              for (int i = 0; i < 2; i++) ProgressIcon(),
              ProgressIcon(
                selected: currentValue >= 7 ? true : false,
                activeColor: Colors.greenAccent,
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
          color: selected ? Colors.transparent : Colors.grey[300], border: Border.all(color: Colors.white),
          // borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProgressIcon extends StatelessWidget {
  bool selected;
  IconData icon;
  Color activeColor;
  bool show;

  ProgressIcon({
    this.selected = false,
    this.show = false,
    this.icon = Icons.check,
    this.activeColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: show ? 1 : 0,
      child: Tooltip(
        message: selected ? 'Keep Up the Good Work!' : 'Complete More Steps!',
        triggerMode: TooltipTriggerMode.tap,
        decoration: BoxDecoration(
          color: selected ? activeColor : Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: selected ? activeColor : Colors.grey, width: 3),
            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2, offset: Offset(1, 1))],
          ),
          child: Icon(icon, size: selected ? 28 : 24, color: selected ? activeColor : Colors.grey),
        ),
      ),
    );
  }
}

// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

// ignore: must_be_immutable

class ProgressBar2 extends StatelessWidget {
  int step;
  Gradient gradient;
  int currentValue;

  /// • Variation for Progress bar.
  ///
  /// • For now please do not edit [step] parameter which is equal to 7.
  ///
  /// • TODO: This component needs rework. [#1]
  ProgressBar2({
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
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < step; i++) Expanded(child: ProgressTile2(selected: currentValue > i ? true : false))
              ],
            ),
          ),

          /// [#1]
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProgressIcon(selected: currentValue >= 0 ? true : false, activeColor: Colors.deepPurple, show: true),
              for (int i = 0; i < 3; i++) ProgressIcon(),
              ProgressIcon(selected: currentValue >= 4 ? true : false, activeColor: Colors.blue, show: true),
              for (int i = 0; i < 2; i++) ProgressIcon(),
              ProgressIcon(
                selected: currentValue >= 7 ? true : false,
                activeColor: Colors.greenAccent,
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
class ProgressTile2 extends StatelessWidget {
  bool selected;
  ProgressTile2({this.selected = false});

  @override
  Widget build(BuildContext context) {
    ///
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 700),
          width: selected ? MediaQuery.of(context).size.width / 7.7 : 0,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              topRight: selected ? Radius.circular(5) : Radius.circular(0),
              bottomRight: selected ? Radius.circular(5) : Radius.circular(0),
            ),
            border: Border.all(color: Colors.white, width: 0.0),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 700),
          width: selected ? 0 : MediaQuery.of(context).size.width / 7.7,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              bottomRight: Radius.circular(5),
              topLeft: selected ? Radius.circular(0) : Radius.circular(5),
              bottomLeft: selected ? Radius.circular(0) : Radius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}

// return Expanded(
// child: Container(
// width: 50,
// height: 20,
// color: selected ? Colors.transparent : Colors.grey[300],
// alignment: Alignment.centerLeft,
// child: AnimatedContainer(
// duration: Duration(seconds: 1),
// width: selected ? 50 : 0,
// height: 20,
// color: selected ? Colors.transparent : Colors.grey[300],
// ),
// ),
// );
