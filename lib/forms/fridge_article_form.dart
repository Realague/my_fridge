import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:my_fridge/model/article.dart';
import 'package:my_fridge/model/fridge_article.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/services/article_service.dart';
import 'package:my_fridge/services/fridge_service.dart';
import 'package:my_fridge/utils/validators.dart';

class FormFridgeArticleArticle extends StatefulWidget {
  const FormFridgeArticleArticle({this.article, this.id}) : super();

  final FridgeArticle? article;
  final String? id;

  @override
  State<StatefulWidget> createState() => _FormFridgeArticleArticleState(article, id);
}

class _FormFridgeArticleArticleState extends State<FormFridgeArticleArticle> {
  _FormFridgeArticleArticleState(FridgeArticle? article, this.id) {
    if (article != null) {
      _selectedArticle = Article(name: article.name, unit: article.unit, perishable: article.perishable, category: article.category);
      _quantityController.text = article.quantity.toString();
    }
  }

  Article? _selectedArticle;
  final _quantityController = TextEditingController();
  final String? id;
  int _selectedDate = 0;
  TextEditingController _dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? pickedDate = (await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2015), lastDate: DateTime(2050)));
    if (pickedDate != null /*&& pickedDate.microsecond != _selectedDate*/) {
      setState(() {
        _selectedDate = pickedDate.microsecond;
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        pickedDate.toString();
      });
    }
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
                    mode: Mode.MENU,
                    showSearchBox: true,
                    onFind: (filter) async {
                      return await ArticleService.get(filter);
                    },
                    itemAsString: (Article? article) => article!.name + ", " + article.quantityUnit.displayForDropDown(context),
                    label: AppLocalizations.of(context)!.form_article_label,
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (Article? article) => _selectedArticle = article,
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
            ],
          ),
          Expanded(
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
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                FridgeArticle fridgeArticle = FridgeArticle(
                    name: _selectedArticle!.name,
                    unit: _selectedArticle!.unit,
                    category: _selectedArticle!.category,
                    quantity: int.tryParse(_quantityController.text)!,
                    perishable: _selectedArticle!.perishable,
                    expiryDate: _selectedDate);
                if (id != null) {
                  FridgeService.update(id!, fridgeArticle, context);
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
