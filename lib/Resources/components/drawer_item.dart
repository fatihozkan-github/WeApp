import 'package:flutter/material.dart';

class DrawerItem {
  DrawerItem({
    this.title,
    this.icon,
  }) : assert(icon is IconData || icon is Widget, 'TabItem only support IconData and Widget');

  String title;
  IconData icon;
}
