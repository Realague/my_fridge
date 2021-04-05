import 'package:my_fridge/utils/utils.dart';

class Validators {
  static String? notEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid name';
    }
    return null;
  }

  static String? number(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid quantity';
    }

    if (!Utils.isNumber(value)) {
      return 'Must be a number';
    }

    return null;
  }

  static String? notNull(Object? value) {
    if (value == null) {
      return 'Required field';
    }
    return null;
  }
}
