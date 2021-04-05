import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/article.dart';

import 'database.dart';

class ArticleService {
  static final CollectionReference collectionInstance =
      FirebaseFirestore.instance.collection("articles");

  static create(Article article) {
    Map<String, Object> data = {
      "name": article.name,
      "unit": article.unit,
    };

    DatabaseService.create(null, data, collectionInstance);
  }

  static delete(String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }

  static Future<List<Article>> get(String? searchFilter) async {
    List<Article> articles = [];
    if (searchFilter == null || searchFilter == "") {
      return collectionInstance.get().then((querySnapshot) {
        querySnapshot.docs.forEach((article) {
          articles.add(Article(article.data()!["name"], article.data()!["unit"]));
        });
        return articles;
      });
    }
    return collectionInstance.where('name', isGreaterThanOrEqualTo: searchFilter).where('name', isLessThan: searchFilter).get().then((querySnapshot) {
      querySnapshot.docs.forEach((article) {
        articles.add(Article(article.data()!["name"], article.data()!["unit"]));
      });
      return articles;
    });
  }
}
