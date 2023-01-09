import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/services/article_category_service.dart';
import 'package:my_fridge/services/article_service.dart';
import 'package:my_fridge/utils/validators.dart';
import 'package:my_fridge/widget/loader.dart';

class FormArticle extends StatefulWidget {
  const FormArticle({this.article}) : super();

  final Item? article;

  @override
  State<StatefulWidget> createState() => _FormArticleState();
}

class _FormArticleState extends State<FormArticle> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  PackingType? _packingType;
  late bool _perishable;
  late Category _category;

  @override
  void initState() {
    _perishable = widget.article?.perishable ?? false;
    _nameController.text = widget.article?.name ?? "";
    _category = Category(category: widget.article?.category ?? " ");
    _packingType = widget.article?.packingType ?? null;
    super.initState();
  }

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
                  child: DropdownSearch<PackingType>(
                    items: PackingType.values,
                    itemAsString: (PackingType? packingType) => packingType!.displayText(context),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.form_packing_type_label,
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
                  onChanged: (Category? category) => _category = category!,
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
                Item article = Item(
                    id: widget.article!.id,
                    name: _nameController.text,
                    unit: _packingType!.index,
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
