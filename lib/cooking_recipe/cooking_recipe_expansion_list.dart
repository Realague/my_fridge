import 'package:flutter/material.dart';
import 'package:my_fridge/cooking_recipe/cooking_recipe_list_tile.dart';
import 'package:my_fridge/model/cooking_recipe.dart';

class CookingRecipeExpansionList extends StatefulWidget {
  const CookingRecipeExpansionList({required this.cookingRecipeList});

  final List<CookingRecipe> cookingRecipeList;

  @override
  State<StatefulWidget> createState() => _CookingRecipeExpansionListState();
}

class _CookingRecipeExpansionListState extends State<CookingRecipeExpansionList> {
  _CookingRecipeExpansionListState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: widget.cookingRecipeList.map<Widget>((cookingRecipe) => CookingRecipeListTile(cookingRecipe: cookingRecipe)).toList(),
    );
  }

}
