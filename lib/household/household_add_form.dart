import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/bottom_navigation_bar.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/utils/validators.dart';

class FormAddHousehold extends StatefulWidget {
  const FormAddHousehold() : super();

  @override
  State<StatefulWidget> createState() => _FormAddHouseholdState();
}

class _FormAddHouseholdState extends State<FormAddHousehold> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _expiredItemWarningDelayController = TextEditingController();

  bool hasFridge = false;
  bool hasFreezer = false;
  bool hasCellar = false;

  @override
  void initState() {
    _nameController.text = "Accueil";
    _expiredItemWarningDelayController.text = "3";
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
        title: Text(AppLocalizations.of(context)!.household_create),
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
            child: Text(AppLocalizations.of(context)!.household_description, style: TextStyle(color: Colors.black54)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              Switch(
                onChanged: (value) {
                  setState(() {
                    hasFridge = value;
                  });
                },
                value: hasFridge,
              ),
              Text(AppLocalizations.of(context)!.storage_description_fridge)
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(children: [
              Switch(
                onChanged: (value) {
                  setState(() {
                    hasFreezer = value;
                  });
                },
                value: hasFreezer,
              ),
              Text(AppLocalizations.of(context)!.storage_description_freezer)
            ]),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(children: [
              Switch(
                onChanged: (value) {
                  setState(() {
                    hasCellar = value;
                  });
                },
                value: hasCellar,
              ),
              Text(AppLocalizations.of(context)!.storage_description_cellar)
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: const Icon(Icons.label),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                labelText: AppLocalizations.of(context)!.storage_expired_item_warning_delay_label,
              ),
              validator: (final value) => Validators.number(context, value),
              controller: _expiredItemWarningDelayController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Text(AppLocalizations.of(context)!.storage_expired_item_warning_delay_description, style: TextStyle(color: Colors.black54)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Household household = Household(
                      name: _nameController.text,
                      membersId: [],
                      availableStoragesType: [],
                      expiredItemWarningDelay: int.parse(_expiredItemWarningDelayController.text));
                  household.setAvailableStoragesType(hasFridge, hasFreezer, hasCellar);
                  HouseholdService.create(household, context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.household_create),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void _addHousehold() {}
}
