import 'package:flutter/material.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/storage_item.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/services/storage_service.dart';
import 'package:my_fridge/shopping_list/shopping_item_details.dart';

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({required this.shoppingItem}) : super();

  final ShoppingItem shoppingItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(shoppingItem.id!),
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
      child: ListTile(
        trailing: InkWell(
          child: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingItemDetails(item: shoppingItem)));
          },
        ),
        title: InkWell(
          onTap: () => _onShoppingItemTap(context),
          child: Row(children: [
            Expanded(flex: 2, child: Text(shoppingItem.name)),
            Expanded(
                flex: 1,
                child: Text(
                    shoppingItem.quantity != 0 && shoppingItem.packingType != PackingType.NONE
                        ? '${shoppingItem.quantity} ${shoppingItem.packingType.displayTextForListTile(context)}'
                        : "",
                    textAlign: TextAlign.end))
          ]),
        ),
      ),
      onDismissed: (direction) => ShoppingListService.delete(shoppingItem.id!, context),
    );
  }

  void _onShoppingItemTap(BuildContext context) async {
    shoppingItem.isBought = true;

    StorageItem storageItem = StorageItem.fromShoppingItem(shoppingItem, context);
    if (shoppingItem.perishable) {
      var expiryDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050),
      );
      storageItem.expiryDate = expiryDate;
    }
    StorageService.create(storageItem, context);
    ShoppingListService.update(shoppingItem, context);
  }
}
