import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_fridge/forms/category_form.dart';
import 'package:my_fridge/model/category.dart';
import 'package:my_fridge/services/article_category_service.dart';

import 'dialog.dart';
import 'loader.dart';

class CategoryList extends StatefulWidget {
  CategoryList(this.query, this.itemsBuilder, this.editableCategory);

  final bool editableCategory;
  final Query Function(BuildContext context, Category category) query;
  final Widget Function(BuildContext context, QueryDocumentSnapshot document)
      itemsBuilder;

  @override
  State<StatefulWidget> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  _CategoryListState();

  late Future _future;
  late List<Category> categories;

  @override
  void initState() {
    _future = CategoryService.get();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loader();
        }

        // To prevent to reset the categories data
        categories = (snapshot.data as List<Category>);

        return SingleChildScrollView(
          child: ExpansionPanelList(
            children: categories
                .map<ExpansionPanel>(
                    (category) => _buildCategoryListItem(context, category))
                .toList(),
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

  ExpansionPanel _buildCategoryListItem(
      final BuildContext context, final Category category) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: category.isExpanded,
      headerBuilder: (final context, final isExpanded) {
        if (widget.editableCategory && category.category != " ") {
          return ListTile(
            title: Text(category.categoryForDisplay(context)),
            trailing: SizedBox(
              width: 200,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    tooltip: AppLocalizations.of(context)!.swipe_to_edit,
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (final BuildContext context) {
                          return DialogFullScreen(
                            title: AppLocalizations.of(context)!
                                .shopping_list_popup_title,
                            child: CategoryForm(category: category),
                          );
                        },
                      );
                    },
                  ),
                  //TODO popup to confirm delete and update of delete visual
                  IconButton(
                    icon: Icon(Icons.delete),
                    tooltip: AppLocalizations.of(context)!.swipe_to_delete,
                    onPressed: () {
                      _future = CategoryService.delete(category.id!);
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return ListTile(
          title: Text(category.categoryForDisplay(context)),
        );
      },
      body: StreamBuilder(
        stream: widget.query.call(context, category).snapshots(),
        builder: (final context, final snapshot) {
          if (!snapshot.hasData) {
            return Loader();
          }
          return ListView.builder(
            primary: false,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: (snapshot.data as QuerySnapshot).docs.length,
            itemBuilder: (context, index) => widget.itemsBuilder(
                context, (snapshot.data as QuerySnapshot).docs[index]),
          );
        },
      ),
    );
  }
}
