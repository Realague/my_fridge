import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/quantity_unit.dart';

class Article {
  Article({this.id, required this.name, required this.unit, required this.perishable, this.category: " "});

  String? id;

  String name;

  int unit;

  bool perishable;

  String category;

  QuantityUnit get quantityUnit => QuantityUnit.values[unit];

  static Article fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Article(
        id: document.id,
        name: data['name'],
        unit: data['unit'],
        perishable: data['perishable'],
        category: data['category']);
  }

  Map<String, Object> get asMap {
    return {'name': this.name, 'unit': this.unit, 'perishable': this.perishable, 'category': this.category};
  }
}
