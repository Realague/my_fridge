import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/forms/shopping_list_form_from_existing_article.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/shopping_article.dart';
import 'package:my_fridge/services/category_service.dart';
import 'package:my_fridge/services/shopping_list_service.dart';
import 'package:my_fridge/widget/dialog.dart';
import 'package:my_fridge/widget/dismissible.dart';
import 'package:my_fridge/widget/shopping_list_item.dart';

import '../widget/loader.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList() : super();

  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  late List<Category> categories;

  Widget _buildShoppingListItem(BuildContext context, DocumentSnapshot document) {
    ShoppingArticle article = ShoppingArticle.fromDocument(document);
    return DismissibleBothWay(
      key: Key(article.id!),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: ShoppingListItem(article: article),
        onChanged: (value) {
          if (value != null) {
            article.checked = value;
            ShoppingListService.update(article.id!, article, context);
          }
        },
        value: article.checked,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogFullScreen(
                title: AppLocalizations.of(context)!.shopping_list_popup_title,
                child: FormShoppingListFromExistingArticle(article: article, id: article.id),
              );
            },
          );
        } else {
          ShoppingListService.delete(article.id!, context);
        }
      },
    );
  }

  ExpansionPanel _buildCategoryListItem(BuildContext context, Category category) {
    return ExpansionPanel(
      isExpanded: category.isExpanded,
      headerBuilder: (context, isExpanded) {
        if (category.category == " ") {
          return ListTile(title: Text(AppLocalizations.of(context)!.category_other));
        }
        return ListTile(title: Text(category.category));
      },
      body: StreamBuilder(
          stream: ShoppingListService.getCollectionInstance(context).orderBy('checked').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loader();
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (snapshot.data as QuerySnapshot).docs.length,
              itemBuilder: (context, index) => _buildShoppingListItem(context, (snapshot.data as QuerySnapshot).docs[index]),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CategoryService.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loader();
        }
        categories = (snapshot.data as List<Category>);
        return SingleChildScrollView(
          //scrollDirection: Axis.vertical,
          child: ExpansionPanelList(
            children: categories.map<ExpansionPanel>((category) => _buildCategoryListItem(context, category)).toList(),
            expansionCallback: (index, isExpanded) {
              setState(() {
                categories[index].isExpanded = !isExpanded;
              });
            },
          ),
        );
      },
    );
  }
}
