import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trello/bloc/tasks/tasks_state.dart';
import 'package:trello/models/card_model/card_model.dart';
import 'package:trello/models/card_model/task_model.dart';

class TasksCubit extends Cubit<TasksState> {
  final _prefs = SharedPreferences.getInstance();

  TasksCubit() : super(TasksState());

  void saveData(CardModel newCard) async {
    final prefs = await _prefs;
    String json = jsonEncode((state.cardList ?? [])..add(newCard));
    prefs.setString('saveCardList', json);
  }

  void saveDataChange() async {
    final prefs = await _prefs;
    String json = jsonEncode((state.cardList ?? []));
    prefs.setString('saveCardList', json);
  }

  void loadData() async {
    final prefs = await _prefs;
    String json = prefs.getString('saveCardList') ?? '';
    if (json == '') {
      print('No saved data');
    } else {
      emit(state.copyWith(isLoading: true));
      final map = jsonDecode(json) as List<dynamic>;
      final cards = map
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(state.copyWith(cardList: cards, isLoading: false));
    }
  }

  void removeCard(int id) {
    emit(state.copyWith(cardList: state.cardList!..removeAt(id)));
  }

  void renameCard(int id, String newTitle) {
    state.cardList![id].title = newTitle;
    emit(state.copyWith(cardList: state.cardList));
  }

  void removeTask(int id,int taskId) {
    state.cardList![id].tasks.removeAt(taskId);
    emit(state.copyWith(cardList: state.cardList));
  }


  void renameTask(int id,int taskId, String newTitle) {
    state.cardList![id].tasks[taskId].title = newTitle;
    emit(state.copyWith(cardList: state.cardList));
  }

  int getLength(){
    if(state.cardList == null){
      return 0;
    }
    return state.cardList!.length;
  }
  int getTasksLength(int id){
    if(state.cardList == null){
      return 0;
    }
    return state.cardList![id].tasks.length;
  }

  void clearData() async {
    final prefs = await _prefs;
    prefs.clear();
    emit(state.copyWith(cardList: []));
  }
}
