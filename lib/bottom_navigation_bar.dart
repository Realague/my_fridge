import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/custom_icons_icons.dart';
import 'package:my_fridge/forms/article_form.dart';
import 'package:my_fridge/fridge/fridge.dart';
import 'package:my_fridge/shopping_list/shopping_list.dart';
import 'package:my_fridge/widget/dialog.dart';
import 'package:my_fridge/widget/expandable_fab.dart';
import 'package:my_fridge/widget/signout_button.dart';

import 'article_management/article_management.dart';
import 'forms/category_form.dart';
import 'forms/fridge_article_form.dart';
import 'forms/shopping_list_form.dart';
import 'forms/shopping_list_form_from_existing_article.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [ShoppingList(), Fridge(), Center(child: Text("Coming soon")), ArticleManagement()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addShoppingListArticle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogFullScreen(
            title: AppLocalizations.of(context)!.shopping_list_popup_title,
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

  void _addFridgeArticle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogFullScreen(
          title: AppLocalizations.of(context)!.fridge_popup_title,
          child: FormFridgeArticle(),
        );
      },
    );
  }

  void _addArticle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogFullScreen(
          title: AppLocalizations.of(context)!.add_article_popup_title,
          child: FormArticle(),
        );
      },
    );
  }

  void _addCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogFullScreen(
          title: AppLocalizations.of(context)!.add_category_popup_title,
          child: CategoryForm(),
        );
      },
    );
  }

  Widget? _floatingActionButton() {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        onPressed: () => _addShoppingListArticle(context),
        child: Icon(Icons.add),
      );
    } else if (_selectedIndex == 1) {
      return ExpandableFab(
        distance: 70.0,
        children: [
          ActionButton(
            onPressed: () => _addFridgeArticle(context),
            icon: const Icon(Icons.article),
          ),
          ActionButton(
            onPressed: () => _addCategory(context),
            icon: const Icon(Icons.category),
          ),
        ],
      );
    } else if (_selectedIndex == 3) {
      return ExpandableFab(
        distance: 70.0,
        children: [
          ActionButton(
            onPressed: () => _addArticle(context),
            icon: const Icon(Icons.article),
          ),
          ActionButton(
            onPressed: () => _addCategory(context),
            icon: const Icon(Icons.category),
          ),
        ],
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
