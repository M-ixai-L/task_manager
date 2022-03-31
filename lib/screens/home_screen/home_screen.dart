import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trello/bloc/tasks/tasks_cubit.dart';
import 'package:trello/bloc/tasks/tasks_state.dart';
import 'package:trello/models/card_model/card_model.dart';
import 'package:trello/models/card_model/task_model.dart';
import 'package:trello/screens/home_screen/widgets/add_card_button.dart';
import 'package:trello/screens/home_screen/widgets/add_task_button.dart';
import 'package:trello/screens/home_screen/widgets/app_settings_widget.dart';
import 'package:trello/screens/home_screen/widgets/simple_card_title_widget.dart';
import 'package:trello/screens/home_screen/widgets/simple_task_title_widget.dart';
import 'package:trello/utils/values/colors.dart';

import 'widgets/rename_card_button.dart';
import 'widgets/rename_task_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final tasksCubit = TasksCubit();

  @override
  void initState() {
    tasksCubit.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      appBar: appBar(context, appSettings),
      body: BlocBuilder<TasksCubit, TasksState>(
        bloc: tasksCubit,
        builder: (_, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return bodyWidget(state.cardList ?? []);
        },
      ),
    );
  }

  Widget bodyWidget(List<CardModel> cards) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: tasksCubit.getLength() + 1,
      itemBuilder: (_, id) => (tasksCubit.getLength() > id)
          ? simpleCard(cards[id], id)
          : addCard(id), //show card list or add card button
    );
  }

  Widget simpleCard(CardModel card, int id) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: grayColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tasksCubit.getTasksLength(id) + 2,
                itemBuilder: (_, idTask) {
                  if (idTask == 0) {
                    return simpleCardTitle(card, id);
                  } //show cardTitle
                  if (tasksCubit.getTasksLength(id) > idTask - 1) {
                    //show task or add task button
                    return simpleTaskTitle(id, idTask - 1);
                  }
                  return addTask(id, idTask);
                },
              ),
            ),
          ),
          //Container(height: 50,)
        ],
      ),
    );
  }

  Widget get appSettings {
    return AppSettingsWidget(
      onDelete: () {
        setState(
          () {
            tasksCubit.clearData();
          },
        );
      },
    );
  }

  Widget simpleCardTitle(CardModel card, int id) {
    return SimpleCardTitleWidget(
      title: card.title,
      onDelete: () {
        setState(() {
          tasksCubit.removeCard(id);
          tasksCubit.saveDataChange();
        });
      },
      onRename: () {
        showDialog(
          context: context,
          builder: (buildContext) => renameCard(id),
        );
      },
    );
  }

  Widget simpleTaskTitle(int cardId, int taskId) {
    return SimpleTaskTitleWidget(
      cardId: cardId,
      taskId: taskId,
      title: tasksCubit.state.cardList![cardId].tasks[taskId].title,
      onDelete: () {
        setState(
          () {
            tasksCubit.removeTask(cardId, taskId);
            tasksCubit.saveDataChange();
          },
        );
      },
      onRename: () {
        showDialog(
          context: context,
          builder: (buildContext) => renameTask(cardId, taskId),
        );
      },
    );
  }

  Widget renameTask(
    int id,
    int taskId,
  ) {
    return RenameTaskButton(
      onTap: (text) {
        setState(
          () {
            tasksCubit.renameTask(id, taskId, text);
            tasksCubit.saveDataChange();
          },
        );
      },
    );
  }

  Widget renameCard(int id) {
    return RenameCardButton(
      onTap: (text) {
        setState(
          () {
            tasksCubit.renameCard(id, text);
            tasksCubit.saveDataChange();
          },
        );
      },
    );
  }

  Widget addTask(int id, int idTasks) {
    return AddTaskButton(
      onTap: (text) {
        setState(
          () {
            tasksCubit.state.cardList![id].tasks
                .add(TaskModel(id: idTasks, title: text));
            tasksCubit.saveDataChange();
          },
        );
      },
    );
  }

  Widget addCard(int id) {
    return AddCardButton(
      onTap: (text) {
        setState(
          () {
            tasksCubit.saveData(CardModel(id: id, title: text, tasks: []));
            tasksCubit.loadData();
          },
        );
      },
    );
  }
}

AppBar appBar(BuildContext context, Widget appSettings) {
  return AppBar(
    backgroundColor: purpleColor,
    title: const Text('Trello'),
    centerTitle: true,
    actions: [appSettings],
  );
}
