import 'dart:ui';

import 'package:flutter/material.dart';

class TabHome {
  int id;
  String title, description, iconSrc;
  Color color;

  TabHome({
    required this.id,
    required this.title,
    this.description = 'Build and animate an iOS app from scratch',
    this.iconSrc = "assets/icons/ios.svg",
    this.color = const Color(0xFF7553F6),
  });
}

final List<TabHome> tabHomes = [
  TabHome(
    id: 1,
    title: "Estado doadores",
    color: Colors.red.shade400,
  ),
  TabHome(
    id: 2,
    title: "IMC",
    color: Colors.cyan.shade400,
  ),
  TabHome(
    id: 3,
    title: "Percentual de obesos",
    color: Colors.deepPurpleAccent.shade400,
  ),
  TabHome(
    id: 4,
    title: "Idade média por Tipo Sanguíneo",
    color: Colors.orange.shade400,
  ),
  TabHome(
    id: 5,
    title: "Doadores",
    color: Colors.purple.shade400,
  ),
];


