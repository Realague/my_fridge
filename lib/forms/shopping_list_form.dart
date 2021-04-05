import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/services/article_service.dart';
import 'package:my_fridge/services/shopping_list.dart';
import 'package:my_fridge/utils/validators.dart';

import '../article.dart';
import '../quantity_unit.dart';

class FormShoppingList extends StatefulWidget {
  const FormShoppingList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormShoppingListState();
}

class _FormShoppingListState extends State<FormShoppingList> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _nameController = TextEditingController();
  QuantityUnit? _quantityUnit;

  @override
  void dispose() {
    _quantityController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Name",
              ),
              validator: (name) => Validators.notNull(name!),
              controller: _nameController,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Quantity",
                    ),
                    validator: (quantity) => Validators.number(quantity!),
                    controller: _quantityController,
                  ),
                ),
              ),
              Expanded(
                child: DropdownSearch<QuantityUnit>(
                  mode: Mode.MENU,
                  items: QuantityUnit.values,
                  itemAsString: (quantityUnit) =>
                  quantityUnit.displayForDropDown,
                  label: "Quantity unit",
                  selectedItem: _quantityUnit,
                  validator: (quantityUnit) =>
                      Validators.notNull(quantityUnit),
                  onChanged: (quantityUnit) => _quantityUnit = quantityUnit,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Article article =
                Article(_nameController.text, _quantityUnit!.index);
                ArticleService.create(article);
                ShoppingListService.create(article,
                    int.tryParse(_quantityController.text)!, context);
                Navigator.pop(context);
              }
            },
            label: Text("Add to shopping list"),
          ),
        ],
      ),
    );
  }
}