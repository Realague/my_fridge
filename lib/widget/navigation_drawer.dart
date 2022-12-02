import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/household.dart';
import 'package:my_fridge/services/household_service.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../services/authentication_service.dart';
import 'loader.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  List<Household>? _households;

  @override
  Widget build(final BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[buildHeader(context), buildHouseholdAction(context), buildHouseholdList(context)],
      ),
    );
  }

  Widget buildHeader(final BuildContext context) {
    return Material(
      color: Colors.blue.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(15))),
      child: Container(
        padding: EdgeInsets.only(top: 16 + MediaQuery.of(context).padding.top, bottom: 24, left: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              //backgroundImage: NetworkImage(context.read<AuthenticationService>().currentGoogleUser!.photoURL!),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Column(
                  children: [
                    Text(UserService.getCurrentUserFromCache(context)!.username, style: TextStyle(fontSize: 25, color: Colors.white)),
                    Text(UserService.getCurrentUserFromCache(context)!.email, style: TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
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
      padding: EdgeInsets.only(top: 16 + MediaQuery.of(context).padding.top, bottom: 24),
      child: Column(
        children: [
          ElevatedButton.icon(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
            ),
            onPressed: () => {},
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(AppLocalizations.of(context)!.household_add),
          ),
          SizedBox(height: 12),
          ElevatedButton.icon(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(vertical: 30, horizontal: 32),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
            ),
            onPressed: () => {},
            icon: Icon(Icons.link, color: Colors.white),
            label: Text(AppLocalizations.of(context)!.household_join),
          )
        ],
      ),
    );
  }

  Widget buildHouseholdList(BuildContext context) {
    return StreamBuilder(
        stream: HouseholdService.getUserHouseholds(context).snapshots(),
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
              return Text((snapshot.data as QuerySnapshot).docs[index]['name']);
            },
          );
        });
  }
}
