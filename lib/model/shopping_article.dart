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
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return ShoppingArticle(
      id: document.id,
      name: data['name'],
      unit: data['unit'],
      quantity: data['quantity'],
      perishable: data["perishable"],
      checked: data['checked'],
      category: data['category'],
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
