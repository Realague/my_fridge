import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/bottom_navigation_bar.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/utils/validators.dart';

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
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  icon: const Icon(Icons.link),
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  labelText: AppLocalizations.of(context)!.household_join_link,
                ),
                validator: (final link) => Validators.notEmpty(context, link!),
                controller: _linkController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(AppLocalizations.of(context)!.household_join_description, style: TextStyle(color: Colors.black54)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    HouseholdService.joinHousehold(context, _linkController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CustomBottomNavigationBar()),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.household_join),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
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
