import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/packing_type.dart';

class ShoppingItem {
  ShoppingItem(
      {this.id,
      required this.name,
      required this.unit,
      required this.quantity,
      required this.perishable,
      required this.createdAt,
      required this.createdBy,
      required this.category,
      this.note = "",
      this.checked: false,
      this.expiryDate});

  String? id;

  String name;

  int unit;

  int quantity;

  bool perishable;

  bool checked;

  String category;

  DateTime? expiryDate;

  String note;

  DateTime createdAt;

  String createdBy;

  PackingType get packingType => PackingType.values[unit];

  bool isEditable = false;

  static ShoppingItem fromItem(Item item, int quantity) {
    return ShoppingItem(
        name: item.name, unit: item.unit, quantity: quantity, perishable: item.perishable, category: item.category, createdAt: null);
  }

  static ShoppingItem fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
        name: map['name'],
        unit: map['unit'],
        quantity: map['quantity'],
        perishable: map['perishable'],
        category: map['category'],
        note: map['note'],
        expiryDate: map['expiry_date']);
  }

  static ShoppingItem fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    DateTime? expiryDate;
    if (data['expiry_date'] != null) {
      expiryDate = DateTime.fromMicrosecondsSinceEpoch((data['expiry_date'] as Timestamp).microsecondsSinceEpoch);
    }

    return ShoppingItem(
        id: document.id,
        name: data['name'],
        unit: data['unit'],
        quantity: data['quantity'],
        perishable: data["perishable"],
        checked: data['checked'],
        note: data['note'],
        category: data['category'],
        expiryDate: expiryDate);
  }

  Map<String, Object?> get asMap {
    return {
      "name": this.name,
      "unit": this.unit,
      "quantity": this.quantity,
      "perishable": this.perishable,
      "checked": this.checked,
      "category": this.category,
      "note": this.note,
      "expiry_date": this.expiryDate
    };
  }
}
