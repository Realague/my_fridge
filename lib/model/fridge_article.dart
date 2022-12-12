import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_fridge/model/quantity_unit.dart';

class FridgeArticle {
  FridgeArticle(
      {this.id,
      required this.name,
      required this.unit,
      required this.quantity,
      required this.perishable,
      required this.category,
      this.expiryDate});

  String? id;

  String name;

  int unit;

  int quantity;

  bool perishable;

  String category;

  PackingType get packingType => PackingType.values[unit];

  DateTime? expiryDate;

  String get expiryDateDisplay => expiryDate == null ? "" : DateFormat('dd/MM/yyyy').format(expiryDate!);

  static FridgeArticle fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    DateTime? expiryDate;
    if (data['expiry_date'] != null) {
      expiryDate = DateTime.fromMicrosecondsSinceEpoch((data['expiry_date'] as Timestamp).microsecondsSinceEpoch);
    }

    return FridgeArticle(
        id: document.id,
        name: data['name'],
        unit: data['unit'],
        quantity: data['quantity'],
        perishable: data["perishable"],
        category: data['category'],
        expiryDate: expiryDate);
  }

  Map<String, Object?> get asMap {
    return {
      "name": this.name,
      "unit": this.unit,
      "quantity": this.quantity,
      "perishable": this.perishable,
      "category": this.category,
      "expiry_date": this.expiryDate
    };
  }
}
