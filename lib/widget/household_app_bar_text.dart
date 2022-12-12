import 'package:flutter/material.dart';
import 'package:my_fridge/services/household_service.dart';

import '../model/household.dart';

class HouseholdAppBarText extends StatelessWidget {
  const HouseholdAppBarText();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Household>(
        future: HouseholdService.getSelectedHousehold(context),
        builder: (BuildContext context, AsyncSnapshot<Household> snapshot) {
          if (!snapshot.hasData) {
            return const Text("MyFridge");
          }
          return Text(snapshot.data!.name);
        });
  }
}
