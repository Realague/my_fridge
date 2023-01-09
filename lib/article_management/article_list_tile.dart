import 'package:flutter/material.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/packing_type.dart';

class ArticleListTile extends StatelessWidget {
  ArticleListTile({required this.article}) : super();

  final Item article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${article.name} ${article.packingType.displayText(context)}'),
    );
  }
}
