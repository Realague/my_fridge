import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/ingredient.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/model/meal_type.dart';
import 'package:my_fridge/services/database.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/services/storage_service.dart';

class MealListService {
  static CollectionReference getCollectionInstance(BuildContext context) {
    return HouseholdService.getSelectedHouseholdDoc(context).collection("meal_list");
  }

  static create(CookingRecipe cookingRecipe, BuildContext context) {
    DatabaseService.create(cookingRecipe.asMap(context), getCollectionInstance(context));
  }

  static update(CookingRecipe cookingRecipe, BuildContext context) {
    DatabaseService.update(cookingRecipe.id!, cookingRecipe.asMap(context), getCollectionInstance(context));
  }

  static delete(String mealId, BuildContext context) {
    DatabaseService.delete(mealId, getCollectionInstance(context));
  }

  static Future<List<CookingRecipe>> get(String? searchFilter, BuildContext context) async {
    List<CookingRecipe> meals = [];
    if (searchFilter == null || searchFilter == '') {
      return getCollectionInstance(context).limit(10).get().then((querySnapshot) {
        querySnapshot.docs.forEach((document) => meals.add(CookingRecipe.fromDocument(document)));
        return meals;
      });
    }
    return getCollectionInstance(context)
        .where('name', isGreaterThanOrEqualTo: searchFilter)
        .where('name', isLessThan: searchFilter)
        .limit(10)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((document) => meals.add(CookingRecipe.fromDocument(document)));
      return meals;
    });
  }

  static Future<List<CookingRecipe>> getByMealType(MealType mealType, BuildContext context) async {
    List<CookingRecipe> meals = [];

    QuerySnapshot querySnapshot = await getCollectionInstance(context).where('mealType', isEqualTo: mealType.index).get();
    querySnapshot.docs.forEach((document) => meals.add(CookingRecipe.fromDocument(document)));
    return meals;
  }

  static Future<List<CookingRecipe>> getAll(BuildContext context) async {
    List<CookingRecipe> meals = [];

    QuerySnapshot querySnapshot = await getCollectionInstance(context).get();
    querySnapshot.docs.forEach((document) => meals.add(CookingRecipe.fromDocument(document)));
    return meals;
  }

  static Future<List<Ingredient>> getNeededIngredientsForCurrentMeals(BuildContext context) async {
    List<CookingRecipe> meals = [];
    List<Ingredient> ingredients = [];

    QuerySnapshot querySnapshot = await getCollectionInstance(context).get();
    querySnapshot.docs.forEach((document) => meals.add(CookingRecipe.fromDocument(document)));
    return ingredients;
  }

  static List<Ingredient> getIngredientsFromMealList(List<CookingRecipe> cookingRecipeList) {
    List<Ingredient> ingredients = [];

    for (CookingRecipe cookingRecipe in cookingRecipeList) {
      ingredients = mergeIngredientFromMealToArray(cookingRecipe, ingredients);
    }

    return ingredients;
  }

  static List<Ingredient> mergeIngredientFromMealToArray(CookingRecipe cookingRecipe, List<Ingredient> ingredients) {
    for (Ingredient ingredient in cookingRecipe.ingredients) {
      bool alreadyInList = false;

      for (int i = 0; i != ingredients.length; i++) {
        if (ingredient.name == ingredients[i].name && ingredient.unit == ingredients[i].unit) {
          ingredients[i].quantity += ingredient.quantity;
          alreadyInList = true;
        }
      }

      if (!alreadyInList) {
        ingredients.add(ingredient);
      }
    }

    return ingredients;
  }

  static updateShoppingListWithMealListIngredient(BuildContext context) async {
    List<CookingRecipe> mealList = await getAll(context);
    List<Ingredient> ingredients = getIngredientsFromMealList(mealList);

    ingredients = await StorageService.getMissingIngredients(context, ingredients);

    for (Ingredient ingredient in ingredients) {
      ShoppingListService.updateShoppingListForIngredient(context, ingredient);
    }
  }
}
