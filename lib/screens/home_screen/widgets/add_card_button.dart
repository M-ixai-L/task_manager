import 'package:flutter/material.dart';
import 'package:trello/utils/values/colors.dart';

class AddCardButton extends StatelessWidget {
  final ValueChanged<String> onTap;
  const AddCardButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardNameController = TextEditingController();
    final cardNameFocus = FocusNode();
    return TextButton(
      onPressed: () => showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: const Text(
              'Enter card name',
              style: TextStyle(
                color: blackColor,
                fontSize: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: cardNameController,
                  focusNode: cardNameFocus,
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 24,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              TextButton(
                onPressed: () {
                  onTap(cardNameController.text);
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: blueDarkColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 50,
                  child: const Text(
                    'Add card',
                    style: TextStyle(color: whiteColor, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: whiteColor.withOpacity(0.55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.add,
          color: whiteColor,
          size: 50,
        ),
      ),
    );
  }
}
