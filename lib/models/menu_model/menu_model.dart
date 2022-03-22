import 'package:flutter/material.dart';
import 'package:trello/utils/values/colors.dart';

enum TaskMenuItem{
  delete,
  rename,
}
class TaskMenu{
  String title;
  Icon icon;
  TaskMenu(this.title,this.icon);
}
final List<TaskMenu>taskMenuList = [
  TaskMenu('Delete', const Icon(Icons.delete_forever, color: accentRedColor),),
  TaskMenu('Rename', const Icon(Icons.restore_page_rounded),),

];