import 'package:flutter/material.dart';
import 'package:my_fridge/model/fridge_article.dart';
import 'package:my_fridge/model/quantity_unit.dart';

class FridgeArticleListTile extends StatelessWidget {
  FridgeArticleListTile({required this.article}) : super();

  final FridgeArticle article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${article.name} ${article.quantity} ${article.quantityUnit.displayForDropDown(context)}'),
      subtitle: Text('${article.expiryDateDisplay}'),
    );
  }
}
