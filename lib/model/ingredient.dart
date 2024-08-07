import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/utils/utils.dart';

class Ingredient {
  Ingredient(
      {this.id,
        required this.name,
        required this.unit,
        required this.quantity,
        required this.createdAt,
        required this.createdBy});

  String? id;

  String name;

  int unit;

  int quantity;

  DateTime createdAt;

  String get createdAtDisplay => DateFormat('dd/MM/yyyy').format(createdAt);

  String createdBy;

  PackingType get packingType => PackingType.values[unit];

  set packingType(PackingType packingType) {
    unit = packingType.index;
  }

  static Ingredient fromItem(Item item, int quantity, BuildContext context) {
    return Ingredient(
        name: item.name,
        unit: item.unit,
        quantity: quantity,
        createdAt: DateTime.now(),
        createdBy: UserService.currentUserId(context));
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
        name: toBeginningOfSentenceCase(map['name']),
        unit: map['unit'],
        quantity: map['quantity'],
        createdAt: Utils.timestampToDateTime(map['createdAt'])!,
        createdBy: map['createdBy']);
  }

  static Ingredient fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return Ingredient(
        id: document.id,
        name: toBeginningOfSentenceCase(data['name']),
        unit: data['unit'],
        quantity: data['quantity'],
        createdAt: Utils.timestampToDateTime(data['createdAt'])!,
        createdBy: data['createdBy'],);
  }

  Map<String, Object?> get asMap {
    return {
      "name": this.name.toLowerCase(),
      "unit": this.unit,
      "quantity": this.quantity,
      "createdBy": this.createdBy,
      "createdAt": this.createdAt,
    };
  }
}
