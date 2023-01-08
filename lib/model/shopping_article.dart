import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/article.dart';
import 'package:my_fridge/model/packing_type.dart';

class ShoppingArticle {
  ShoppingArticle(
      {this.id,
      required this.name,
      required this.unit,
      required this.quantity,
      required this.perishable,
      this.checked: false,
      this.expiryDate,
      required this.category});

  String? id;

  String name;

  int unit;

  int quantity;

  bool perishable;

  bool checked;

  String category;

  DateTime? expiryDate;

  PackingType get packingType => PackingType.values[unit];

  bool isEditable = false;

  static ShoppingArticle fromArticle(Article article, int quantity) {
    return ShoppingArticle(
        name: article.name, unit: article.unit, quantity: quantity, perishable: article.perishable, category: article.category);
  }

  static ShoppingArticle fromMap(Map<String, dynamic> map) {
    return ShoppingArticle(
        name: map['name'],
        unit: map['unit'],
        quantity: map['quantity'],
        perishable: map['perishable'],
        category: map['category'],
        expiryDate: map['expiry_date']);
  }

  static ShoppingArticle fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    DateTime? expiryDate;
    if (data['expiry_date'] != null) {
      expiryDate = DateTime.fromMicrosecondsSinceEpoch((data['expiry_date'] as Timestamp).microsecondsSinceEpoch);
    }

    return ShoppingArticle(
        id: document.id,
        name: data['name'],
        unit: data['unit'],
        quantity: data['quantity'],
        perishable: data["perishable"],
        checked: data['checked'],
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
      "expiry_date": this.expiryDate
    };
  }
}
