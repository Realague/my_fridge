import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/shopping_article.dart';

class CookingRecipe {
  CookingRecipe(
      {this.id,
      required this.name,
      required this.steps,
      required this.category,
      required this.ingredients});

  String? id;

  String name;

  String steps;

  String category;

  List<ShoppingArticle> ingredients;

  static CookingRecipe fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return CookingRecipe(
        id: document.id,
        name: data['name'],
        steps: data['steps'],
        category: data['category'],
        ingredients: List<ShoppingArticle>.from(
                data['ingredients'].map((e) => ShoppingArticle.fromMap(e)))
            .toList());
  }

  Map<String, Object> get asMap {
    return {
      'name': this.name,
      'steps': this.steps,
      'ingredients': this.ingredients.map((e) => e.asMap).toList(),
      'category': " ",
    };
  }
}
