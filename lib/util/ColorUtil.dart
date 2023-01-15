import 'package:flutter/material.dart';

class ColorUtil {
  static List<LinearGradient> gradients = [
    const LinearGradient(
      colors: [
        Colors.white,
        Colors.grey,
      ],
      stops: [
        0.0,
        1.0,
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
    const LinearGradient(
      colors: [
        Colors.white,
        Color(0xff7ba2ef),
      ],
      stops: [
        0.0,
        1.0,
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    )
  ];
}
