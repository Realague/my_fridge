import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/article_management/article_list_tile.dart';
import 'package:my_fridge/forms/article_form.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/services/article_service.dart';
import 'package:my_fridge/widget/category_list.dart';
import 'package:my_fridge/widget/dialog.dart';
import 'package:my_fridge/widget/dismissible.dart';

class ArticleManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoryList(ArticleService.getByCategory, _buildArticleItem, true);
  }

  Widget _buildArticleItem(BuildContext context, DocumentSnapshot document) {
    Item article = Item.fromDocument(document);
    return DismissibleBothWay(
      key: Key(article.id!),
      child: ArticleListTile(article: article),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogFullScreen(
                title: AppLocalizations.of(context)!.add_article_popup_title,
                child: FormArticle(article: article),
              );
            },
          );
        } else {
          ArticleService.delete(article.id!);
        }
        return true;
      },
    );
  }
}
