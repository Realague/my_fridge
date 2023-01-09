import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/packing_type.dart';
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
  PackingType? _packingType;
  bool _perishable = false;
  Category? _category;

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
                labelText: AppLocalizations.of(context)!.form_article_name_label,
              ),
              validator: (name) => Validators.notEmpty(context, name),
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
                      labelText: AppLocalizations.of(context)!.form_quantity_label,
                    ),
                    validator: (quantity) => Validators.number(context, quantity),
                    controller: _quantityController,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DropdownSearch<PackingType>(
                    items: PackingType.values,
                    itemAsString: (PackingType? packingType) => packingType!.displayText(context),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.form_packing_type_label,
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    selectedItem: _packingType,
                    validator: (packingType) => Validators.notNull(context, packingType),
                    onChanged: (PackingType? packingType) => _packingType = packingType,
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder(
            future: CategoryService.get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loader();
              }
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: DropdownSearch<Category>(
                  items: snapshot.data as List<Category>,
                  itemAsString: (Category? category) {
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
                  validator: (category) => Validators.notNull(context, category),
                  onChanged: (Category? category) => _category = category,
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.perishable_label),
            value: _perishable,
            subtitle: Text(AppLocalizations.of(context)!.perishable_description),
            onChanged: (bool value) {
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
                Item article =
                    Item(name: _nameController.text, unit: _packingType!.index, perishable: _perishable, category: _category!.category);
                ArticleService.create(article);
                ShoppingItem shoppingArticle = ShoppingItem(
                    name: _nameController.text,
                    unit: _packingType!.index,
                    quantity: int.parse(_quantityController.text),
                    perishable: _perishable,
                    category: _category!.category);
                ShoppingListService.create(shoppingArticle, context);
                Navigator.pop(context);
              }
            },
            label: Text(AppLocalizations.of(context)!.button_add_article_to_shopping_list),
          ),
        ],
      ),
    );
  }
}
