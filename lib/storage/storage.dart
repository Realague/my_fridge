import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/storage_item.dart';
import 'package:my_fridge/services/storage_service.dart';
import 'package:my_fridge/storage/storage_list.dart';
import 'package:my_fridge/utils/utils.dart';
import 'package:my_fridge/widget/dialog.dart';
import 'package:my_fridge/widget/dismissible.dart';

import '../forms/fridge_article_form.dart';
import 'storage_item_list_tile.dart';

class Storage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const StorageList();
  }

  Widget _buildStorageItem(BuildContext context, DocumentSnapshot document) {
    StorageItem item = StorageItem.fromDocument(document);
    return DismissibleBothWay(
      key: Key(item.id!),
      child: StorageItemListTile(item: item),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogFullScreen(
                title: AppLocalizations.of(context)!.shopping_list_popup_title,
                child: FormFridgeArticle(article: item, id: item.id),
              );
            },
          );
        } else {
          await Utils.showConfirmDialog(
              context, AppLocalizations.of(context)!.confirm_delete_fridge_article, StorageService.delete, item.id!);
        }
        return true;
      },
    );
  }
}
