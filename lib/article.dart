import 'package:my_fridge/quantity_unit.dart';

class Article {
  Article(this._name, this._unit, this._perishable);

  String _name;

  int _unit;

  bool _perishable;

  String get name => _name;

  int get unit => _unit;

  bool get perishable => _perishable;

  QuantityUnit get quantityUnit => QuantityUnit.values[_unit];
}
