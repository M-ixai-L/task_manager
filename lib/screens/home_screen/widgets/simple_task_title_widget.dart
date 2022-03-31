
import 'package:flutter/material.dart';
import 'package:trello/models/menu_model/menu_model.dart';
import 'package:trello/utils/values/colors.dart';

class SimpleTaskTitleWidget extends StatelessWidget {
  final int cardId, taskId;
  final String title;
  final VoidCallback onDelete;
  final VoidCallback onRename;


  const SimpleTaskTitleWidget({Key? key,
  required this.cardId,
  required this.taskId,
  required this.title,
  required this.onDelete,
  required this.onRename,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
      ),
      margin: const EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            //,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
      PopupMenuButton(
        icon: const Icon(Icons.settings),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  taskMenuList[0].title,
                  style: const TextStyle(
                    color: accentRedColor,
                  ),
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
      ),
    );
  }
}
