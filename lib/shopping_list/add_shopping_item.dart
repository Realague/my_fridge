import 'package:flutter/material.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/services/item_service.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/shopping_list/shopping_item_add_item.dart';
import 'package:my_fridge/shopping_list/shopping_item_details.dart';
import 'package:my_fridge/widget/loader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/packing_type.dart';

class AddShoppingItem extends StatefulWidget {
  const AddShoppingItem();

  @override
  _AddShoppingItemState createState() => _AddShoppingItemState();
}

class _AddShoppingItemState extends State<AddShoppingItem> {
  late String _filter = "";

  Future<List<dynamic>> getSearchResult(String filter) async {
    List<Item> items = await ItemService.get(filter);
    bool hasFilterItem = false;
    for (Item item in items) {
      if (item.name == filter) {
        hasFilterItem = true;
        break;
      }
    }

    List<dynamic> results = [];
    if (!hasFilterItem && filter != "" && filter != " ") {
      results.add(filter);
    }
    for (Item item in items) {
      ShoppingItem? shoppingItem = await ShoppingListService.getByName(item.name, context);
      if (shoppingItem != null && shoppingItem.name == item.name) {
        results.add(shoppingItem);
      } else {
        results.add(item);
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          color: Colors.white,
          child: TextField(
            onChanged: (value) {
              setState(() {
                _filter = value;
              });
            },
            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.shopping_list_search_hint, prefixIcon: Icon(Icons.search)),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getSearchResult(_filter),
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return const Loader();
          }
          return ListView(
            children: snapshot.data!.map((item) => buildItem(context, item)).toList(),
          );
        }),
      ),
    );
  }

  Widget buildItem(BuildContext context, dynamic item) {
    if (item is ShoppingItem) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShoppingItemDetails(item: item)),
          );
        },
        child: ListTile(
            title: Row(children: [
              Expanded(flex: 2, child: Text(item.name)),
              Expanded(
                  flex: 1,
                  child: Text(
                      item.quantity != 0 && item.packingType != PackingType.NONE
                          ? '${item.quantity} ${item.packingType.displayTextForListTile(context)}'
                          : "",
                      textAlign: TextAlign.end))
            ]),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: Row(children: [Text(AppLocalizations.of(context)!.shopping_list_go_to_text), Icon(Icons.edit, size: 15)]),
            ),),
      );
    } else if (item is Item) {
      return InkWell(
        onTap: () {
          ShoppingListService.create(ShoppingItem.fromItem(item, 0, context), context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.shopping_list_item_added_snack_bar_message(item.name)),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
        child: ListTile(title: Text(item.name), trailing: Icon(Icons.add_circle_outline), iconColor: Theme.of(context).primaryColor),
      );
    } else if (item is String) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShoppingItemAddItem(itemName: item)));
        },
        child: ListTile(title: Text(item), trailing: Icon(Icons.add_circle_outline), iconColor: Theme.of(context).primaryColor),
      );
    }
    return Text("");
  }
}
