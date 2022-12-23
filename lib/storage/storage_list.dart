import 'package:flutter/material.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/storage/storage_item_expansion_list.dart';

import '../model/expansion_data.dart';
import '../model/storage.dart';
import '../services/storage_service.dart';
import '../widget/loader.dart';

class StorageList extends StatefulWidget {
  const StorageList();

  @override
  State<StatefulWidget> createState() => _StorageListState();
}

class _StorageListState extends State<StorageList> {
  _StorageListState();

  List<ExpansionData> listData = [];

  @override
  void initState() {
    HouseholdService.getSelectedHousehold(context)
        .availableStoragesType
        .forEach((storageIndex) => listData.add(ExpansionData(data: Storage.values[storageIndex])));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        children: listData.map<ExpansionPanel>((expansionData) => _buildCategoryListItem(context, expansionData)).toList(),
        expansionCallback: (index, isExpanded) {
          setState(
            () {
              listData[index].isExpanded = !isExpanded;
            },
          );
        },
      ),
    );
  }

  ExpansionPanel _buildCategoryListItem(BuildContext context, ExpansionData expansionData) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: expansionData.isExpanded,
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: Text((expansionData.data as Storage).displayTitle(context)),
        );
      },
      body: FutureBuilder<List<dynamic>>(
          future: StorageService.getUniqueItemByStorage(context, expansionData.data),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loader();
            }
            return StorageItemExpansionList(items: snapshot.data!);
          }),
    );
  }
}
