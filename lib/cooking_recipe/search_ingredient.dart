import 'package:flutter/material.dart';
import 'package:my_fridge/cooking_recipe/add_ingredient.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/services/item_service.dart';
import 'package:my_fridge/shopping_list/shopping_item_add_item.dart';
import 'package:my_fridge/shopping_list/shopping_item_details.dart';
import 'package:my_fridge/widget/loader.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchIngredient extends StatefulWidget {
  SearchIngredient({required this.ingredients, required this.addIngredient});

  final List<ShoppingItem> ingredients;
  final Function(ShoppingItem) addIngredient;

  @override
  _SearchIngredientItemState createState() => _SearchIngredientItemState();
}

class _SearchIngredientItemState extends State<SearchIngredient> {
  late String _filter = "";

  Future<List<dynamic>> getSearchResult(String filter) async {
    List<Item> items = await ItemService.get(filter);

    List<dynamic> results = [];
    for (Item item in items) {
      bool alreadyInIngredients = false;
      for (ShoppingItem ingredient in widget.ingredients) {
        if (ingredient.name == item.name) {
          results.add(ingredient);
          alreadyInIngredients = true;
        }
      }
      if (!alreadyInIngredients) {
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
      return ListTile(
          title: Text(item.name),
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
            child: Text("Ajouté"),
          ),
      );
    } else if (item is Item) {
      return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddIngredient(ingredient: ShoppingItem.fromItem(item, 0, context), addIngredient: widget.addIngredient)));
        },
        child: ListTile(title: Text(item.name), trailing: Icon(Icons.add_circle_outline), iconColor: Theme.of(context).primaryColor),
      );
    } else if (item is String) {
      return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingItemAddItem(itemName: item)));
        },
        child: ListTile(title: Text(item), trailing: Icon(Icons.add_circle_outline), iconColor: Theme.of(context).primaryColor),
      );
    }
    return Text("");
  }
}
