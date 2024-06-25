import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/item.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:my_fridge/services/article_category_service.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/services/item_service.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/utils/validators.dart';
import 'package:my_fridge/widget/loader.dart';

class ShoppingItemAddItem extends StatefulWidget {
  const ShoppingItemAddItem({required this.itemName});

  final String itemName;

  @override
  State<StatefulWidget> createState() => _ShoppingItemAddItemState();
}

class _ShoppingItemAddItemState extends State<ShoppingItemAddItem> {
  _ShoppingItemAddItemState();

  TextEditingController expiryDateInput = TextEditingController();

  late Category _category;

  late ShoppingItem item;

  @override
  void initState() {
    _category = Category(category: " ");
    this.item = ShoppingItem(
        name: widget.itemName,
        unit: PackingType.NONE.index,
        quantity: 0,
        perishable: false,
        createdAt: DateTime.now(),
        createdBy: UserService.currentUserId(context),
        storage: Storage.CELLAR.index);
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
                items: HouseholdService.getSelectedHousehold(context).availableStoragesType.toStorageList,
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
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.white,
            child: SwitchListTile(
              title: Text(AppLocalizations.of(context)!.perishable_label),
              value: item.perishable,
              subtitle: Text(AppLocalizations.of(context)!.perishable_description),
              onChanged: (bool value) {
                setState(() {
                  item.perishable = value;
                });
              },
              secondary: const Icon(Icons.fastfood_outlined),
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
          SizedBox(height: 10),
          FilledButton(
            onPressed: () {
              item.category = _category.category;
              item.createdAt = DateTime.now();
              ItemService.create(Item.fromShoppingItem(item, context));
              ShoppingListService.create(item, context);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.add_article_popup_title),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.primary),
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
