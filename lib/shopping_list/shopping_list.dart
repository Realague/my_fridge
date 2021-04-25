import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/forms/shopping_list_form_from_existing_article.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/widget/category_list.dart';
import 'package:my_fridge/widget/dialog.dart';
import 'package:my_fridge/widget/dismissible.dart';
import 'package:my_fridge/widget/shopping_list_item.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList() : super();

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  @override
  Widget build(BuildContext context) {
    return CategoryList(ShoppingListService.getCollectionInstance(context).orderBy('checked').snapshots(), _buildShoppingListItem, false);
  }

  Widget _buildShoppingListItem(BuildContext context, DocumentSnapshot document) {
    ShoppingArticle article = ShoppingArticle.fromDocument(document);
    return DismissibleBothWay(
      key: Key(article.id!),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: ShoppingListItem(article: article),
        onChanged: (value) {
          if (value != null) {
            article.checked = value;
            ShoppingListService.update(article, context);
          }
        },
        value: article.checked,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogFullScreen(
                title: AppLocalizations.of(context)!.shopping_list_popup_title,
                child: FormShoppingListFromExistingArticle(article: article),
              );
            },
          );
        } else {
          ShoppingListService.delete(article.id!, context);
        }
      },
    );
  }
}
