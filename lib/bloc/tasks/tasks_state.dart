import 'package:trello/models/card_model/card_model.dart';

class TasksState {
  final bool isLoading;
  final List<CardModel>? cardList;

  TasksState({this.isLoading = false, this.cardList});

  TasksState copyWith({
    bool? isLoading,
    List<CardModel>? cardList,
  }) {
    return TasksState(
      isLoading: isLoading ?? this.isLoading,
      cardList: cardList ?? this.cardList,
    );
  }
}
