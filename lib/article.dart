import 'package:my_fridge/quantity_unit.dart';

class Article {
  Article(this._name, this._unit);

  String _name;

  int _unit;

  String get name => _name;

  int get unit => _unit;

  QuantityUnit get quantityUnit => QuantityUnit.values[_unit];
}