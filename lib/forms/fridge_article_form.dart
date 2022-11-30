import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:my_fridge/model/article.dart';
import 'package:my_fridge/model/fridge_article.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/services/fridge_service.dart';
import 'package:my_fridge/utils/validators.dart';

import '../services/article_service.dart';

class FormFridgeArticle extends StatefulWidget {
  const FormFridgeArticle({this.article, this.id}) : super();

  final FridgeArticle? article;
  final String? id;

  @override
  State<StatefulWidget> createState() => _FormFridgeArticleArticleState();
}

class _FormFridgeArticleArticleState extends State<FormFridgeArticle> {
  final _quantityController = TextEditingController();
  Article? _selectedArticle;
  DateTime? _selectedDate;
  TextEditingController _dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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

  Future _selectDate(final BuildContext context) async {
    final DateTime? pickedDate = (await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2050)));
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Widget _dateSelection() {
    if (_selectedArticle != null && _selectedArticle!.perishable) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.form_quantity_label,
            ),
            controller: _dateController,
            onTap: () {
              _selectDate(context);
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            readOnly: true,
          ),
        ),
      );
    }
    return SizedBox();
  }

  @override
  Widget build(final BuildContext context) {
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
                    asyncItems: (final String filter) =>
                        ArticleService.get(filter),
                    popupProps: PopupProps.menu(showSearchBox: true),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.form_article_label,
                        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    itemAsString: (Article? article) =>
                        article!.name +
                        ", " +
                        article.quantityUnit.displayForDropDown(context),
                    onChanged: (final Article? article) {
                      setState(() {
                        _selectedArticle = article;
                      });
                    },
                    selectedItem: _selectedArticle,
                    validator: (final article) =>
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
                    validator: (final value) =>
                        Validators.number(context, value!),
                    controller: _quantityController,
                  ),
                ),
              ),
              _dateSelection(),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FridgeArticle fridgeArticle = FridgeArticle(
                    id: widget.article?.id ?? null,
                    name: _selectedArticle!.name,
                    unit: _selectedArticle!.unit,
                    category: _selectedArticle!.category,
                    quantity: int.tryParse(_quantityController.text)!,
                    perishable: _selectedArticle!.perishable,
                    expiryDate: _selectedDate);
                if (fridgeArticle.id != null) {
                  FridgeService.update(fridgeArticle, context);
                } else {
                  FridgeService.create(fridgeArticle, context);
                }
                Navigator.pop(context);
              }
            },
            label: Text(AppLocalizations.of(context)!.button_add_to_fridge),
          ),
        ],
      ),
    );
  }
}
