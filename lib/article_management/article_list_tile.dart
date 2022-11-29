import 'package:flutter/material.dart';
import 'package:my_fridge/model/article.dart';
import 'package:my_fridge/model/quantity_unit.dart';

class ArticleListTile extends StatelessWidget {
  ArticleListTile({required this.article}) : super();

  final Article article;

  @override
  Widget build(final BuildContext context) {
    return ListTile(
      title: Text(
          '${article.name} ${article.quantityUnit.displayForDropDown(context)}'),
    );
  }
}
