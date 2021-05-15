import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/article.dart';

import 'database.dart';

class ArticleService {
  static final CollectionReference collectionInstance =
      FirebaseFirestore.instance.collection('articles');

  static create(Article article) {
    DatabaseService.create(data: article.asMap, collection: collectionInstance);
  }

  static update(Article article) {
    DatabaseService.update(article.id!, article.asMap, collectionInstance);
  }

  static delete(String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }

  static Future<List<Article>> get(String? searchFilter) async {
    List<Article> articles = [];
    if (searchFilter == null || searchFilter == '') {
      return collectionInstance.get().then((querySnapshot) {
        querySnapshot.docs.forEach(
            (document) => articles.add(Article.fromDocument(document)));
        return articles;
      });
    }
    return collectionInstance
        .where('name', isGreaterThanOrEqualTo: searchFilter)
        .where('name', isLessThan: searchFilter)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs
          .forEach((document) => articles.add(Article.fromDocument(document)));
      return articles;
    });
  }
}
