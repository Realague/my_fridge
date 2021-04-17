import 'package:my_fridge/model/quantity_unit.dart';

class Article {
  Article({required this.name, required this.unit, required this.perishable, this.category: " "});

  String name;

  int unit;

  bool perishable;

  String category;

  QuantityUnit get quantityUnit => QuantityUnit.values[unit];
}
