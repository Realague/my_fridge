import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/fridge_article.dart';
import 'package:my_fridge/services/fridge_service.dart';
import 'package:my_fridge/widget/category_list.dart';
import 'package:my_fridge/widget/dialog.dart';
import 'package:my_fridge/widget/dismissible.dart';

import '../forms/fridge_article_form.dart';
import 'fridge_article_list_tile.dart';

class Fridge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FridgeState();
}

class _FridgeState extends State<Fridge> {
  @override
  Widget build(BuildContext context) {
    return CategoryList(
        FridgeService.getCollectionInstance(context), _buildFridgeItem, false);
  }

  Widget _buildFridgeItem(BuildContext context, DocumentSnapshot document) {
    FridgeArticle article = FridgeArticle.fromDocument(document);
    return DismissibleBothWay(
      key: Key(article.id!),
      child: FridgeArticleListTile(article: article),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogFullScreen(
                title: AppLocalizations.of(context)!.shopping_list_popup_title,
                child: Column(
                  children: [
                    FormFridgeArticle(article: article, id: article.id),
                  ],
                ),
              );
            },
          );
        } else {
          FridgeService.delete(article.id!, context);
        }
      },
    );
  }
}
