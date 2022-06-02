import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/article.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/services/article_category_service.dart';
import 'package:my_fridge/services/article_service.dart';
import 'package:my_fridge/utils/validators.dart';
import 'package:my_fridge/widget/loader.dart';

class FormAddArticle extends StatefulWidget {
  const FormAddArticle() : super();

  @override
  State<StatefulWidget> createState() => _FormAddArticleState();
}

class _FormAddArticleState extends State<FormAddArticle> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  QuantityUnit? _quantityUnit;
  bool _perishable = false;
  Category? _category;

  @override
  void dispose() {
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
                labelText:
                    AppLocalizations.of(context)!.form_article_name_label,
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
                  child: DropdownSearch<QuantityUnit>(
                    mode: Mode.MENU,
                    items: QuantityUnit.values,
                    itemAsString: (QuantityUnit? quantityUnit) =>
                        quantityUnit!.displayForDropDown(context),
                    label:
                        AppLocalizations.of(context)!.form_quantity_unit_label,
                    selectedItem: _quantityUnit,
                    validator: (quantityUnit) =>
                        Validators.notNull(context, quantityUnit),
                    onChanged: (QuantityUnit? quantityUnit) =>
                        _quantityUnit = quantityUnit,
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
                  mode: Mode.MENU,
                  items: snapshot.data as List<Category>,
                  itemAsString: (Category? category) {
                    if (category != null && category.category == " ") {
                      return AppLocalizations.of(context)!.category_other;
                    }
                    return category!.category;
                  },
                  label: AppLocalizations.of(context)!.category_label,
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                    border: const OutlineInputBorder(),
                  ),
                  selectedItem: _category,
                  validator: (category) =>
                      Validators.notNull(context, category),
                  onChanged: (Category? category) => _category = category,
                ),
              );
            },
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.perishable_label),
            value: _perishable,
            subtitle:
                Text(AppLocalizations.of(context)!.perishable_description),
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
                Article article = Article(
                    name: _nameController.text,
                    unit: _quantityUnit!.index,
                    perishable: _perishable,
                    category: _category!.category);
                ArticleService.create(article);
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
