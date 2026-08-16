import '../constants/app_strings.dart';

/// Simple form-field validators shared by every text field in the app.
abstract class Validators {
  Validators._();

  static final _emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (!_emailRegExp.hasMatch(value!.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    if (value!.length < 8) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static String? Function(String?) matches(String Function() other) {
    return (value) {
      if (value != other()) return AppStrings.passwordsDoNotMatch;
      return null;
    };
  }

  static String? positiveNumber(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    final parsed = double.tryParse(value!.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return 'Ingresa un número válido';
    }
    return null;
  }
}
