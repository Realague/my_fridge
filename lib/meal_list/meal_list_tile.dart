import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/meal_list/meal_details.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/services/meal_list_service.dart';

class MealListTile extends StatelessWidget {
  MealListTile({required this.meal}) : super();

  final CookingRecipe meal;

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
      onDismissed: (direction) => MealListService.delete(meal.id!, context),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      trailing: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MealDetails(meal: meal)),
            );
          },
          child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.chevron_right)])),
      title: Text(meal.name),
      subtitle: Row(
        children: [
          Text(
            meal.restTime.toString(),
          ),
        ],
      ),
    );
  }
}
