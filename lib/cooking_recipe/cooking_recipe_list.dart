import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/services/category_type.dart';
import 'package:my_fridge/services/cooking_recipe_service.dart';
import 'package:my_fridge/widget/category_list.dart';

import '../widget/dialog.dart';
import 'cooking_recipe_view.dart';

class CookingRecipeList extends StatefulWidget {
  const CookingRecipeList() : super();

  @override
  State<StatefulWidget> createState() => _CookingRecipeListState();
}

class _CookingRecipeListState extends State<CookingRecipeList> {
  @override
  Widget build(BuildContext context) {
    return CategoryList(CookingRecipeService.getByCategory,
        _buildCookingRecipeListItem, false, CategoryType.COOKING_RECIPE);
  }

  Widget _buildCookingRecipeListItem(
      BuildContext context, DocumentSnapshot document) {
    CookingRecipe cookingRecipe = CookingRecipe.fromDocument(document);
    return ListTile(
      title: Text(cookingRecipe.name),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogFullScreen(
              title: AppLocalizations.of(context)!.add_article_popup_title,
              child: CookingRecipeView(
                cookingRecipe: cookingRecipe,
                insertMode: false,
              ),
            );
          },
        );
      },
    );
  }
}
