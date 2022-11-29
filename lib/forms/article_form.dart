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

class FormArticle extends StatefulWidget {
  const FormArticle({this.article}) : super();

  final Article? article;

  @override
  State<StatefulWidget> createState() => _FormArticleState();
}

class _FormArticleState extends State<FormArticle> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  QuantityUnit? _quantityUnit;
  late bool _perishable;
  late Category _category;

  @override
  void initState() {
    _perishable = widget.article?.perishable ?? false;
    _nameController.text = widget.article?.name ?? "";
    _category = Category(category: widget.article?.category ?? " ");
    _quantityUnit = widget.article?.quantityUnit ?? null;
    super.initState();
  }

  @override
  void dispose() {
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
                    items: QuantityUnit.values,
                    itemAsString: (QuantityUnit? quantityUnit) =>
                        quantityUnit!.displayForDropDown(context),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!
                            .form_quantity_unit_label,
                      ),
                    ),
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
                  validator: (category) =>
                      Validators.notNull(context, category),
                  onChanged: (final Category? category) =>
                      _category = category!,
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
                    id: widget.article!.id,
                    name: _nameController.text,
                    unit: _quantityUnit!.index,
                    perishable: _perishable,
                    category: _category.category);
                if (widget.article != null) {
                  ArticleService.update(article);
                } else {
                  ArticleService.create(article);
                }
              }
              Navigator.pop(context);
            },
            label: Text(AppLocalizations.of(context)!.button_add_article),
          ),
        ],
      ),
    );
  }
}
