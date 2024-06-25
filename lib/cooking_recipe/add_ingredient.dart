import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:my_fridge/model/ingredient.dart';
import 'package:my_fridge/model/packing_type.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddIngredient extends StatefulWidget {
  const AddIngredient({required this.ingredient, required this.addIngredient});

  final Ingredient ingredient;
  final Function(Ingredient) addIngredient;

  @override
  _AddIngredientItemState createState() => _AddIngredientItemState();
}

class _AddIngredientItemState extends State<AddIngredient> {
  late Ingredient ingredient;

  @override
  void initState() {
    super.initState();
    ingredient = widget.ingredient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ingredient.name),
        leading: BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
      ),
      body: Column(
        children: [
          _buildQuantity(context),
          SizedBox(width: 10),
          FilledButton(
            onPressed: () {
              widget.addIngredient(ingredient);
              Navigator.popUntil(context, (route) => route.settings.name == "CookingRecipeDetails");
            },
            child: Text(AppLocalizations.of(context)!.cooking_recipe_add_the_ingredient),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuantity(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.white,
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                labelText: AppLocalizations.of(context)!.form_quantity_label,
              ),
              initialValue: ingredient.quantity.toString(),
              onChanged: (quantity) {
                setState(() {
                  ingredient.quantity = int.parse(quantity);
                });
              },
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.white,
            child: DropdownSearch<PackingType>(
                compareFn: (PackingType packingType, PackingType packingType2) {
                  return packingType.index == packingType2.index;
                },
                popupProps: PopupProps.modalBottomSheet(
                  showSelectedItems: true,
                  title: ListTile(title: Text(AppLocalizations.of(context)!.form_packing_type_label)),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(labelText: AppLocalizations.of(context)!.form_packing_type_label),
                ),
                items: PackingType.values,
                itemAsString: (PackingType packingType) => packingType.displayText(context),
                selectedItem: ingredient.packingType,
                onChanged: (PackingType? packingType) {
                  setState(() {
                    ingredient.packingType = packingType!;
                  });
                }),
          ),
        )
      ],
    );
  }
}
