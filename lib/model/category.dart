import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class Category {
  Category({this.id, required this.category, this.isExpanded = false});

  String? id;

  String category;

  String categoryForDisplay(BuildContext context) => category == " " ? AppLocalizations.of(context)!.category_other : category;

  bool isExpanded;

  static Category fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Category(id: document.id, category: toBeginningOfSentenceCase(data['category']), isExpanded: false);
  }

  Map<String, Object> get asMap {
    return {
      'category': this.category.toLowerCase(),
    };
  }
}
