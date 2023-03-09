import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum MealType { DISH, DRINK, APPETIZER, DESSERT, STARTER, OTHER }

extension MealTypeExtension on MealType {
  String get name => describeEnum(this);

  String display(final BuildContext context) {
    switch (this) {
      case MealType.APPETIZER:
        return AppLocalizations.of(context)!.meal_type_appetizer;
      case MealType.DESSERT:
        return AppLocalizations.of(context)!.meal_type_dessert;
      case MealType.DISH:
        return AppLocalizations.of(context)!.meal_type_dish;
      case MealType.DRINK:
        return AppLocalizations.of(context)!.meal_type_drink;
      case MealType.STARTER:
        return AppLocalizations.of(context)!.meal_type_starter;
      case MealType.OTHER:
        return AppLocalizations.of(context)!.meal_type_other;
      default:
        return 'Meal type is null';
    }
  }
}
