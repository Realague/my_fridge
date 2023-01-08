import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/storage_item.dart';
import 'package:my_fridge/services/storage_service.dart';
import 'package:my_fridge/storage/storage_item_details.dart';

import '../services/household_service.dart';

class StorageItemListTile extends StatelessWidget {
  StorageItemListTile({required this.item}) : super();

  final StorageItem item;

  Color determineExpiryDateTextColor(BuildContext context, StorageItem item) {
    Color expiryDateTextColor = Colors.black;
    if (item.expiryDate == null && item.perishable) {
      expiryDateTextColor = Colors.red;
    } else if (item.expiryDate != null &&
        HouseholdService.getSelectedHousehold(context).expiredItemWarningDelay < item.expiryDate!.difference(DateTime.now()).inDays) {
      expiryDateTextColor = Colors.red;
    }
    return expiryDateTextColor;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id!),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context)!.storage_item_delete,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
      child: _buildListTile(context),
      onDismissed: (direction) => StorageService.delete(item.id!, context),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      trailing: InkWell(
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StorageItemDetails(item: item)),
              ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.chevron_right)])),
      title: Row(children: [
        Text(item.name),
        Text(item.quantity != 0 ? '${item.quantity} ${item.packingType.displayTextForListTile(context)}' : "", textAlign: TextAlign.end),
      ]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.getBoughtAtDisplayForListTile(context),
            style: TextStyle(color: determineExpiryDateTextColor(context, item)),
          ),
          Text(AppLocalizations.of(context)!.storage_item_bought_at_list_tile(item.daysSinceBought))
        ],
      ),
    );
  }
}
