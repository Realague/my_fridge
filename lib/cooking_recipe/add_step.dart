import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddStep extends StatefulWidget {
  const AddStep({required this.step, required this.addStep, required this.stepCount});
  final int stepCount;
  final String step;
  final Function(String) addStep;

  @override
  _AddStepItemState createState() => _AddStepItemState();
}

class _AddStepItemState extends State<AddStep> {
  TextEditingController stepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    stepController.text = widget.step;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Etape "+widget.stepCount.toString()),
        leading: BackButton(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          TextField(
            controller: stepController,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                ),
              label: const Text("Etape")
            ),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () {
              widget.addStep(stepController.text);
              Navigator.popUntil(context, (route) => route.settings.name == "CookingRecipeDetails");
            },
            child: Text(AppLocalizations.of(context)!.cooking_recipe_add_the_step),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).primaryColor),
              shape: WidgetStateProperty.all(
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

}
