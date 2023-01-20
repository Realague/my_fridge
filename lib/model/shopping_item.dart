import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/utils/utils.dart';

class ShoppingItem {
  ShoppingItem(
      {this.id,
      required this.name,
      required this.unit,
      required this.quantity,
      required this.perishable,
      required this.createdAt,
      required this.createdBy,
      required this.storage,
      this.category = "",
      this.isBought = false,
      this.note = ""});

  String? id;

  String name;

  int unit;

  int quantity;

  bool perishable;

  String category;

  int storage;

  Storage get defaultStoragePlace => Storage.values[storage];

  String note;

  bool isBought;

  DateTime createdAt;

  String get createdAtDisplay => DateFormat('dd/MM/yyyy').format(createdAt);

  String createdBy;

  PackingType get packingType => PackingType.values[unit];

  set packingType(PackingType packingType) {
    unit = packingType.index;
  }

  bool isEditable = false;

  static ShoppingItem fromItem(Item item, int quantity, BuildContext context) {
    return ShoppingItem(
        name: item.name,
        unit: item.unit,
        quantity: quantity,
        perishable: item.perishable,
        category: item.category,
        storage: item.storage,
        createdAt: DateTime.now(),
        createdBy: UserService.currentUserId(context));
  }

  static ShoppingItem fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
        name: map['name'],
        unit: map['unit'],
        quantity: map['quantity'],
        perishable: map['perishable'],
        category: map['category'],
        note: map['note'],
        createdAt: map['created_at'],
        createdBy: map['created_by'],
        isBought: map['is_bought'],
        storage: map['storage']);
  }

  static ShoppingItem fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return ShoppingItem(
        id: document.id,
        name: data['name'],
        unit: data['unit'],
        quantity: data['quantity'],
        perishable: data["perishable"],
        note: data['note'],
        category: data['category'],
        createdAt: Utils.timestampToDateTime(data['created_at'])!,
        createdBy: data['created_by'],
        isBought: data['is_bought'],
        storage: data['storage']);
  }

  Map<String, Object?> get asMap {
    return {
      "name": this.name,
      "unit": this.unit,
      "quantity": this.quantity,
      "perishable": this.perishable,
      "category": this.category,
      "note": this.note,
      "created_by": this.createdBy,
      "created_at": this.createdAt,
      "storage": this.storage,
      "is_bought": this.isBought,
    };
  }
}
