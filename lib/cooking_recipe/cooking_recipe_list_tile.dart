import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/cooking_recipe/cooking_recipe_details.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/services/cooking_recipe_service.dart';

class CookingRecipeListTile extends StatelessWidget {
  CookingRecipeListTile({required this.cookingRecipe}) : super();

  final CookingRecipe cookingRecipe;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context)!.storage_item_delete,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      child: _buildListTile(context),
      onDismissed: (direction) => CookingRecipeService.delete(cookingRecipe.id!, context),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      trailing: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CookingRecipeDetails(cookingRecipe: cookingRecipe),
                  settings: RouteSettings(name: "CookingRecipeDetails")),
            );
          },
          child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.chevron_right)])),
      title: Text(cookingRecipe.name),
      subtitle: Row(
        children: [
          Text(
            cookingRecipe.restTime.toString(),
          ),
        ],
      ),
    );
  }
}
