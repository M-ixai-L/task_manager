

class TaskModel {
  int id;
  String title;
  TaskModel( {required this.id,required this.title});

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as int,
      title: json['title'] as String,
    );


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }

}