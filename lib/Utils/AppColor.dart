import 'package:flutter/material.dart';

class AppColor{
  static const Color backGrey= Color.fromARGB(255,244,247,249);
  static const Color textGrey=Color.fromARGB(255,120, 141, 155);
  static const Color textBlack=Color.fromARGB(255,49,50,55);
  static const Color white= Color.fromARGB(255,255,255,255);
  static const Color appColor=Color.fromARGB(255, 196,164,252);
  static final Animation<Color> app_color_animate =new AlwaysStoppedAnimation<Color>(appColor);
}