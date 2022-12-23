import 'package:flutter/material.dart';
import 'package:my_fridge/storage/storage_item_list_tile.dart';

import '../model/storage_item.dart';

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
      return ExpansionTile(
          title: Text(item[0].name), children: item.map<Widget>((item) => _buildItemExpansionPanel(context, item)).toList());
    } else {
      return StorageItemListTile(item: item);
    }
  }
}
