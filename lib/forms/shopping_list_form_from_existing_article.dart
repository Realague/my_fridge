import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/quantity_unit.dart';
import 'package:my_fridge/services/article_service.dart';
import 'package:my_fridge/services/shopping_list.dart';
import 'package:my_fridge/utils/validators.dart';

import '../article.dart';

class FormShoppingListFromExistingArticle extends StatefulWidget {
  const FormShoppingListFromExistingArticle({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _FormShoppingListFromExistingArticleState();
}

class _FormShoppingListFromExistingArticleState
    extends State<FormShoppingListFromExistingArticle> {
  Article? _selectedArticle;
  final _quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: DropdownSearch<Article>(
                    mode: Mode.MENU,
                    showSearchBox: true,
                    onFind: (filter) async {
                      return await ArticleService.get(filter);
                    },
                    itemAsString: (article) =>
                        article.name +
                        ", " +
                        article.quantityUnit.displayForDropDown,
                    label: "Article",
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (article) => _selectedArticle = article,
                    selectedItem: _selectedArticle,
                    validator: (article) => Validators.notNull(article),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Quantity",
                    ),
                    validator: (value) => Validators.number(value!),
                    controller: _quantityController,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ShoppingListService.create(_selectedArticle!,
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
