import 'package:flutter/foundation.dart';

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

  String get displayForDropDown {
    switch (this) {
      case QuantityUnit.GRAM:
        return 'Grammes';
      case QuantityUnit.LITER:
        return 'Litre';
      case QuantityUnit.PIECE:
        return 'Pièce';
      default:
        return 'Unit is null';
    }
  }

}