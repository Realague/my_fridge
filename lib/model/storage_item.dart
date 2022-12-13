import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/model/storage.dart';

class StorageItem {
  StorageItem(
      {this.id,
      required this.name,
      required this.unit,
      required this.quantity,
      required this.perishable,
      required this.category,
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

  String category;

  PackingType get packingType => PackingType.values[unit];

  DateTime? expiryDate;

  String note;

  DateTime boughtAt;

  String boughtBy;

  String get expiryDateDisplay => expiryDate == null ? "" : DateFormat('dd/MM/yyyy').format(expiryDate!);

  Storage get storagePlace => Storage.values[storage];

  static StorageItem fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    DateTime? expiryDate;
    if (data['expiry_date']) {
      expiryDate = DateTime.fromMicrosecondsSinceEpoch((data['expiry_date'] as Timestamp).microsecondsSinceEpoch);
    }

    return StorageItem(
        id: document.id,
        name: data['name'],
        unit: data['unit'],
        quantity: data['quantity'],
        perishable: data["perishable"],
        category: data['category'],
        expiryDate: expiryDate,
        storage: data['storage'],
        note: data['note'],
        boughtBy: data['boughBy'],
        boughtAt: data['boughtAt']);
  }

  Map<String, Object?> get asMap {
    return {
      "name": this.name,
      "unit": this.unit,
      "quantity": this.quantity,
      "perishable": this.perishable,
      "category": this.category,
      "expiry_date": this.expiryDate,
      "storage": this.storage,
      "note": this.note,
      "boughtBy": this.boughtAt,
      "boughtAt": this.boughtBy
    };
  }
}
