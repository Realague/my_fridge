import 'package:flutter/material.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/services/cooking_recipe_service.dart';
import 'package:my_fridge/services/meal_list_service.dart';
import 'package:my_fridge/widget/loader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchMeal extends StatefulWidget {
  const SearchMeal();

  @override
  _SearchMealState createState() => _SearchMealState();
}

class _SearchMealState extends State<SearchMeal> {
  late String _filter = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          color: Colors.white,
          child: TextField(
            onChanged: (value) {
              setState(() {
                _filter = value;
              });
            },
            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.shopping_list_search_hint, prefixIcon: Icon(Icons.search)),
          ),
        ),
      ),
      body: FutureBuilder<List<CookingRecipe>>(
        future: CookingRecipeService.get(_filter, context),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Loader();
          }
          return ListView(
            children: snapshot.data!.map((cookingRecipe) => buildCookingRecipe(context, cookingRecipe)).toList(),
          );
        }),
      ),
    );
  }

  Widget buildCookingRecipe(BuildContext context, CookingRecipe cookingRecipe) {
    return InkWell(
      onTap: () {
        MealListService.create(cookingRecipe, context);
        MealListService.updateShoppingListWithMealListIngredient(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.meal_added_snack_bar_message(cookingRecipe.name)),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
      child: ListTile(title: Text(cookingRecipe.name), trailing: Icon(Icons.add_circle_outline), iconColor: Theme.of(context).primaryColor),
    );
  }
}
