import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:my_fridge/model/storage_item.dart';
import 'package:my_fridge/model/user.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/services/storage_service.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/widget/loader.dart';

class StorageItemDetails extends StatefulWidget {
  const StorageItemDetails({required this.item});

  final StorageItem item;

  @override
  State<StatefulWidget> createState() => _StorageItemDetailsState();
}

class _StorageItemDetailsState extends State<StorageItemDetails> {
  _StorageItemDetailsState();

  TextEditingController expiryDateInput = TextEditingController();

  late StorageItem item;

  @override
  void initState() {
    this.item = widget.item;
    expiryDateInput.text = item.expiryDateDisplay;
    super.initState();
  }

  @override
  void dispose() {
    expiryDateInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(item.name),
        leading: BackButton(onPressed: () {
          StorageService.update(item, context);
          Navigator.of(context).pop();
        }),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.white,
            child: DropdownSearch<Storage>(
                compareFn: (Storage storage, Storage storage2) {
                  return storage.index == storage2.index;
                },
                popupProps: PopupProps.modalBottomSheet(
                  showSelectedItems: true,
                  title: ListTile(title: Text(AppLocalizations.of(context)!.storage_item_storage_place)),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(labelText: AppLocalizations.of(context)!.storage_item_storage_place),
                ),
                items: HouseholdService.getSelectedHousehold(context).availableStoragesType.toStorageList,
                itemAsString: (Storage storage) => storage.displayTitle(context),
                selectedItem: item.storagePlace,
                onChanged: (Storage? storage) {
                  setState(() {
                    item.storage = storage!.index;
                  });
                }),
          ),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.white,
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                labelText: AppLocalizations.of(context)!.storage_item_details_note,
              ),
              initialValue: item.note,
              onChanged: (note) {
                setState(() {
                  item.note = note;
                });
              },
            ),
          ),
          _buildQuantity(context),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.white,
            child: TextFormField(
              controller: expiryDateInput,
              decoration:
                  InputDecoration(icon: Icon(Icons.calendar_today), labelText: AppLocalizations.of(context)!.form_expiry_date_label),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101));
                if (pickedDate != null) {
                  setState(() {
                    item.expiryDate = pickedDate;
                    expiryDateInput.text = item.expiryDateDisplay;
                  });
                }
              },
            ),
          ),
          SizedBox(height: 6),
          _buildLifeCycle(context, item),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              StorageService.delete(item.id!, context);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.storage_item_delete),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildLifeCycle(BuildContext context, StorageItem item) {
    return FutureBuilder(
        future: UserService.getUserById(context, item.boughtBy),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loader();
          }

          MyFridgeUser user = snapshot.data!;
          return Column(children: [
            Container(
              color: Colors.white,
              child: TextFormField(
                keyboardType: TextInputType.text,
                initialValue: item.boughtAtDisplay,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  labelText: AppLocalizations.of(context)!.storage_item_bought_at,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: TextFormField(
                keyboardType: TextInputType.text,
                initialValue: user.username,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  labelText: AppLocalizations.of(context)!.storage_item_bought_by,
                ),
              ),
            )
          ]);
        });
  }

  Widget _buildQuantity(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.white,
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                labelText: AppLocalizations.of(context)!.form_quantity_label,
              ),
              initialValue: item.quantity.toString(),
              onChanged: (quantity) {
                setState(() {
                  item.quantity = int.parse(quantity);
                });
              },
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.white,
            child: DropdownSearch<PackingType>(
                compareFn: (PackingType packingType, PackingType packingType2) {
                  return packingType.index == packingType2.index;
                },
                popupProps: PopupProps.modalBottomSheet(
                  showSelectedItems: true,
                  title: ListTile(title: Text(AppLocalizations.of(context)!.form_packing_type_label)),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(labelText: AppLocalizations.of(context)!.form_packing_type_label),
                ),
                items: PackingType.values,
                itemAsString: (PackingType packingType) => packingType.displayText(context),
                selectedItem: item.packingType,
                onChanged: (PackingType? packingType) {
                  setState(() {
                    item.packingType = packingType!;
                  });
                }),
          ),
        )
      ],
    );
  }
}
