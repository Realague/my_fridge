import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/article_management/article_management.dart';
import 'package:my_fridge/cooking_recipe/cooking_recipe_list.dart';
import 'package:my_fridge/cooking_recipe/cooking_recipe_view.dart';
import 'package:my_fridge/custom_icons_icons.dart';
import 'package:my_fridge/forms/article_form.dart';
import 'package:my_fridge/forms/category_form.dart';
import 'package:my_fridge/forms/fridge_article_form.dart';
import 'package:my_fridge/forms/select_article_form.dart';
import 'package:my_fridge/meal_schedule/meal_schedule_view.dart';
import 'package:my_fridge/model/services/shopping_list_service.dart';
import 'package:my_fridge/model/services/storage_service.dart';
import 'package:my_fridge/model/services/user_service.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/shopping_list/shopping_list.dart';
import 'package:my_fridge/storage/storage.dart';
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

  void _addShoppingListArticle(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogFullScreen(
          title: AppLocalizations.of(context)!.shopping_list_popup_title,
          child: SelectArticleForm(confirmCallback: (article, quantity) {
            ShoppingListService.create(ShoppingArticle.fromArticle(article, quantity), context);
            Navigator.pop(context);
          }),
        );
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

  void _addCheckedShoppingArticles(BuildContext context) async {
    var articles = ShoppingListService.getOnlyCheckedArticle(context);
    articles.then(
      (articles) => {
        articles.forEach(
          (article) async {
            if (article.perishable) {
              DateTime? expiryDate = article.expiryDate;
              //TODO if cancel set to null
              if (expiryDate == null) {
                expiryDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
              }
              StorageService.createFromShoppingArticle(article, context, expiryDate: expiryDate);
              ShoppingListService.delete(article.id!, context);
            } else {
              StorageService.createFromShoppingArticle(article, context);
              ShoppingListService.delete(article.id!, context);
            }
          },
        ),
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(articles.length.toString() + " " + AppLocalizations.of(context)!.snack_message_added_to_fridge),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
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
            onPressed: () => _addCheckedShoppingArticles(context),
            icon: const Icon(Icons.add),
          ),
        ],
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const HouseholdAppBar(),
      ),
      drawer: Menu(user: UserService.getCurrentUser(context)),
      body: _widgetOptions.elementAt(_selectedIndex),
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
