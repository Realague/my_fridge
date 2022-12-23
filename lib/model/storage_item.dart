import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/utils.dart';

class StorageItem {
  StorageItem(
      {this.id,
      required this.name,
      required this.unit,
      this.quantity = 0,
      required this.perishable,
      required this.boughtAt,
      required this.boughtBy,
      required this.storage,
      this.note = "",
      this.expiryDate});

  String? id;

  String name;

  int unit;

  int quantity;

  int storage;

  bool perishable;

  PackingType get packingType => PackingType.values[unit];

  DateTime? expiryDate;

  String? note;

  DateTime boughtAt;

  String boughtBy;

  String get expiryDateDisplay => expiryDate == null ? "" : DateFormat('dd/MM/yyyy').format(expiryDate!);

  Storage get storagePlace => Storage.values[storage];

  int get daysSinceBought {
    return DateTime.now().difference(boughtAt).inDays;
  }

  String getBoughtAtDisplayForListTile(BuildContext context) {
    String dateDisplay = "";
    if (expiryDate != null) {
      dateDisplay = AppLocalizations.of(context)!.storage_item_perish_on + DateFormat('dd/MM/yyyy').format(expiryDate!);
    } else if (perishable) {
      dateDisplay = AppLocalizations.of(context)!.storage_item_missing_expiry_date
    }
    return dateDisplay;
  }

  static StorageItem fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return StorageItem(
        id: document.id,
        name: data['name'],
        unit: data['unit'],
        quantity: data['quantity'],
        perishable: data['perishable'],
        expiryDate: Utils.timestampToDateTime(data['expiry_date']),
        storage: data['storage'],
        note: data['note'],
        boughtBy: data['boughtBy'],
        boughtAt: Utils.timestampToDateTime(data['boughtAt'])!);
  }

  Map<String, Object?> get asMap {
    return {
      "name": this.name,
      "unit": this.unit,
      "quantity": this.quantity,
      "perishable": this.perishable,
      "expiry_date": this.expiryDate,
      "storage": this.storage,
      "note": this.note,
      "boughtBy": this.boughtAt,
      "boughtAt": this.boughtBy
    };
  }
}
