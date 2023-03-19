import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/user.dart';
import 'package:my_fridge/services/meal_list_service.dart';
import 'package:my_fridge/services/storage_service.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/widget/loader.dart';
import 'package:my_fridge/my_fridge_icons.dart';

class MealDetails extends StatefulWidget {
  const MealDetails({required this.meal});

  final CookingRecipe meal;

  @override
  State<StatefulWidget> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  _MealDetailsState();

  late CookingRecipe meal;

  @override
  void initState() {
    this.meal = widget.meal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(meal.name),
        leading: BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
      ),
      body: FutureBuilder(
          future: UserService.getUserById(context, meal.createdBy!),
          builder: (context, snapshot) {
            if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
              return const Loader();
            }

            MyFridgeUser? user = snapshot.data;
            return SingleChildScrollView(
              child: Column(children: [
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.white,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      labelText: AppLocalizations.of(context)!.form_article_name_label,
                    ),
                    initialValue: meal.name,
                    readOnly: true,
                  ),
                ),
                _buildCookingRecipeTimes(context),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.cooking_recipe_ingredients(meal.ingredients.length)),
                _buildIngredientList(context),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.cooking_recipe_steps(meal.steps.length)),
                _buildSteps(context),
                SizedBox(height: 10),
                _buildLifeCycle(context, user),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    MealListService.delete(meal.id!, context);
                    StorageService.useIngredientsOfMeal(context, meal);
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cook_meal),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ]),
            );
          }),
    );
  }

  Widget _buildCookingRecipeTimes(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 4),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Icon(MyFridge.preparation_time_icon),
              Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12), suffixText: "minutes"),
                      initialValue: meal.preparationTime.toString(),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              Text(AppLocalizations.of(context)!.cooking_recipe_preparation_time)
            ],
          ),
          Column(
            children: [
              Icon(MyFridge.cooking_time_icon),
              Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12), suffixText: "minutes"),
                      initialValue: meal.cookingTime.toString(),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              Text(AppLocalizations.of(context)!.cooking_recipe_cooking_time)
            ],
          ),
          Column(
            children: [
              Icon(MyFridge.rest_time_icon),
              Row(
                children: [
                  SizedBox(
                    width: 110,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12), suffixText: "minutes"),
                      initialValue: meal.restTime.toString(),
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              Text(AppLocalizations.of(context)!.cooking_recipe_rest_time)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientList(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: meal.ingredients.map<Widget>((ingredient) {
            return ListTile(
              title: Text(ingredient.name),
              subtitle: Text(ingredient.quantity != 0 && ingredient.packingType != PackingType.NONE
                  ? '${ingredient.quantity} ${ingredient.packingType.displayTextForListTile(context)}'
                  : ""),
            );
          }).toList(),
        ),
    );
  }

  Widget _buildSteps(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: meal.steps.map<Widget>((step) {
            return ListTile(
              title: Text(AppLocalizations.of(context)!.cooking_recipe_step(meal.steps.indexOf(step))),
              subtitle: Text(step, maxLines: 4),
            );
          }).toList(),
        ),
    );
  }

  Widget _buildLifeCycle(BuildContext context, MyFridgeUser? user) {
    if (user != null) {
      return Column(children: [
        Container(
          color: Colors.white,
          child: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: meal.createdAtDisplay,
            readOnly: true,
            enabled: false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              labelText: AppLocalizations.of(context)!.cooking_recipe_created_at,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: TextFormField(
            keyboardType: TextInputType.text,
            initialValue: user.username,
            readOnly: true,
            enabled: false,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              labelText: AppLocalizations.of(context)!.cooking_recipe_created_by,
            ),
          ),
        )
      ]);
    } else {
      return SizedBox();
    }
  }
}
