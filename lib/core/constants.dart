import 'package:flutter/foundation.dart';

abstract class UiConstant {
  static const double horizontalPadding = 18.0;
}

dPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}
