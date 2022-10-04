import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/article.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/article_service.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/utils/validators.dart';

class FormShoppingListFromExistingArticle extends StatefulWidget {
  const FormShoppingListFromExistingArticle({this.article}) : super();

  final ShoppingArticle? article;

  @override
  State<StatefulWidget> createState() =>
      _FormShoppingListFromExistingArticleState();
}

class _FormShoppingListFromExistingArticleState
    extends State<FormShoppingListFromExistingArticle> {
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Article? _selectedArticle;

  @override
  void initState() {
    if (widget.article != null) {
      _selectedArticle = Article(
          name: widget.article!.name,
          unit: widget.article!.unit,
          perishable: widget.article!.perishable,
          category: widget.article!.category);
    }
    _quantityController.text = widget.article?.quantity.toString() ?? "";
    super.initState();
  }

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
                  padding: EdgeInsets.all(8.0),
                  child: DropdownSearch<Article>(
                    asyncItems: (String filter) => ArticleService.get(filter),
                    popupProps: PopupProps.menu(showSearchBox: true),
                    itemAsString: (Article? article) =>
                        article!.name +
                        ", " +
                        article.quantityUnit.displayForDropDown(context),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.form_article_label,
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    onChanged: (Article? article) => _selectedArticle = article,
                    selectedItem: _selectedArticle,
                    validator: (article) =>
                        Validators.notNull(context, article),
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
                      labelText:
                          AppLocalizations.of(context)!.form_quantity_label,
                    ),
                    validator: (value) => Validators.number(context, value!),
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
                ShoppingArticle shoppingArticle = ShoppingArticle(
                    id: widget.article?.id ?? null,
                    name: _selectedArticle!.name,
                    unit: _selectedArticle!.unit,
                    category: _selectedArticle!.category,
                    quantity: int.tryParse(_quantityController.text)!,
                    perishable: _selectedArticle!.perishable);
                if (shoppingArticle.id != null) {
                  ShoppingListService.update(shoppingArticle, context);
                } else {
                  ShoppingListService.create(shoppingArticle, context);
                }
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
