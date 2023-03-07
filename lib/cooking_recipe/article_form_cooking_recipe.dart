import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/services/item_service.dart';
import 'package:my_fridge/utils/validators.dart';

typedef void RemoveIngredientCallback();
typedef void EditIngredientCallback(ShoppingItem shoppingArticle);

class IngredientForm extends StatefulWidget {
  const IngredientForm({
    this.shoppingArticle,
    this.id,
    this.onRemoveIngredient,
    this.onEditIngredient,
    required this.isEditMode,
  }) : super();

  final bool isEditMode;
  final ShoppingItem? shoppingArticle;
  final String? id;

  final RemoveIngredientCallback? onRemoveIngredient;
  final EditIngredientCallback? onEditIngredient;

  @override
  State<StatefulWidget> createState() => _IngredientFormState();
}

class _IngredientFormState extends State<IngredientForm> {
  final _quantityController = TextEditingController();
  ShoppingItem? _article;
  Item? _selectedArticle;
  bool _isEditMode = false;

  //final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _isEditMode = widget.isEditMode;
    _article = widget.shoppingArticle;
    _selectedArticle = Item.fromShoppingItem(_article!, context);
    _quantityController.text = _article!.quantity.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Widget editMode() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: DropdownSearch<Item>(
              asyncItems: (String filter) => ItemService.get(filter),
              popupProps: PopupProps.menu(showSearchBox: true),
              itemAsString: (Item? article) => article!.name + ", " + article.packingType.displayText(context),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.form_article_label,
                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                  border: const OutlineInputBorder(),
                ),
              ),
              onChanged: (final Item? article) {
                setState(() {
                  _selectedArticle = article;
                });
              },
              selectedItem: _selectedArticle,
              validator: (article) => Validators.notNull(context, article),
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
                labelText: AppLocalizations.of(context)!.form_quantity_label,
              ),
              validator: (value) => Validators.number(context, value!),
              controller: _quantityController,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _article!.isEditable = false;
                  //widget.onEditIngredient!(ShoppingItem.fromItem(_selectedArticle!, int.tryParse(_quantityController.text)!));
                });
              },
              child: const Icon(Icons.check)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _article!.isEditable = false;
                });
              },
              child: const Icon(Icons.cancel)),
        ),
      ],
    );
  }

  Widget fullReadonlyMode() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(_article!.name + ", " + _article!.packingType.displayText(context) + " " + _article!.quantity.toString()),
    );
  }

  Widget readonlyMode() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(_article!.name + ", " + _article!.packingType.displayText(context) + " " + _article!.quantity.toString()),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _article!.isEditable = true;
                });
              },
              child: const Icon(Icons.edit)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _article!.isEditable = false;
                  widget.onRemoveIngredient!();
                });
              },
              child: const Icon(Icons.delete)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _article!.isEditable && _isEditMode
        ? editMode()
        : _isEditMode
            ? readonlyMode()
            : fullReadonlyMode();
  }
}
