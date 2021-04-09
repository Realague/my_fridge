import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/forms/shopping_list_form.dart';
import 'package:my_fridge/forms/shopping_list_form_from_existing_article.dart';
import 'package:my_fridge/services/shopping_list.dart';
import 'package:my_fridge/quantity_unit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/widget/dialog.dart';
import 'package:my_fridge/widget/dismissible.dart';
import '../article.dart';

class ShoppingList extends StatelessWidget {
  _addArticle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogFullScreen(
            title: "",
            child: Column(
              children: [
                FormShoppingListFromExistingArticle(),
                const Divider(
                  color: Colors.grey,
                  height: 50,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                FormShoppingList(),
              ],
            ));
      },
    );
  }

  Widget _buildShoppingListItem(BuildContext context, DocumentSnapshot document) {
    Article article = Article(document.data()!['name'], document.data()!['unit']);
    return DismissibleBothWay(
      key: Key(document.id),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(article.name),
            ),
            Expanded(
              child: Text(document.data()!['quantity'].toString() + " " + article.quantityUnit.displayForDropDown(context)),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          ShoppingListService.delete(document.id, context);
        }
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogFullScreen(
                title: AppLocalizations.of(context)!.shopping_list_popup_title,
                child: Column(
                  children: [
                    FormShoppingListFromExistingArticle(article: article, quantity: document.data()!['quantity'], id: document.id),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          StreamBuilder(
            stream: ShoppingListService.getCollectionInstance(context).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading");
              }
              return SingleChildScrollView(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemExtent: 80,
                  itemCount: (snapshot.data as QuerySnapshot).docs.length,
                  itemBuilder: (context, index) => _buildShoppingListItem(context, (snapshot.data as QuerySnapshot).docs[index]),
                ),
              );
            },
          ),
          FloatingActionButton(
            onPressed: () => _addArticle(context),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
