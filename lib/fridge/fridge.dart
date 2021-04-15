import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/model/fridge_article.dart';
import 'package:my_fridge/services/category_service.dart';
import 'package:my_fridge/services/fridge_service.dart';
import 'package:my_fridge/widget/dialog.dart';
import 'package:my_fridge/widget/dismissible.dart';

import '../widget/loader.dart';
import 'fridge_article_list_tile.dart';

class Fridge extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FridgeState();
}

class _FridgeState extends State<Fridge> {
  late List<Category> categories;

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
          child: ExpansionPanelList(
            children: categories.map<ExpansionPanel>((category) => _buildCategoryListItem(context, category)).toList(),
            expansionCallback: (index, isExpanded) {
              setState(
                () {
                  categories[index].isExpanded = !isExpanded;
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
      isExpanded: category.isExpanded,
      headerBuilder: (context, isExpanded) {
        return ListTile(title: Text(category.category));
      },
      body: StreamBuilder(
        stream: FridgeService.getCollectionInstance(context).orderBy('expiry_date').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loader();
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder: (context, index) => _buildFridgeItem(context, (snapshot.data as QuerySnapshot).docs[index]),
          );
        },
      ),
    );
  }

  Widget _buildFridgeItem(BuildContext context, DocumentSnapshot document) {
    FridgeArticle article = FridgeArticle.fromDocument(document);
    return DismissibleBothWay(
      key: Key(article.id!),
      child: FridgeArticleListTile(article: article),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return DialogFullScreen(
                title: AppLocalizations.of(context)!.shopping_list_popup_title,
                child: Column(
                  children: [
                    //FormShoppingListFromExistingArticle(article: article, id: article.id),
                  ],
                ),
              );
            },
          );
        } else {
          FridgeService.delete(article.id!, context);
        }
      },
    );
  }
}
