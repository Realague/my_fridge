import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/services/database.dart';
import 'package:my_fridge/model/services/household_service.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:my_fridge/model/storage_item.dart';

class StorageService {
  static create(StorageItem item, BuildContext context) async {
    if (item.perishable) {
      DatabaseService.create(item.asMap, getCollectionInstance(context));
    } else {
      StorageItem? existingArticle = await getByArticle(item, context);
      if (existingArticle != null) {
        existingArticle.quantity += item.quantity;
        update(existingArticle, context);
      } else {
        DatabaseService.create(item.asMap, getCollectionInstance(context));
      }
    }
  }

  static createFromShoppingArticle(ShoppingArticle article, BuildContext context, {DateTime? expiryDate}) {
    Map<String, Object?> map = {
      'name': article.name,
      'unit': article.unit,
      'quantity': article.quantity,
      'perishable': article.perishable,
      'category': article.category,
      'expiry_date': expiryDate
    };
    DatabaseService.create(map, getCollectionInstance(context));
  }

  static update(StorageItem item, BuildContext context) {
    DatabaseService.update(item.id!, item.asMap, getCollectionInstance(context));
  }

  static CollectionReference getCollectionInstance(BuildContext context) {
    return HouseholdService.getSelectedHouseholdDoc(context).collection("storage");
  }

  static delete(String itemId, BuildContext context) {
    DatabaseService.delete(itemId, getCollectionInstance(context));
  }

  static Future<List<StorageItem>> getOrderBy(String field, BuildContext context) async {
    List<StorageItem> items = [];
    return getCollectionInstance(context).orderBy(field).get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) => items.add(StorageItem.fromDocument(document)));
      return items;
    });
  }

  static Future<StorageItem?> getByArticle(StorageItem item, BuildContext context) {
    return getCollectionInstance(context)
        .where('name', isEqualTo: item.name)
        .where('unit', isEqualTo: item.unit)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.length != 1) {
        return null;
      }
      return StorageItem.fromDocument(querySnapshot.docs[0]);
    });
  }

  static Future<List<dynamic>> getUniqueItemByStorage(BuildContext context, Storage storage) async {
    List<dynamic> items = [];
    QuerySnapshot querySnapshot = await getCollectionInstance(context).where('storage', isEqualTo: storage.index).get();
    querySnapshot.docs.forEach((document) {
      StorageItem newItem = StorageItem.fromDocument(document);

      for (var item in items) {
        if (item is StorageItem && item.name == item.name) {
          items.remove(item);
          items.add([newItem, item]);
          return;
        } else if (item is List<StorageItem> && item[0].name == newItem.name) {
          item.add(newItem);
          return;
        }
      }
      items.add(newItem);
    });

    return items;
  }

  static Query getItemsByName(BuildContext context, String name) {
    return getCollectionInstance(context).where('name', isEqualTo: name);
  }
}