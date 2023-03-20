import 'package:flutter/material.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/model/expansion_data.dart';
import 'package:my_fridge/model/meal_type.dart';
import 'package:my_fridge/services/meal_list_service.dart';
import 'package:my_fridge/widget/loader.dart';
import 'meal_expansion_list.dart';

class MealList extends StatefulWidget {
  const MealList() : super();

  @override
  State<StatefulWidget> createState() => _MealListState();
}

class _MealListState extends State<MealList> {

  List<ExpansionData> listData = [];

  @override
  void initState() {
    MealType.values.forEach((mealType) => listData.add(ExpansionData(data: mealType)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        children: listData.map<ExpansionPanel>((expansionData) => _buildMealListItem(context, expansionData)).toList(),
        expansionCallback: (index, isExpanded) {
          setState(
                () {
              listData[index].isExpanded = !isExpanded;
            },
          );
        },
      ),
    );
  }

  ExpansionPanel _buildMealListItem(BuildContext context, ExpansionData expansionData) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: expansionData.isExpanded,
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: Text((expansionData.data as MealType).display(context)),
        );
      },
      body: FutureBuilder<List<CookingRecipe>>(
          future: MealListService.getByMealType(expansionData.data, context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loader();
            }
            return MealExpansionList(mealList: snapshot.data!);
          }),
    );
  }
}