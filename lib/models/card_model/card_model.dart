import 'package:trello/models/card_model/task_model.dart';

class CardModel{
  int id;
  String title;
  List<TaskModel> tasks;
  CardModel( this.id,  this.title,  this.tasks);
}


