import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/ingredient.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/services/database.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/services/item_service.dart';

class ShoppingListService {
  static create(ShoppingItem item, BuildContext context) {
    DatabaseService.create(item.asMap, getCollectionInstance(context));
  }

  static createFromFridge(ShoppingItem item, BuildContext context) {
    DatabaseService.create(item.asMap, getCollectionInstance(context));
  }

  static update(ShoppingItem item, BuildContext context) {
    DatabaseService.update(item.id!, item.asMap, getCollectionInstance(context));
  }

  static CollectionReference getCollectionInstance(BuildContext context) {
    return HouseholdService.getSelectedHouseholdDoc(context).collection("shopping_list");
  }

  static delete(String itemId, BuildContext context) {
    DatabaseService.delete(itemId, getCollectionInstance(context));
  }

  static Future<ShoppingItem?> getByName(String name, BuildContext context) async {
    QuerySnapshot querySnapshot = await getCollectionInstance(context).where("name", isEqualTo: name).where("isBought", isEqualTo: false).get();
    if (querySnapshot.size != 0) {
      return ShoppingItem.fromDocument(querySnapshot.docs[0]);
    }
    return null;
  }

  static Future<ShoppingItem?> getAutomaticShoppingItemByNameAndUnit(String name, int unit, BuildContext context) async {
    QuerySnapshot querySnapshot = await getCollectionInstance(context).where("name", isEqualTo: name).where("unit", isEqualTo: unit).where("createdBy", isEqualTo: "automatic").where("isBought", isEqualTo: false).get();
    if (querySnapshot.size != 0) {
      return ShoppingItem.fromDocument(querySnapshot.docs[0]);
    }
    return null;
  }

  static Future<List<ShoppingItem>> getOrderBy(String field, BuildContext context) async {
    List<ShoppingItem> articles = [];
    return getCollectionInstance(context).orderBy(field, descending: false).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) => articles.add(ShoppingItem.fromDocument(document)));
      return articles;
    });
  }

  static Future<List<ShoppingItem>> getByCategory(BuildContext context, Category category, bool isBought) async {
    List<ShoppingItem> articles = [];
    return getCollectionInstance(context).where('category', isEqualTo: category.category).where('isBought', isEqualTo: isBought).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) => articles.add(ShoppingItem.fromDocument(document)));
      return articles;
    });
  }

  static Query getByCategoryAsQuery(BuildContext context, Category category, bool isBought) {
    return getCollectionInstance(context).where('category', isEqualTo: category.category).where('isBought', isEqualTo: isBought);
  }

  static Query getBoughtItems(BuildContext context) {
    return getCollectionInstance(context).where('isBought', isEqualTo: true);
  }

  static updateShoppingListForIngredient(BuildContext context, Ingredient ingredient) async {
    ShoppingItem? shoppingItem = await getAutomaticShoppingItemByNameAndUnit(ingredient.name, ingredient.unit, context);

    if (shoppingItem != null && shoppingItem.quantity < ingredient.quantity) {
      shoppingItem.quantity = ingredient.quantity;
      update(shoppingItem, context);
    } else if (shoppingItem == null) {
      Item? item = await ItemService.getByName(ingredient.name);
      create(ShoppingItem.fromIngredient(ingredient, ingredient.quantity, item!, context), context);
    }
  }

  static deleteAllBoughtItems(BuildContext context) {
    getBoughtItems(context).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        ShoppingItem boughItem = ShoppingItem.fromDocument(document);
        ShoppingListService.delete(boughItem.id!, context);
      });
    });
  }
}
