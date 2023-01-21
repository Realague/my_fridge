import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/storage_item.dart';
import 'package:my_fridge/services/storage_service.dart';
import 'package:my_fridge/storage/storage_item_list_tile.dart';

class StorageItemExpansionList extends StatefulWidget {
  const StorageItemExpansionList({required this.items});

  final List<dynamic> items;

  @override
  State<StatefulWidget> createState() => _StorageItemExpansionListState();
}

class _StorageItemExpansionListState extends State<StorageItemExpansionList> {
  _StorageItemExpansionListState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: widget.items.map<Widget>((item) => _buildItemExpansionPanel(context, item)).toList(),
    );
  }

  Widget _buildItemExpansionPanel(BuildContext context, dynamic item) {
    if (item is List<StorageItem>) {
      return Dismissible(
        key: UniqueKey(),
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
        child: ExpansionTile(
            title: Text(item[0].name), children: item.map<Widget>((item) => _buildItemExpansionPanel(context, item)).toList()),
        onDismissed: (direction) {
          item.forEach((item) => StorageService.delete(item.id!, context));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.shopping_list_item_deleted_snack_bar_message(item.length)),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      );
    } else {
      return StorageItemListTile(item: item);
    }
  }
}
