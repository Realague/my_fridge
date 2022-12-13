import 'package:flutter/material.dart';
import 'package:my_fridge/household/household_edit_form.dart';
import 'package:my_fridge/services/household_service.dart';

import '../model/household.dart';

class HouseholdAppBar extends StatelessWidget {
  const HouseholdAppBar();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Household>(
        future: HouseholdService.getSelectedHousehold(context),
        builder: (BuildContext context, AsyncSnapshot<Household> snapshot) {
          if (!snapshot.hasData) {
            return const Text("MyFridge");
          }
          Household household = snapshot.data!;
          return InkWell(
            child: Text(household.name),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FormEditHousehold(household))),
          );
        });
  }
}
