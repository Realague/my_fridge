import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/bottom_navigation_bar.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/model/storage.dart';
import 'package:my_fridge/model/user.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/utils/validators.dart';
import 'package:my_fridge/widget/loader.dart';
import 'package:share_plus/share_plus.dart';

class FormEditHousehold extends StatefulWidget {
  FormEditHousehold(this.household) : super();

  final Household household;

  @override
  State<StatefulWidget> createState() => _FormEditHouseholdState();
}

class _FormEditHouseholdState extends State<FormEditHousehold> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  List<Storage> _storagesController = <Storage>[];

  late Household household;

  @override
  void initState() {
    household = widget.household;
    _nameController.text = household.name;
    _storagesController = household.availableStoragesType.toStorageList;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.household_edit),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                icon: const Icon(Icons.label),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                labelText: AppLocalizations.of(context)!.household_name,
              ),
              validator: (name) => Validators.notEmpty(context, name),
              controller: _nameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownSearch<Storage>.multiSelection(
                compareFn: (Storage storage, Storage storage2) {
                  return storage.index == storage2.index;
                },
                popupProps: PopupPropsMultiSelection.modalBottomSheet(
                  showSelectedItems: true,
                  title: ListTile(title: Text(AppLocalizations.of(context)!.storage_item_storage_place)),
                ),
                clearButtonProps: ClearButtonProps(isVisible: true),
                items: Storage.values.storageListWithoutNone,
                itemAsString: (Storage storage) => storage.displayTitle(context),
                selectedItems: _storagesController,
                onChanged: (List<Storage> storages) {
                  setState(() {
                    household.availableStoragesType = storages.toIntList;
                    _storagesController = storages;
                  });
                }),
          ),
          buildMemberSection(context),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  household.name = _nameController.text;
                  HouseholdService.update(household, context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.household_save),
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              HouseholdService.delete(context, household.id!);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.household_delete),
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

  Widget buildMemberSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(AppLocalizations.of(context)!.household_description, style: TextStyle(color: Colors.black54)),
        ),
        Padding(padding: const EdgeInsets.all(16.0), child: Text(AppLocalizations.of(context)!.household_members_list)),
        buildMembersList(context),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
            onPressed: () {
              Share.share("Rejoins mon ménage sur MyFridge!\n" + household.id!);
            },
            child: Text(AppLocalizations.of(context)!.household_add_member),
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildMembersList(BuildContext context) {
    return StreamBuilder(
      stream: UserService.getHouseholdUsers(context, household.id!).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Loader();
        }

        return ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context, index) {
            MyFridgeUser user = MyFridgeUser.fromDocument((snapshot.data as QuerySnapshot).docs[index]);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(user.imageUrl),
                ),
                const SizedBox(width: 5),
                Text(user.username)
              ],
            );
          },
        );
      },
    );
  }
}
