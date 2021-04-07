import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum QuantityUnit {
  GRAM, LITER, PIECE
}

extension QuantityUnitExtension on QuantityUnit {

  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case QuantityUnit.GRAM:
        return 'Grammes';
      case QuantityUnit.LITER:
        return 'cl';
      case QuantityUnit.PIECE:
        return 'piece';
      default:
        return 'Unit is null';
    }
  }

  String displayForDropDown(BuildContext context) {
    switch (this) {
      case QuantityUnit.GRAM:
        return AppLocalizations.of(context)!.quantity_unit_gram_display_for_dropdown;
      case QuantityUnit.LITER:
        return AppLocalizations.of(context)!.quantity_unit_liter_display_for_dropdown;
      case QuantityUnit.PIECE:
        return AppLocalizations.of(context)!.quantity_unit_piece_display_for_dropdown;
      default:
        return 'Unit is null';
    }
  }

}