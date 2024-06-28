import 'package:flutter/material.dart';
import 'package:my_fridge/cooking_recipe/cooking_recipe_expansion_list.dart';
import 'package:my_fridge/model/cooking_recipe.dart';
import 'package:my_fridge/model/expansion_data.dart';
import 'package:my_fridge/model/meal_type.dart';
import 'package:my_fridge/services/cooking_recipe_service.dart';
import 'package:my_fridge/widget/loader.dart';

class CookingRecipeList extends StatefulWidget {
  const CookingRecipeList() : super();

  @override
  State<StatefulWidget> createState() => _CookingRecipeListState();
}

class _CookingRecipeListState extends State<CookingRecipeList> {

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
        children: listData.map<ExpansionPanel>((expansionData) => _buildCookingRecipeListItem(context, expansionData)).toList(),
        expansionCallback: (index, isExpanded) {
          setState(
                () {
              listData[index].isExpanded = isExpanded;
            },
          );
        },
      ),
    );
  }

  ExpansionPanel _buildCookingRecipeListItem(BuildContext context, ExpansionData expansionData) {
    return ExpansionPanel(
      canTapOnHeader: true,
      isExpanded: expansionData.isExpanded,
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: Text((expansionData.data as MealType).display(context)),
        );
      },
      body: FutureBuilder<List<CookingRecipe>>(
          future: CookingRecipeService.getByMealType(expansionData.data),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loader();
            }
            return CookingRecipeExpansionList(cookingRecipeList: snapshot.data!);
          }),
    );
  }
}