import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/services/household_service.dart';

import '../bottom_navigation_bar.dart';
import '../utils/validators.dart';

class FormAddHousehold extends StatefulWidget {
  const FormAddHousehold() : super();

  @override
  State<StatefulWidget> createState() => _FormAddHouseholdState();
}

class _FormAddHouseholdState extends State<FormAddHousehold> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    _nameController.text = "Accueil";
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
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                labelText: AppLocalizations.of(context)!.household_name,
              ),
              validator: (final name) => Validators.notEmpty(context, name),
              controller: _nameController,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(AppLocalizations.of(context)!.household_description,
                style: TextStyle(color: Colors.black54)),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Household household = Household(
                      name: _nameController.value.text,
                      members: [],
                      availableStorage: []);
                  HouseholdService.create(household, context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomBottomNavigationBar()),
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
