import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum PackingType { NONE, MILILITRE, LITER, GRAM, KILOGRAM, PIECE, PACKET, BOTTLE, CRATE, BOX, JAR, CAN, TUBE }

extension PackingTypeExtension on PackingType {
  String get name => describeEnum(this);

  String displayText(BuildContext context) {
    switch (this) {
      case PackingType.MILILITRE:
        return AppLocalizations.of(context)!.packing_type_mililitre + '(ml)';
      case PackingType.LITER:
        return AppLocalizations.of(context)!.packing_type_liter + '(l)';
      case PackingType.GRAM:
        return AppLocalizations.of(context)!.packing_type_gram + '(g)';
      case PackingType.KILOGRAM:
        return AppLocalizations.of(context)!.packing_type_kilogram + '(kg)';
      case PackingType.PIECE:
        return AppLocalizations.of(context)!.packing_type_piece + '(pces)';
      case PackingType.PACKET:
        return AppLocalizations.of(context)!.packing_type_packet + '(pqt)';
      case PackingType.BOTTLE:
        return AppLocalizations.of(context)!.packing_type_bottle + '(btlle)';
      case PackingType.CRATE:
        return AppLocalizations.of(context)!.packing_type_crate;
      case PackingType.BOX:
        return AppLocalizations.of(context)!.packing_type_box;
      case PackingType.JAR:
        return AppLocalizations.of(context)!.packing_type_jar;
      case PackingType.TUBE:
        return AppLocalizations.of(context)!.packing_type_tube;
      default:
        return AppLocalizations.of(context)!.packing_type_none;
    }
  }
}
