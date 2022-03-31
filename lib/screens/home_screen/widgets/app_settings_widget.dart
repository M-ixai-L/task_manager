import 'package:flutter/material.dart';
import 'package:trello/models/menu_model/menu_model.dart';
import 'package:trello/utils/values/colors.dart';

class AppSettingsWidget extends StatelessWidget {
  final VoidCallback onDelete;

  const AppSettingsWidget({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.settings,
        color: whiteColor,
      ),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Clear data',
                style: TextStyle(
                  color: accentRedColor,
                ),
              ),
              taskMenuList[0].icon,
            ],
          ),
          value: TaskMenuItem.delete,
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case TaskMenuItem.delete:
            onDelete();
            break;
          default:
            break;
        }
      },
    );
  }
}
