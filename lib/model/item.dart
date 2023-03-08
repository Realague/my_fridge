import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/utils/utils.dart';

class Item {
  Item({this.id, required this.name, required this.unit, required this.perishable, this.createdAt, this.createdBy, this.category = " ", required this.storage});

  static Item fromShoppingItem(ShoppingItem item, BuildContext context) {
    return Item(name: item.name, unit: item.unit, perishable: item.perishable, category: item.category, storage: item.storage, createdAt: DateTime.now(), createdBy: UserService.currentUserId(context));
  }

  String? id;

  String name;

  int unit;

  bool perishable;

  String category;

  int storage;

  Storage get defaultStoragePlace => Storage.values[storage];

  DateTime? createdAt;

  String? createdBy;

  PackingType get packingType => PackingType.values[unit];

  static Item fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Item(
      id: document.id,
      name: data['name'],
      unit: data['unit'],
      perishable: data['perishable'],
      category: data['category'],
      storage: data['storage'],
      createdAt: Utils.timestampToDateTime(data['created_at']),
      createdBy: data['created_by'],
    );
  }

  Map<String, Object> get asMap {
    return {
      'name': this.name,
      'unit': this.unit,
      'perishable': this.perishable,
      'storage': this.storage,
      'category': this.category,
      "created_by": this.createdBy!,
      "created_at": this.createdAt!
    };
  }
}
