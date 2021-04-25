import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_fridge/model/quantity_unit.dart';

class FridgeArticle {
  FridgeArticle({this.id, required this.name, required this.unit, required this.quantity, required this.perishable, required this.category, this.expiryDate});

  String? id;

  String name;

  int unit;

  int quantity;

  bool perishable;

  String category;

  QuantityUnit get quantityUnit => QuantityUnit.values[unit];

  DateTime? expiryDate;

  String get expiryDateDisplay => expiryDate == null ? "" : DateFormat('dd/MM/yyyy').format(expiryDate!);

  static FridgeArticle fromDocument(DocumentSnapshot document) {
    Timestamp.now();
    return FridgeArticle(
        id: document.id,
        name: document.data()!['name'],
        unit: document.data()!['unit'],
        quantity: document.data()!['quantity'],
        perishable: document.data()!["perishable"],
        category: document.data()!['category'],
        expiryDate: DateTime.fromMicrosecondsSinceEpoch((document.data()!['expiry_date'] as Timestamp).microsecondsSinceEpoch));
  }
}
