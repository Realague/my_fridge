import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/services/authentication_service.dart';
import 'package:my_fridge/services/user.dart';
import 'package:provider/provider.dart';

import '../article.dart';
import 'database.dart';

class ShoppingListService {

  static create(Article article, int quantity, BuildContext context) {
    Map<String, Object> data = {
      "name": article.name,
      "unit": article.unit,
      "quantity": quantity,
    };

    DatabaseService.create(null, data, getCollectionInstance(context));
  }

  static update(String id, Article article, int quantity, BuildContext context) {
    Map<String, Object> data = {
      "name": article.name,
      "unit": article.unit,
      "quantity": quantity,
    };

    DatabaseService.update(id, data, getCollectionInstance(context));
  }

  static CollectionReference getCollectionInstance(BuildContext context) {
    return UserService
        .collectionInstance
        .doc(context.read<AuthenticationService>().currentUser!.uid)
        .collection("shopping_list");
  }

  static delete(String articleId, BuildContext context) {
    DatabaseService.delete(articleId,  getCollectionInstance(context));
  }
}
