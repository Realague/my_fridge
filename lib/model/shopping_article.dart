import 'package:cloud_firestore/cloud_firestore.dart';

import 'article.dart';
import 'quantity_unit.dart';

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

  QuantityUnit get quantityUnit => QuantityUnit.values[unit];

  bool isEditable = false;

  static ShoppingArticle fromArticle(Article article, int quantity) {
    return ShoppingArticle(
        name: article.name,
        unit: article.unit,
        quantity: quantity,
        perishable: article.perishable,
        category: article.category);
  }

  static ShoppingArticle fromMap(Map<String, dynamic> map) {
    return ShoppingArticle(
        name: map['name'],
        unit: map['unit'],
        quantity: map['quantity'],
        perishable: map['perishable'],
        category: map['category']);
  }

  static ShoppingArticle fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    DateTime expiryDate = DateTime(2050);
    if (data['expiry_date'] != null) {
      expiryDate = DateTime.fromMicrosecondsSinceEpoch(
          (data['expiry_date'] as Timestamp).microsecondsSinceEpoch);
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

  Map<String, Object> get asMap {
    var map = {
      "name": this.name,
      "unit": this.unit,
      "quantity": this.quantity,
      "perishable": this.perishable,
      "checked": this.checked,
      "category": this.category
    };

    if (this.expiryDate != null) {
      map['expiry_date'] = this.expiryDate!;
    }
    return map;
  }
}
