import 'package:flutter/material.dart';
import 'package:my_fridge/household/household_edit_form.dart';
import 'package:my_fridge/services/household_service.dart';

class HouseholdAppBar extends StatelessWidget {
  const HouseholdAppBar();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(HouseholdService.getSelectedHousehold(context).name),
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => FormEditHousehold(HouseholdService.getSelectedHousehold(context)))),
    );
  }
}
