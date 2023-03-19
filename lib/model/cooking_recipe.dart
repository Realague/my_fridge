import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_fridge/model/Ingredient.dart';
import 'package:my_fridge/model/meal_type.dart';
import 'package:my_fridge/model/user.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/utils/utils.dart';

class CookingRecipe {
  CookingRecipe(
      {this.id,
      required this.name,
      required this.steps,
      required this.mealType,
      required this.ingredients,
      required this.preparationTime,
      required this.cookingTime,
      required this.restTime,
      this.createdBy,
      this.createdAt});

  String? id;

  String name;

  List<String> steps;

  int mealType;

  int preparationTime;

  int cookingTime;

  int restTime;

  List<Ingredient> ingredients;

  MealType get quantityUnit => MealType.values[mealType];

  String? createdBy;

  DateTime? createdAt;

  String get createdAtDisplay => DateFormat('dd/MM/yyyy').format(createdAt!);

  MealType get mealTypeValue => MealType.values[mealType];

  static CookingRecipe fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return CookingRecipe(
        id: document.id,
        name: data['name'],
        steps: List<String>.from(data['steps']),
        mealType: data['mealType'],
        ingredients: List<Ingredient>.from(
                data['ingredients'].map((e) => Ingredient.fromMap(e)))
            .toList(),
        cookingTime: data['cookingTime'],
        preparationTime: data['preparationTime'],
        restTime: data['restTime'],
        createdBy: data['createdBy'],
        createdAt: Utils.timestampToDateTime(data['createdAt']));
  }

  Map<String, Object> asMap(BuildContext context) {
    MyFridgeUser user = UserService.getCurrentUser(context);
    return {
      'name': this.name,
      'steps': this.steps,
      'ingredients': this.ingredients.map((e) => e.asMap).toList(),
      'mealType': this.mealType,
      'preparationTime': this.preparationTime,
      'cookingTime': this.cookingTime,
      'restTime': this.restTime,
      'createdBy': user.id!,
      'createdAt': DateTime.now()
    };
  }
}