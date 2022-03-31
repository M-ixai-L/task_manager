import 'package:flutter/material.dart';
import 'package:trello/utils/values/colors.dart';

class RenameTaskButton extends StatelessWidget {
  final ValueChanged<String> onTap;
  const RenameTaskButton({Key? key, required this.onTap}) : super(key: key);

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController taskNameController = TextEditingController();

    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: const Text(
          'Enter new task name',
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
              controller: taskNameController,
              style: const TextStyle(
                color: blackColor,
                fontSize: 24,
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          TextButton(
            onPressed: () {
              if (taskNameController.text != '') {

                onTap(taskNameController.text);


                Navigator.pop(context);
              } else {
                showSnackBar(context, 'Please enter name');
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: blueDarkColor,
                borderRadius: BorderRadius.circular(5),
              ),
              height: 50,
              child: const Text(
                'Rename task',
                style: TextStyle(color: whiteColor, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
