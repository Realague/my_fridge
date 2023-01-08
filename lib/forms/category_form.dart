import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/services/article_category_service.dart';
import 'package:my_fridge/utils/validators.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({this.category}) : super();

  final Category? category;

  @override
  State<StatefulWidget> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.category?.category ?? "";
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
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Category category = Category(category: _nameController.text);
                if (widget.category != null) {
                  CategoryService.update(category);
                } else {
                  CategoryService.create(category);
                }

                Navigator.pop(context);
              }
            },
            label: Text(AppLocalizations.of(context)!.button_add_category),
          ),
        ],
      ),
    );
  }
}
