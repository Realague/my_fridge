import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Storage { FRIDGE, FREEZER, CELLAR, CUPBOARD, NONE }

extension StorageExtension on Storage {

  String displayTitle(BuildContext context) {
    switch (this) {
      case Storage.FRIDGE:
        return AppLocalizations.of(context)!.storage_type_fridge;
      case Storage.FREEZER:
        return AppLocalizations.of(context)!.storage_type_freezer;
      case Storage.CELLAR:
        return AppLocalizations.of(context)!.storage_type_cellar;
      case Storage.CUPBOARD:
        return AppLocalizations.of(context)!.storage_type_cupboard;
      default:
        return AppLocalizations.of(context)!.storage_type_none;
    }
  }
}

extension StorageListExtension on List<Storage> {
  List<int> get toIntList {
    List<int> list = <int>[];
    for (int i = 0; i != this.length; i++) {
      list.add(this[i].index);
    }
    return list;
  }

  List<Storage> get storageListWithoutNone {
    List<Storage> storages = Storage.values.toList();
    storages.remove(Storage.NONE);
    return storages;
  }
}

extension IntListExtension on List<int> {
  List<Storage> get toStorageList {
    List<Storage> list = <Storage>[];
    for (int i = 0; i != this.length; i++) {
      list.add(Storage.values[this[i]]);
    }
    return list;
  }
}
