import 'package:flutter/material.dart';
import 'package:my_fridge/custom_icons_icons.dart';
import 'package:my_fridge/shopping_list/shopping_list.dart';
import 'package:my_fridge/signout_button.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super (key: key);

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [
    ShoppingList(),
    Center(child: Text("Coming soon"))
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.shopping_list),
            label: 'Shopping list',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.fridge),
            label: 'Fridge',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(CustomIcons.recipe_book),
            label: 'Recipes',
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
    );
  }
}
