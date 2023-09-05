import 'package:flutter/material.dart';

class ScreenSizeHelper {

  /*화면 사이즈*/
  static Size getDisplaySize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /*화면 높이*/
  static double getDisplayHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /*화면 너비*/
  static double getDisplayWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /*화면 배율*/
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /*화면 상단바 사이즈*/
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }
}