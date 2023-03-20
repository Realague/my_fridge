import 'package:flutter/material.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'meal_list_tile.dart';

class MealExpansionList extends StatefulWidget {
  const MealExpansionList({required this.mealList});

  final List<CookingRecipe> mealList;

  @override
  State<StatefulWidget> createState() => _MealExpansionListState();
}

class _MealExpansionListState extends State<MealExpansionList> {
  _MealExpansionListState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: widget.mealList.map<Widget>((meal) => MealListTile(meal: meal)).toList(),
    );
  }

}
