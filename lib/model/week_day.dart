import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum WeekDay { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

extension WeekDayExtension on WeekDay {

  String display(final BuildContext context) {
    switch (this) {
      case WeekDay.MONDAY:
        return AppLocalizations.of(context)!.monday;
      case WeekDay.TUESDAY:
        return AppLocalizations.of(context)!.tuesday;
      case WeekDay.WEDNESDAY:
        return AppLocalizations.of(context)!.wednesday;
      case WeekDay.THURSDAY:
        return AppLocalizations.of(context)!.thursday;
      case WeekDay.FRIDAY:
        return AppLocalizations.of(context)!.friday;
      case WeekDay.SATURDAY:
        return AppLocalizations.of(context)!.saturday;
      case WeekDay.SUNDAY:
        return AppLocalizations.of(context)!.sunday;
      default:
        return AppLocalizations.of(context)!.monday;
    }
  }
}
