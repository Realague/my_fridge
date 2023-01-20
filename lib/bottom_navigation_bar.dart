import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/article_management/article_management.dart';
import 'package:my_fridge/cooking_recipe/cooking_recipe_list.dart';
import 'package:my_fridge/cooking_recipe/cooking_recipe_view.dart';
import 'package:my_fridge/custom_icons_icons.dart';
import 'package:my_fridge/forms/article_form.dart';
import 'package:my_fridge/forms/category_form.dart';
import 'package:my_fridge/forms/fridge_article_form.dart';
import 'package:my_fridge/meal_schedule/meal_schedule_view.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/services/storage_service.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:my_fridge/shopping_list/shopping_list.dart';
import 'package:my_fridge/storage/storage.dart';
import 'package:my_fridge/shopping_list/add_shopping_item.dart';
import 'package:my_fridge/widget/dialog.dart';
import 'package:my_fridge/widget/expandable_fab.dart';
import 'package:my_fridge/widget/household_app_bar.dart';
import 'package:my_fridge/widget/menu.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar();

  @override
  _BottomNavigationBarState createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = [
    ShoppingList(),
    Storage(),
    CookingRecipeList(),
    ArticleManagement(),
    MealScheduleView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

  void _addCookingRecipe(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogFullScreen(
          title: AppLocalizations.of(context)!.add_article_popup_title,
          child: CookingRecipeView(insertMode: true),
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
    if (_selectedIndex == 1) {
      return FloatingActionButton(onPressed: () => _addFridgeArticle(context), child: const Icon(Icons.article));
    } else if (_selectedIndex == 2) {
      return FloatingActionButton(
        onPressed: () => _addCookingRecipe(context),
        child: Icon(Icons.add),
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

  FocusNode _searchBarFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchBarFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _searchBarFocus.removeListener(_onFocusChange);
    _searchBarFocus.dispose();
  }

  void _onFocusChange() {
    if (_searchBarFocus.hasFocus) {
      FocusScope.of(context).unfocus();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddShoppingItem()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(user: UserService.getCurrentUser(context)),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            centerTitle: false,
            title: const HouseholdAppBar(),
            actions: [],
            bottom: AppBar(
              automaticallyImplyLeading: false,
              title: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: TextField(
                  focusNode: _searchBarFocus,
                  decoration:
                      InputDecoration(hintText: AppLocalizations.of(context)!.shopping_list_search_hint, prefixIcon: Icon(Icons.search)),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([_widgetOptions[_selectedIndex]]),
          )
        ],
      ),
      //body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CustomIcons.shopping_list),
            label: AppLocalizations.of(context)!.menu_shopping_list,
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CustomIcons.fridge),
            label: AppLocalizations.of(context)!.menu_storage,
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CustomIcons.recipe_book),
            label: AppLocalizations.of(context)!.menu_recipes,
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CustomIcons.recipe_book),
            label: 'Coming soon',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.schedule),
            label: 'Coming soon',
            backgroundColor: Colors.white,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.black87,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }
}
