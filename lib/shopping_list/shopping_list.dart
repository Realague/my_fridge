import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/shopping_list/category_list.dart';
import 'package:my_fridge/shopping_list/shopping_list_item.dart';
import 'package:my_fridge/shopping_list/shopping_list_item_bought.dart';
import 'package:my_fridge/widget/loader.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList() : super();

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const CategoryList(),
      _buildShoppingItemBought(context),
    ]);
  }

  Widget _buildShoppingItemBought(BuildContext context) {
    return ExpansionTile(
        title: Text(AppLocalizations.of(context)!.shopping_list_bough_shopping_items),
        subtitle: InkWell(child: Text(AppLocalizations.of(context)!.shopping_list_delete_all_bought_items), onTap: () {
          setState(() {
            ShoppingListService.deleteAllBoughtItems(context);
          });
        },),
        children: [
          StreamBuilder(
            stream: ShoppingListService.getBoughtItems(context).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loader();
              }

              return ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: (snapshot.data as QuerySnapshot).docs.length,
                  itemBuilder: (context, index) {
                    ShoppingItem shoppingItem = ShoppingItem.fromDocument((snapshot.data as QuerySnapshot).docs[index]);
                    return ShoppingListItemBought(shoppingItem: shoppingItem);
                  });
            },
          ),
        ]);
  }
}
