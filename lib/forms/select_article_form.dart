import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/quantity_unit.dart';

import '../model/article.dart';
import '../model/shopping_article.dart';
import '../services/article_service.dart';
import '../utils/validators.dart';
import '../widget/dialog.dart';
import 'add_article_form.dart';

typedef void ConfirmCallback(final Article article, final int quantity);

class SelectArticleForm extends StatefulWidget {
  const SelectArticleForm({required this.confirmCallback, this.article})
      : super();

  final ShoppingArticle? article;
  final ConfirmCallback confirmCallback;

  @override
  State<StatefulWidget> createState() => _SelectArticleFormState();
}

class _SelectArticleFormState extends State<SelectArticleForm> {
  Article? _selectedArticle;
  final _quantityController = TextEditingController();

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
                    itemAsString: (final Article? article) =>
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (final BuildContext context) {
                          return DialogFullScreen(
                            title: AppLocalizations.of(context)!
                                .shopping_list_popup_title,
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
                      labelText:
                          AppLocalizations.of(context)!.form_quantity_label,
                    ),
                    validator: (final value) =>
                        Validators.number(context, value!),
                    controller: _quantityController,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  widget.confirmCallback(
                      _selectedArticle!, int.parse(_quantityController.text));
                },
                child: const Icon(Icons.add)),
          ),
        ],
      ),
    );
  }
}
