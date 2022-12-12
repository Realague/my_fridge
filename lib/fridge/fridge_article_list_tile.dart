import 'package:flutter/material.dart';
import 'package:my_fridge/model/fridge_article.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/utils/utils.dart';

class FridgeArticleListTile extends StatelessWidget {
  FridgeArticleListTile({required this.article}) : super();

  final FridgeArticle article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Utils.nullDateTime == article.expiryDate ||
              article.expiryDate == null ||
              DateTime.now().add(const Duration(days: 3)).isBefore(article.expiryDate!)
          ? Colors.white
          : DateTime.now().add(const Duration(days: 1)).isAfter(article.expiryDate!)
              ? Colors.red
              : Colors.amber,
      title: Text('${article.name} ${article.quantity} ${article.packingType.displayText(context)}'),
      subtitle: Text('${Utils.nullDateTime != article.expiryDate ? article.expiryDateDisplay : ""}'),
    );
  }
}
