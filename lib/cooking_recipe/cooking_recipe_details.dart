import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/cooking_recipe/add_ingredient.dart';
import 'package:my_fridge/cooking_recipe/add_step.dart';
import 'package:my_fridge/cooking_recipe/search_ingredient.dart';
import 'package:my_fridge/model/ingredient.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/model/meal_type.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/user.dart';
import 'package:my_fridge/services/cooking_recipe_service.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/widget/loader.dart';
import 'package:my_fridge/my_fridge_icons.dart';

class CookingRecipeDetails extends StatefulWidget {
  const CookingRecipeDetails({this.cookingRecipe, this.cookingRecipeName});

  final CookingRecipe? cookingRecipe;

  final String? cookingRecipeName;

  @override
  State<StatefulWidget> createState() => _CookingRecipeDetailsState();
}

class _CookingRecipeDetailsState extends State<CookingRecipeDetails> {
  _CookingRecipeDetailsState();

  TextEditingController expiryDateInput = TextEditingController();

  late CookingRecipe cookingRecipe;

  @override
  void initState() {
    this.cookingRecipe = widget.cookingRecipe ??
        CookingRecipe(
            name: widget.cookingRecipeName!,
            steps: [],
            mealType: MealType.DISH.index,
            ingredients: [],
            preparationTime: 0,
            cookingTime: 0,
            restTime: 0,
            createdBy: "");
    super.initState();
  }

  @override
  void dispose() {
    expiryDateInput.dispose();
    super.dispose();
  }

  void _addIngredient(Ingredient ingredient) {
    setState(() {
      cookingRecipe.ingredients.add(ingredient);
    });
  }

  void _editIngredient(Ingredient ingredient) {
    setState(() {
      for (Ingredient item in cookingRecipe.ingredients) {
        if (item.name == ingredient.name) {
          cookingRecipe.ingredients.remove(item);
        }
      }
      cookingRecipe.ingredients.add(ingredient);
    });
  }

  void _editStep(String step) {
    setState(() {
      for (String item in cookingRecipe.steps) {
        if (item == step) {
          cookingRecipe.steps.remove(item);
        }
      }
      cookingRecipe.steps.add(step);
    });
  }

  void _addStep(String step) {
    setState(() {
      cookingRecipe.steps.add(step);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(cookingRecipe.name),
        leading: BackButton(),
      ),
      body: FutureBuilder(
          future: UserService.getUserById(context, cookingRecipe.createdBy!),
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
                  child: DropdownSearch<MealType>(
                      compareFn: (MealType mealType, MealType mealType2) {
                        return mealType.index == mealType2.index;
                      },
                      popupProps: PopupProps.modalBottomSheet(
                        showSelectedItems: true,
                        title: ListTile(title: Text(AppLocalizations.of(context)!.cooking_recipe_meal_type)),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(labelText: AppLocalizations.of(context)!.cooking_recipe_meal_type),
                      ),
                      items: MealType.values,
                      itemAsString: (MealType mealType) => mealType.display(context),
                      selectedItem: cookingRecipe.mealTypeValue,
                      onChanged: (MealType? mealType) {
                        setState(() {
                          cookingRecipe.mealType = mealType!.index;
                        });
                      }),
                ),
                _buildCookingRecipeTimes(context),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.cooking_recipe_ingredients(cookingRecipe.ingredients.length)),
                _buildIngredientList(context),
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.white,
                  child: Row(children: [
                    Expanded(flex: 4, child: Text(AppLocalizations.of(context)!.cooking_recipe_add_ingredient)),
                    Expanded(
                      flex: 1,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SearchIngredient(ingredients: cookingRecipe.ingredients, addIngredient: _addIngredient)));
                        },
                        child: Icon(Icons.add),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).primaryColor),
                          shape: WidgetStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 10),
                Text(AppLocalizations.of(context)!.cooking_recipe_steps(cookingRecipe.steps.length)),
                _buildSteps(context),
                Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.white,
                  child: Row(children: [
                    Expanded(flex: 4, child: Text(AppLocalizations.of(context)!.cooking_recipe_add_step)),
                    Expanded(
                      flex: 1,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddStep(step: "", addStep: _addStep, stepCount: cookingRecipe.steps.length)));
                        },
                        child: Icon(Icons.add),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).primaryColor),
                          shape: WidgetStateProperty.all(
                            CircleBorder(),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 10),
                _buildLifeCycle(context, user),
                SizedBox(height: 10),
                FilledButton(
                  onPressed: () {
                    CookingRecipeService.create(cookingRecipe, context);
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cooking_recipe_save),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).primaryColor),
                    shape: WidgetStateProperty.all(
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
                      initialValue: cookingRecipe.preparationTime.toString(),
                      onChanged: (preparationTime) {
                        cookingRecipe.preparationTime = int.tryParse(preparationTime) ?? 0;
                      },
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
                      initialValue: cookingRecipe.cookingTime.toString(),
                      onChanged: (cookingTime) {
                        cookingRecipe.cookingTime = int.tryParse(cookingTime) ?? 0;
                      },
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
                      initialValue: cookingRecipe.restTime.toString(),
                      onChanged: (restTime) {
                        cookingRecipe.restTime = int.tryParse(restTime) ?? 0;
                      },
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
        children: cookingRecipe.ingredients.map<Widget>((ingredient) {
          return Dismissible(
            key: Key(ingredient.name),
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
            onDismissed: (direction) {
              cookingRecipe.ingredients.remove(ingredient);
            },
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddIngredient(ingredient: ingredient, addIngredient: _editIngredient)),
                );
              },
              child: ListTile(
                title: Text(ingredient.name),
                subtitle: Text(ingredient.quantity != 0 && ingredient.packingType != PackingType.NONE
                    ? '${ingredient.quantity} ${ingredient.packingType.displayTextForListTile(context)}'
                    : ""),
              ),
            ),
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
        children: cookingRecipe.steps.map<Widget>((step) {
          return Dismissible(
            key: Key(step),
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
            onDismissed: (direction) {
              cookingRecipe.steps.remove(step);
            },
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddStep(step: step, addStep: _editStep, stepCount: cookingRecipe.steps.indexOf(step))),
                );
              },
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.cooking_recipe_step(cookingRecipe.steps.indexOf(step))),
                subtitle: Text(step, maxLines: 4),
              ),
            ),
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
            initialValue: cookingRecipe.createdAtDisplay,
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
