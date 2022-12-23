import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/quantity_unit.dart';
import 'package:my_fridge/model/storage_item.dart';

class StorageItemListTile extends StatelessWidget {
  StorageItemListTile({required this.item}) : super();

  final StorageItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      /*tileColor: Utils.nullDateTime == item.expiryDate ||
              item.expiryDate == null ||
              DateTime.now().add(const Duration(days: 3)).isBefore(item.expiryDate!)
          ? Colors.white
          : DateTime.now().add(const Duration(days: 1)).isAfter(item.expiryDate!)
              ? Colors.red
              : Colors.amber,*/
      title: Row(children: [
        Text(item.name),
        Text(item.quantity != 0 ? '${item.quantity} ${item.packingType.displayTextForListTile(context)}' : "")
      ]),
      subtitle: Column(
        children: [Text(item.expiryDateDisplay), Text(AppLocalizations.of(context)!.storage_item_bought_at(item.daysSinceBought))],
      ),
    );
  }
}
