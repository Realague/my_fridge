import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/forms/select_article_form.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/utils/utils.dart';
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
    return CategoryList(ShoppingListService.getByCategory, _buildShoppingListItem, false);
  }

  void confirmCallback(Item article, int quantity) => ShoppingListService.update(ShoppingItem.fromItem(article, quantity), context);

  Widget _buildShoppingListItem(BuildContext context, DocumentSnapshot document) {
    ShoppingItem article = ShoppingItem.fromDocument(document);
    return DismissibleBothWay(
      key: Key(article.id!),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: ShoppingListItem(article: article),
        onChanged: (value) async {
          if (value != null) {
            article.checked = value;

            if (article.perishable) {
              var expiryDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2025),
              );
              article.expiryDate = expiryDate;
            }
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
                child: SelectArticleForm(
                  confirmCallback: (art, quantity) {
                    ShoppingItem shoppingArticle = ShoppingItem.fromItem(art, quantity);
                    shoppingArticle.id = article.id;
                    ShoppingListService.update(shoppingArticle, context);
                    Navigator.pop(context);
                  },
                  article: article,
                ),
              );
            },
          );
        } else {
          await Utils.showConfirmDialog(
              context, AppLocalizations.of(context)!.confirm_delete_shopping_list_article, ShoppingListService.delete, article.id!);
        }
        return true;
      },
    );
  }
}
