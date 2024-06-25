import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/forms/add_article_form.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/services/item_service.dart';
import 'package:my_fridge/utils/validators.dart';
import 'package:my_fridge/widget/dialog.dart';

typedef void ConfirmCallback(Item article, int quantity);

class SelectArticleForm extends StatefulWidget {
  const SelectArticleForm({required this.confirmCallback, this.article}) : super();

  final ShoppingItem? article;
  final ConfirmCallback confirmCallback;

  @override
  State<StatefulWidget> createState() => _SelectArticleFormState();
}

class _SelectArticleFormState extends State<SelectArticleForm> {
  Item? _selectedArticle;
  final _quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.article != null) {
      _selectedArticle = Item(
          name: widget.article!.name,
          unit: widget.article!.unit,
          perishable: widget.article!.perishable,
          category: widget.article!.category,
          storage: widget.article!.storage);
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
                  child: DropdownSearch<Item>(
                    asyncItems: (String filter) => ItemService.get(filter),
                    popupProps: PopupProps.menu(showSearchBox: true),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.form_article_label,
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    itemAsString: (Item? article) => article!.name + ", " + article.packingType.displayText(context),
                    onChanged: (Item? article) {
                      setState(() {
                        _selectedArticle = article;
                      });
                    },
                    selectedItem: _selectedArticle,
                    validator: (article) => Validators.notNull(context, article),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogFullScreen(
                            title: AppLocalizations.of(context)!.shopping_list_popup_title,
                            child: FormAddArticle(),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.add)),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.form_quantity_label,
                    ),
                    validator: (value) => Validators.number(context, value!),
                    controller: _quantityController,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: FilledButton(
                onPressed: () {
                  widget.confirmCallback(_selectedArticle!, int.parse(_quantityController.text));
                },
                child: const Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}
