import 'package:flutter/material.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingListItemBought extends StatelessWidget {
  ShoppingListItemBought({required this.shoppingItem}) : super();

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
        title: InkWell(
            onTap: () {
              shoppingItem.isBought = !shoppingItem.isBought;
              ShoppingListService.update(shoppingItem, context);
            },
            child: ListTile(
              title: Row(children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    shoppingItem.name,
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
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
        ),
      onDismissed: (direction) => ShoppingListService.delete(shoppingItem.id!, context),
    );
  }
}
