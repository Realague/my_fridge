import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/utils/utils.dart';

class Validators {
  static String? notEmpty(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.error_empty;
    }
    return null;
  }

  static String? number(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.error_empty;
    }

    if (!Utils.isNumber(value)) {
      return AppLocalizations.of(context)!.error_wrong_quantity;
    }

    return null;
  }

  static String? notNull(BuildContext context, Object? value) {
    if (value == null) {
      return AppLocalizations.of(context)!.error_empty;
    }
    return null;
  }
}
