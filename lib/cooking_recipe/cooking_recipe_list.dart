import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/cooking_recipe/cooking_recipe_view.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/widget/dialog.dart';

class CookingRecipeList extends StatefulWidget {
  const CookingRecipeList() : super();

  @override
  State<StatefulWidget> createState() => _CookingRecipeListState();
}

class _CookingRecipeListState extends State<CookingRecipeList> {
  @override
  Widget build(final BuildContext context) {
    return Text("");
    //return CategoryList(CookingRecipeService.getByCategory,
    //  _buildCookingRecipeListItem, false);
  }

  Widget _buildCookingRecipeListItem(final BuildContext context, final DocumentSnapshot document) {
    CookingRecipe cookingRecipe = CookingRecipe.fromDocument(document);
    return ListTile(
      title: Text(cookingRecipe.name),
      onTap: () {
        showDialog(
          context: context,
          builder: (final BuildContext context) {
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
