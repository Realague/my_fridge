import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_fridge/custom_icons_icons.dart';
import 'package:my_fridge/shopping_list/shopping_list.dart';
import 'package:my_fridge/signout_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/widget/dialog.dart';

import 'forms/shopping_list_form.dart';
import 'forms/shopping_list_form_from_existing_article.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [ShoppingList(), Center(child: Text("Coming soon"))];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addArticle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogFullScreen(
            title: "",
            child: Column(
              children: [
                FormShoppingListFromExistingArticle(),
                const Divider(
                  color: Colors.grey,
                  height: 50,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                FormShoppingList(),
              ],
            ));
      },
    );
  }

  Widget? _floatingActionButton() {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        onPressed: () => _addArticle(context),
        child: Icon(Icons.add),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyFridge'),
        actions: <Widget>[
          SignOutButton(),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.shopping_list),
            label: AppLocalizations.of(context)!.menu_shopping_list,
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.fridge),
            label: AppLocalizations.of(context)!.menu_fridge,
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.recipe_book),
            label: AppLocalizations.of(context)!.menu_recipes,
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.recipe_book),
            label: 'Coming soon',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }
}
