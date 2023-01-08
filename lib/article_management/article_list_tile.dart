import 'package:flutter/material.dart';
import 'package:my_fridge/model/article.dart';
import 'package:my_fridge/model/packing_type.dart';

class ArticleListTile extends StatelessWidget {
  ArticleListTile({required this.article}) : super();

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${article.name} ${article.packingType.displayText(context)}'),
    );
  }
}
