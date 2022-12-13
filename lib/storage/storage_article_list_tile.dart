import 'package:flutter/material.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/model/storage_item.dart';
import 'package:my_fridge/utils/utils.dart';

class StorageItemListTile extends StatelessWidget {
  StorageItemListTile({required this.item}) : super();

  final StorageItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Utils.nullDateTime == item.expiryDate ||
              item.expiryDate == null ||
              DateTime.now().add(const Duration(days: 3)).isBefore(item.expiryDate!)
          ? Colors.white
          : DateTime.now().add(const Duration(days: 1)).isAfter(item.expiryDate!)
              ? Colors.red
              : Colors.amber,
      title: Text('${item.name} ${item.quantity} ${item.packingType.displayText(context)}'),
      subtitle: Text('${Utils.nullDateTime != item.expiryDate ? item.expiryDateDisplay : ""}'),
    );
  }
}
