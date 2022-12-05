import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/household_service.dart';
import '../utils/validators.dart';

class JoinHousehold extends StatefulWidget {
  const JoinHousehold() : super();

  @override
  State<StatefulWidget> createState() => _JoinHouseholdState();
}

class _JoinHouseholdState extends State<JoinHousehold> {
  final _formKey = GlobalKey<FormState>();
  final _linkController = TextEditingController();

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.household_join),
        ),
        body: Form(
          key: _formKey,
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  icon: Icon(Icons.link),
                  border: const OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  labelText: AppLocalizations.of(context)!.household_join_link,
                ),
                validator: (final link) => Validators.notEmpty(context, link!),
                controller: _linkController,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context)!.household_join_description, style: TextStyle(color: Colors.black54)),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    HouseholdService.joinHousehold(context, _linkController.value.text);
                    Navigator.pop(context);
                  }
                },
                child: Text(AppLocalizations.of(context)!.household_join),
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
        ));
  }
}
