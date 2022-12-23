import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_fridge/model/week_day.dart';
import 'package:my_fridge/services/database.dart';
import 'package:my_fridge/services/user_service.dart';
import 'package:provider/provider.dart';

import '../model/meal_schedule.dart';

class MealScheduleService {
  static init(BuildContext context) {
    for (var value in WeekDay.values) {
      DatabaseService.createWithId(value.display(context), {'day': value.index}, getCollectionInstance(context));
    }
  }

  static CollectionReference getCollectionInstance(BuildContext context) {
    return context.read<UserService>().currentUserDocument(context).collection("meal_schedule");
  }

  static update(MealSchedule mealSchedule, BuildContext context) {
    var data = mealSchedule.asMap;

    DatabaseService.update(mealSchedule.dayValue.display(context), data, getCollectionInstance(context));
  }

  static Future<List<MealSchedule>> get(BuildContext context) async {
    List<MealSchedule> mealsSchedule = [];
    return getCollectionInstance(context).orderBy('day').get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) => mealsSchedule.add(MealSchedule.fromDocument(document)));
      return mealsSchedule;
    });
  }
}
