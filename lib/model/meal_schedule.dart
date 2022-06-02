import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_fridge/model/week_day.dart';

class MealSchedule {
  MealSchedule({this.id, required this.day, this.lunch, this.dinner});

  String? id;

  int day;

  String? lunch;

  String? dinner;

  WeekDay get dayValue => WeekDay.values[day];

  static MealSchedule fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return MealSchedule(
        id: document.id,
        lunch: data['lunch'],
        dinner: data['dinner'],
        day: data['day']);
  }

  Map<String, Object> get asMap {
    return {'lunch': this.lunch!, 'dinner': this.dinner!, 'day': this.day};
  }
}
