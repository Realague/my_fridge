import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/article.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/article_category_service.dart';
import 'package:my_fridge/services/article_service.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/utils/validators.dart';
import 'package:my_fridge/widget/loader.dart';

class FormShoppingList extends StatefulWidget {
  const FormShoppingList() : super();

  @override
  State<StatefulWidget> createState() => _FormShoppingListState();
}

class _FormShoppingListState extends State<FormShoppingList> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _nameController = TextEditingController();
  QuantityUnit? _quantityUnit;
  bool _perishable = false;
  Category? _category;

  @override
  void dispose() {
    _quantityController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
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
                labelText:
                    AppLocalizations.of(context)!.form_article_name_label,
              ),
              validator: (final name) => Validators.notEmpty(context, name),
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
                      labelText:
                          AppLocalizations.of(context)!.form_quantity_label,
                    ),
                    validator: (final quantity) =>
                        Validators.number(context, quantity),
                    controller: _quantityController,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DropdownSearch<QuantityUnit>(
                    items: QuantityUnit.values,
                    itemAsString: (final QuantityUnit? quantityUnit) =>
                        quantityUnit!.displayForDropDown(context),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!
                            .form_quantity_unit_label,
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    selectedItem: _quantityUnit,
                    validator: (final quantityUnit) =>
                        Validators.notNull(context, quantityUnit),
                    onChanged: (final QuantityUnit? quantityUnit) =>
                        _quantityUnit = quantityUnit,
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: CategoryService.get(),
            builder: (final context, final snapshot) {
              if (!snapshot.hasData) {
                return Loader();
              }
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownSearch<Category>(
                  items: snapshot.data as List<Category>,
                  itemAsString: (final Category? category) {
                    if (category != null && category.category == " ") {
                      return AppLocalizations.of(context)!.category_other;
                    }
                    return category!.category;
                  },
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.category_label,
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  selectedItem: _category,
                  validator: (final category) =>
                      Validators.notNull(context, category),
                  onChanged: (final Category? category) => _category = category,
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.perishable_label),
            value: _perishable,
            subtitle:
                Text(AppLocalizations.of(context)!.perishable_description),
            onChanged: (final bool value) {
              setState(() {
                _perishable = value;
              });
            },
            secondary: const Icon(Icons.fastfood_outlined),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Article article = Article(
                    name: _nameController.text,
                    unit: _quantityUnit!.index,
                    perishable: _perishable,
                    category: _category!.category);
                ArticleService.create(article);
                ShoppingArticle shoppingArticle = ShoppingArticle(
                    name: _nameController.text,
                    unit: _quantityUnit!.index,
                    quantity: int.parse(_quantityController.text),
                    perishable: _perishable,
                    category: _category!.category);
                ShoppingListService.create(shoppingArticle, context);
                Navigator.pop(context);
              }
            },
            label: Text(AppLocalizations.of(context)!
                .button_add_article_to_shopping_list),
          ),
        ],
      ),
    );
  }
}
