import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Storage { FRIDGE, FREEZER, CELLAR, NONE }

extension StorageExtension on Storage {
  String get name => describeEnum(this);

  String displayTitle(final BuildContext context) {
    switch (this) {
      case Storage.FRIDGE:
        return AppLocalizations.of(context)!.storage_type_fridge;
      case Storage.FREEZER:
        return AppLocalizations.of(context)!.storage_type_freezer;
      case Storage.CELLAR:
        return AppLocalizations.of(context)!.storage_type_cellar;
      default:
        return AppLocalizations.of(context)!.storage_type_none;
    }
  }
}
