import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/article.dart';

import 'database.dart';

class ArticleService {
  static final CollectionReference collectionInstance = FirebaseFirestore.instance.collection('articles');

  static create(Article article) {
    Map<String, Object> data = {'name': article.name, 'unit': article.unit, 'perishable': article.perishable, 'category': article.category};

    DatabaseService.create(data: data, collection: collectionInstance);
  }

  static update(String id, Article article) {
    Map<String, Object> data = {'name': article.name, 'unit': article.unit, 'perishable': article.perishable, 'category': article.category};

    DatabaseService.update(id, data, collectionInstance);
  }

  static delete(String userId) {
    DatabaseService.delete(userId, collectionInstance);
  }

  static Future<List<Article>> get(String? searchFilter) async {
    List<Article> articles = [];
    if (searchFilter == null || searchFilter == '') {
      return collectionInstance.get().then((querySnapshot) {
        querySnapshot.docs.forEach((article) {
          articles.add(Article(
              name: article.data()['name'], unit: article.data()['unit'], perishable: article.data()['perishable'], category: article.data()['category']));
        });
        return articles;
      });
    }
    return collectionInstance.where('name', isGreaterThanOrEqualTo: searchFilter).where('name', isLessThan: searchFilter).get().then((querySnapshot) {
      querySnapshot.docs.forEach((article) {
        articles.add(Article(
            name: article.data()['name'], unit: article.data()['unit'], perishable: article.data()['perishable'], category: article.data()['category']));
      });
      return articles;
    });
  }
}
