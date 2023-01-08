import 'package:flutter/material.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/shopping_article.dart';

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({required this.article}) : super();

  final ShoppingArticle article;

  @override
  Widget build(BuildContext context) {
    if (article.checked) {
      return Text(
        article.name + " " + article.quantity.toString() + " " + article.packingType.displayText(context),
        style: TextStyle(
          decoration: TextDecoration.lineThrough,
        ),
      );
    } else {
      return Text(article.name + " " + article.quantity.toString() + " " + article.packingType.displayText(context));
    }
  }
}
