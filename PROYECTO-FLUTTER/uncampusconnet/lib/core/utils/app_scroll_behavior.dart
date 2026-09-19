import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ======================================================
// SCROLL BEHAVIOR DE LA APP
// ======================================================
//
// Permite arrastrar con el mouse en listas (verticales y
// horizontales) en la web. Sin esto, Flutter Web solo
// permite scroll con la rueda del mouse o trackpad.

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}