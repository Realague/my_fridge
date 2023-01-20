import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/household/household_add_form.dart';
import 'package:my_fridge/household/household_edit_form.dart';
import 'package:my_fridge/household/join_household.dart';
import 'package:my_fridge/main.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/model/user.dart';
import 'package:my_fridge/services/authentication_service.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/widget/loader.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  Menu({required this.user, Key? key}) : super(key: key);

  final MyFridgeUser user;

  @override
  Widget build(final BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[buildHeader(context), buildHouseholdAction(context)],
      ),
    );
  }

  Widget buildHeader(final BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(15))),
      child: Container(
        padding: EdgeInsets.only(top: 16 + MediaQuery.of(context).padding.top, bottom: 24, left: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.imageUrl),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Column(
                  children: [
                    Text(user.username, style: TextStyle(fontSize: 25, color: Colors.white)),
                    Text(user.email, style: TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: AppLocalizations.of(context)!.button_sign_out,
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthenticationWrapper()),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildHouseholdAction(final BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16 + MediaQuery.of(context).padding.top, bottom: 24, left: 16, right: 16),
      child: Column(
        children: [
          ElevatedButton.icon(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 30, horizontal: 27),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FormAddHousehold())),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(AppLocalizations.of(context)!.household_add),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 30, horizontal: 50),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JoinHousehold())),
            icon: const Icon(Icons.link, color: Colors.white),
            label: Text(AppLocalizations.of(context)!.household_join),
          ),
          const SizedBox(height: 12),
          buildHouseholdList(context)
        ],
      ),
    );
  }

  Widget buildHouseholdList(BuildContext context) {
    return StreamBuilder(
      stream: HouseholdService.getUserHouseholds(context).snapshots(),
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
            Household household = Household.fromDocument((snapshot.data as QuerySnapshot).docs[index]);
            bool isSelectedHousehold = household.id == user.selectedHouseholdId;
            return GestureDetector(
              onTap: () {
                user.selectedHouseholdId = household.id;
                UserService.update(user, context);
                Navigator.pop(context);
              },
              child: Card(
                color: isSelectedHousehold ? Theme.of(context).colorScheme.primary : Colors.amber,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(household.name, style: TextStyle(color: Colors.white)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(household.getMembersDisplay(context), style: TextStyle(color: Colors.white)),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.fact_check_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          const Text("0", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white, size: 15),
                        padding: const EdgeInsets.all(8),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FormEditHousehold(household))),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
