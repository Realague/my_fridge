import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:my_fridge/model/user.dart';
import 'package:my_fridge/services/article_category_service.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/services/storage_service.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/utils/validators.dart';
import 'package:my_fridge/widget/loader.dart';

class ShoppingItemDetails extends StatefulWidget {
  const ShoppingItemDetails({required this.item});

  final ShoppingItem item;

  @override
  State<StatefulWidget> createState() => _ShoppingItemDetailsState();
}

class _ShoppingItemDetailsState extends State<ShoppingItemDetails> {
  _ShoppingItemDetailsState();

  TextEditingController expiryDateInput = TextEditingController();

  TextEditingController createdByController = TextEditingController();

  late ShoppingItem item;

  late Category _category;

  @override
  void initState() {
    this.item = widget.item;

    _category = Category(category: item.category);
    super.initState();
  }

  @override
  void dispose() {
    expiryDateInput.dispose();
    createdByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(item.name),
        leading: BackButton(onPressed: () {
          ShoppingListService.update(item, context);
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
                  title: ListTile(title: Text(AppLocalizations.of(context)!.shopping_item_storage)),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(labelText: AppLocalizations.of(context)!.shopping_item_storage),
                ),
                items: HouseholdService
                    .getSelectedHousehold(context)
                    .availableStoragesType
                    .toStorageList,
                itemAsString: (Storage storage) => storage.displayTitle(context),
                selectedItem: item.defaultStoragePlace,
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
          FutureBuilder(
              future: CategoryService.get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loader();
                }
                return Container(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.white,
                  child: DropdownSearch<Category>(
                      compareFn: (Category category, Category category2) {
                        return category.category == category2.category;
                      },
                      popupProps: PopupProps.modalBottomSheet(
                        showSelectedItems: true,
                        title: ListTile(title: Text(AppLocalizations.of(context)!.shopping_item_category)),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(labelText: AppLocalizations.of(context)!.shopping_item_category),
                      ),
                      items: snapshot.data as List<Category>,
                      itemAsString: (Category? category) {
                        if (category != null && category.category == " ") {
                          return AppLocalizations.of(context)!.category_other;
                        }
                        return category!.category;
                      },
                      selectedItem: _category,
                      validator: (category) => Validators.notNull(context, category),
                      onChanged: (Category? category) => _category = category!),
                );
              }),
          SizedBox(height: 6),
          _buildLifeCycle(context, item),
          SizedBox(height: 10),
          FilledButton(
            onPressed: () {
              StorageService.delete(item.id!, context);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.shopping_item_delete),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
              shape: WidgetStateProperty.all(
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

  Widget _buildLifeCycle(BuildContext context, ShoppingItem item) {
    return FutureBuilder(
        future: UserService.getUserById(context, item.createdBy),
        builder: (context, snapshot) {
          MyFridgeUser? user = snapshot.data;
          createdByController.text = "test";
          if (user == null && item.createdBy == "automatic") {
            createdByController.text = "automatic";
          } else if (user != null) {
            createdByController.text = user.username;
          }

          return Column(children: [
            Container(
              color: Colors.white,
              child: TextFormField(
                keyboardType: TextInputType.text,
                initialValue: item.createdAtDisplay,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  labelText: AppLocalizations.of(context)!.shopping_item_created_at,
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: TextFormField(
                keyboardType: TextInputType.text,
                controller: createdByController,
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  labelText: AppLocalizations.of(context)!.shopping_item_created_by,
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
