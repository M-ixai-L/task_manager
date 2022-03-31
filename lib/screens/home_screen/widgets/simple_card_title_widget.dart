import 'package:flutter/material.dart';
import 'package:trello/models/menu_model/menu_model.dart';
import 'package:trello/utils/values/colors.dart';

class SimpleCardTitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback onDelete;
  final VoidCallback onRename;

  const SimpleCardTitleWidget({
    Key? key,
    required this.title,
    required this.onDelete,
    required this.onRename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    taskMenuList[0].title,
                    style: const TextStyle(color: accentRedColor),
                  ),
                  taskMenuList[0].icon,
                ],
              ),
              value: TaskMenuItem.delete,
            ),
            PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(taskMenuList[1].title),
                  taskMenuList[1].icon,
                ],
              ),
              value: TaskMenuItem.rename,
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case TaskMenuItem.delete:
                onDelete();
                break;
              case TaskMenuItem.rename:
              onRename();
                break;
              default:
                break;
            }
          },
        ),
      ],
    );
  }
}
