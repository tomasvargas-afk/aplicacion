import 'package:flutter/material.dart';

/// Shorthand accessors to cut down on `Theme.of(context)...` repetition.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Size get screenSize => MediaQuery.sizeOf(this);

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? colors.error : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
