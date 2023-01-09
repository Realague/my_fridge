import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/cooking_recipe/article_form_cooking_recipe.dart';
import 'package:my_fridge/forms/select_article_form.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/cooking_recipe_service.dart';
import 'package:my_fridge/utils/validators.dart';

class CookingRecipeView extends StatefulWidget {
  const CookingRecipeView({this.cookingRecipe, required this.insertMode}) : super();

  final CookingRecipe? cookingRecipe;
  final bool insertMode;

  @override
  State<StatefulWidget> createState() => _CookingRecipeState();
}

class _CookingRecipeState extends State<CookingRecipeView> {
  final _quantityController = TextEditingController();
  final _nameController = TextEditingController();
  final _stepsController = TextEditingController();
  CookingRecipe? _cookingRecipe;
  bool _editMode = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _editMode = widget.insertMode;
    _cookingRecipe = widget.cookingRecipe;
    if (_cookingRecipe == null) {
      _cookingRecipe = new CookingRecipe(name: "", steps: "", category: "", ingredients: []);
    }
    _nameController.text = _cookingRecipe!.name;
    _stepsController.text = _cookingRecipe!.steps;
    super.initState();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _stepsController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget editMode() {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.form_article_name_label,
                    ),
                    validator: (value) => Validators.notEmpty(context, value!),
                    controller: _nameController,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _editMode = false;
                        //TODO reset cooking_recipe _cookingRecipe = CookingRecipeService.
                      });
                    },
                    child: const Icon(Icons.cancel)),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(AppLocalizations.of(context)!.cooking_recipe_ingredients),
        ),
        SelectArticleForm(confirmCallback: (article, quantity) {
          setState(() {
            _cookingRecipe!.ingredients.add(ShoppingItem.fromItem(article, quantity));
          });
        }),
        ListView.builder(
          itemBuilder: (_, index) => IngredientForm(
              isEditMode: _editMode,
              shoppingArticle: _cookingRecipe!.ingredients[index],
              onEditIngredient: (final ShoppingItem shoppingArticle) {
                setState(() {
                  _cookingRecipe!.ingredients[index] = shoppingArticle;
                });
              },
              onRemoveIngredient: () {
                setState(() {
                  _cookingRecipe!.ingredients.removeAt(index);
                });
              },
              id: ""),
          itemCount: _cookingRecipe!.ingredients.length,
          itemExtent: 50,
          shrinkWrap: true,
        ),
        Text(AppLocalizations.of(context)!.cooking_recipe_steps),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            // expands: true,
            // minLines: null,
            maxLines: null,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.form_article_name_steps,
            ),
            validator: (value) => Validators.notEmpty(context, value!),
            controller: _stepsController,
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _cookingRecipe!.name = _nameController.text;
              _cookingRecipe!.steps = _stepsController.text;
              if (_cookingRecipe!.id != null) {
                CookingRecipeService.update(_cookingRecipe!, context);
              } else {
                CookingRecipeService.create(_cookingRecipe!, context);
              }
              setState(() {
                _editMode = false;
              });
            }
          },
          label: Text(AppLocalizations.of(context)!.button_save_cooking_recipe),
        ),
      ],
    );
  }

  Widget readOnly() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 12,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context)!.form_article_name_label + _cookingRecipe!.name),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _editMode = true;
                      });
                    },
                    child: const Icon(Icons.edit)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _editMode = false;
                      });
                    },
                    child: const Icon(Icons.delete)),
              ),
            ),
          ],
        ),
        Text(AppLocalizations.of(context)!.cooking_recipe_ingredients),
        ListView.builder(
          itemBuilder: (_, index) => IngredientForm(isEditMode: _editMode, shoppingArticle: _cookingRecipe!.ingredients[index], id: ""),
          itemCount: _cookingRecipe!.ingredients.length,
          itemExtent: 50,
          shrinkWrap: true,
        ),
        SizedBox(height: 20),
        Text(AppLocalizations.of(context)!.cooking_recipe_steps),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(_cookingRecipe!.steps),
          ),
        )
      ],
    );
  }

  @override
  Widget build(final BuildContext context) {
    return _editMode ? editMode() : readOnly();
  }
}
