import 'package:trello/models/card_model/task_model.dart';

class CardModel {
  int id;
  String title;
  List<TaskModel> tasks;

  CardModel({required this.id, required this.title, required this.tasks});

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        id: json['id'] as int,
        title: json['title'] as String,
        tasks: (json['tasks'] as List<dynamic>)
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tasks': tasks,
    };
  }
}
