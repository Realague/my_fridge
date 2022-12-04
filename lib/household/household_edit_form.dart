import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/services/user_service.dart';

import '../bottom_navigation_bar.dart';
import '../model/user.dart';
import '../utils/validators.dart';
import '../widget/loader.dart';

class FormEditHousehold extends StatefulWidget {
  FormEditHousehold(this.household) : super();

  Household household;

  @override
  State<StatefulWidget> createState() => _FormEditHouseholdState();
}

class _FormEditHouseholdState extends State<FormEditHousehold> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  late Household household;

  @override
  void initState() {
    household = widget.household;
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
        title: Text(AppLocalizations.of(context)!.household_edit),
      ),
      body: Form(
        key: _formKey,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                icon: Icon(Icons.label),
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
            child: Text(AppLocalizations.of(context)!.household_description, style: TextStyle(color: Colors.black54)),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  HouseholdService.update(household, context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.household_save),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                HouseholdService.delete(household.id!);
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.household_delete),
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

  Widget buildMembersList(BuildContext context) {
    return StreamBuilder(
      stream: UserService.getHouseholdUsers(context, household.id!).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loader();
        }

        return ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context, index) {
            MyFridgeUser user = MyFridgeUser.fromDocument((snapshot.data as QuerySnapshot).docs[index]);
            return;
          },
        );
      },
    );
  }
}
