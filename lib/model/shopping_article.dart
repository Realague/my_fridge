import 'package:cloud_firestore/cloud_firestore.dart';

import 'quantity_unit.dart';

class ShoppingArticle {
  ShoppingArticle(
      {this.id,
      required this.name,
      required this.unit,
      required this.quantity,
      required this.perishable,
      this.checked: false,
      required this.category});

  String? id;

  String name;

  int unit;

  int quantity;

  bool perishable;

  bool checked;

  String category;

  QuantityUnit get quantityUnit => QuantityUnit.values[unit];

  static ShoppingArticle fromDocument(DocumentSnapshot document) {
    return ShoppingArticle(
      id: document.id,
      name: document.data()!['name'],
      unit: document.data()!['unit'],
      quantity: document.data()!['quantity'],
      perishable: document.data()!["perishable"],
      checked: document.data()!['checked'],
      category: document.data()!['category'],
    );
  }

  Map<String, Object> get asMap {
    return {
      "name": this.name,
      "unit": this.unit,
      "quantity": this.quantity,
      "perishable": this.perishable,
      "checked": this.checked,
      "category": this.category
    };
  }
}
