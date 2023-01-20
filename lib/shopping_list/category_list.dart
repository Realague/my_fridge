import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/shopping_item.dart';
import 'package:my_fridge/model/storage_item.dart';
import 'package:my_fridge/services/article_category_service.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/services/storage_service.dart';
import 'package:my_fridge/shopping_list/shopping_item_details.dart';
import 'package:my_fridge/shopping_list/shopping_list_item.dart';
import 'package:my_fridge/widget/loader.dart';

class CategoryList extends StatefulWidget {
  const CategoryList();

  @override
  State<StatefulWidget> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  _CategoryListState();

  List<Category> _categories = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CategoryService.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loader();
        }

        // To prevent to reset the categories data
        if (_categories.isEmpty) {
          _categories = (snapshot.data as List<Category>);
        } else {
          List<Category> tmpCategories = [];
          for (int i = 0; i != (snapshot.data as List<Category>).length; i++) {
            tmpCategories.add(Category(category: (snapshot.data as List<Category>)[i].category, isExpanded: _categories[i].isExpanded));
          }
          _categories = tmpCategories;
        }

        return SingleChildScrollView(
          child: ExpansionPanelList(
            children: _categories.map<ExpansionPanel>((category) => _buildCategoryListItem(context, category)).toList(),
            expansionCallback: (index, isExpanded) {
              setState(
                    () {
                  _categories[index].isExpanded = !isExpanded;
                },
              );
            },
          ),
        );
      },
    );
  }

  ExpansionPanel _buildCategoryListItem(BuildContext context, Category category) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: category.isExpanded,
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: Text(category.categoryForDisplay(context)),
        );
      },
      body: StreamBuilder(
        stream: ShoppingListService.getByCategory(context, category).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loader();
          }
          return ListView.builder(
            primary: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder: (context, index) =>
                ShoppingListItem(shoppingItem: ShoppingItem.fromDocument((snapshot.data as QuerySnapshot).docs[index])),
          );
        },
      ),
    );
  }

}