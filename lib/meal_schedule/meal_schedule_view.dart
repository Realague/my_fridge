import 'package:flutter/material.dart';
import 'package:my_fridge/model/meal_schedule.dart';
import 'package:my_fridge/model/week_day.dart';
import 'package:my_fridge/services/meal_schedule_service.dart';

class MealScheduleView extends StatefulWidget {
  const MealScheduleView() : super();

  @override
  State<StatefulWidget> createState() => _MealScheduleViewState();
}

class _MealScheduleViewState extends State<MealScheduleView> {
  late List<MealSchedule> mealsSchedule;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MealScheduleService.get(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        mealsSchedule = (snapshot.data as List<MealSchedule>);
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: dataBody(mealsSchedule, context)),
              )
            ],
          );
        }
        return Center();
      },
    );
  }
}

DataTable dataBody(List<MealSchedule> mealsSchedule, BuildContext context) {
  return DataTable(
    sortColumnIndex: 0,
    showCheckboxColumn: false,
    columns: [
      DataColumn(label: Text('Day')),
      DataColumn(label: Text('Lunch')),
      DataColumn(label: Text('Dinner')),
    ],
    rows: mealsSchedule
        .map(
          (meal) => DataRow(cells: [
            DataCell(Text(meal.dayValue.display(context))),
            DataCell(
              Text(meal.lunch != null ? meal.lunch! : ""),
            ),
            DataCell(
              Text(meal.dinner != null ? meal.dinner! : ""),
            ),
          ]),
        )
        .toList(),
  );
}

Row readonly() {
  return Row(children: [
    Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(_article!.name +
            ", " +
            _article!.quantityUnit.displayForDropDown(context) +
            " " +
            _article!.quantity.toString()),
      ),
    ),
    Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              _article!.isEditable = true;
            });
          },
          child: const Icon(Icons.edit)),
    ),
    Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              _article!.isEditable = false;
              widget.onRemoveIngredient!();
            });
          },
          child: const Icon(Icons.delete)),
    ),
  ]);
}
