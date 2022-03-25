import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trello/models/card_model/card_model.dart';
import 'package:trello/models/card_model/task_model.dart';
import 'package:trello/models/menu_model/menu_model.dart';

import 'package:trello/utils/values/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<CardModel> cardList = [];
  final _prefs = SharedPreferences.getInstance();

  saveData() async {
    final prefs = await _prefs;
    String json = jsonEncode(cardList);
    prefs.setString('saveCardList', json);
  }

  loadData() async {
    final prefs = await _prefs;
    String json = prefs.getString('saveCardList') ?? '';
    if (json == '') {
      print('No saved data');
    } else {
      final map = jsonDecode(json) as List<dynamic>;
      final cards = map
          .map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() {
        cardList.clear();
        cardList.addAll(cards);
      });
    }
  }

  clearData() async {
    final prefs = await _prefs;
    prefs.clear();
    cardList.clear();
  }

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      appBar: appBar(context, appSettings),
      body: bodyWidget,
    );
  }

  Widget get bodyWidget {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cardList.length + 1,
      itemBuilder: (_, id) => (cardList.length > id)
          ? simpleCard(id)
          : addCard(id), //show card list or add card button
    );
  }

  Widget simpleCard(int id) {
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
                itemCount: cardList[id].tasks.length + 2,
                itemBuilder: (_, idTask) => (idTask == 0)
                    ? simpleCardTitle(id) //show cardTitle
                    : ((cardList[id].tasks.length >
                            idTask - 1) //show task or add task button
                        ? simpleTaskTitle(idTask - 1, cardList[id])
                        : addTask(idTask, cardList[id])),
              ),
            ),
          ),
          //Container(height: 50,)
        ],
      ),
    );
  }

  Widget simpleTaskTitle(int id, CardModel cardModel) {
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
            cardModel.tasks[id].title,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          taskSettings(id, cardModel),
        ],
      ),
    );
  }

  Widget simpleCardTitle(int id) {
    return Row(
      children: [
        Flexible(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              cardList[id].title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        cardSettings(id, cardList),
      ],
    );
  }

  Widget taskSettings(int id, CardModel cardModel) {
    return PopupMenuButton(
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
            cardModel.tasks.removeAt(id);
            saveData();
            setState(() {});
            break;
          case TaskMenuItem.rename:
            showDialog(
              context: context,
              builder: (buildContext) => renameTask(id, cardModel),
            );
            break;
          default:
            break;
        }
      },
    );
  }

  Widget cardSettings(int id, List<CardModel> cardModel) {
    return PopupMenuButton(
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
            cardModel.removeAt(id);
            saveData();
            setState(() {});
            break;
          case TaskMenuItem.rename:
            showDialog(
              context: context,
              builder: (buildContext) => renameCard(id, cardModel),
            );
            break;
          default:
            break;
        }
      },
    );
  }

  Widget get  appSettings {
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
            clearData();


            setState(() {});
            break;

          default:
            break;
        }
      },
    );
  }

  Widget addTask(int id, CardModel cardModel) {
    TextEditingController taskNameController = TextEditingController();
    return TextButton(
      onPressed: () => showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: const Text(
              'Enter task name',
              style: TextStyle(
                color: blackColor,
                fontSize: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: taskNameController,
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 24,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (taskNameController.text != '') {
                    cardModel.tasks.add(
                      TaskModel(id: id, title: taskNameController.text),
                    );
                    saveData();
                    setState(() {});
                    Navigator.pop(context);
                  }
                  else{
                  showSnackBar(context, 'Please enter name');
                  }

                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: blueDarkColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 50,
                  child: const Text(
                    'Add task',
                    style: TextStyle(color: whiteColor, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: blackColor.withOpacity(0.35),
              size: 30,
            ),
            Text(
              'Add task',
              style: TextStyle(
                color: blackColor.withOpacity(0.35),
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget renameTask(int id, CardModel cardModel) {
    TextEditingController taskNameController = TextEditingController();
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: const Text(
          'Enter new task name',
          style: TextStyle(
            color: blackColor,
            fontSize: 20,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: taskNameController,
              style: const TextStyle(
                color: blackColor,
                fontSize: 24,
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          TextButton(
            onPressed: () {
              if (taskNameController.text != '') {
                cardModel.tasks[id].title = taskNameController.text;
                saveData();
                setState(() {});
                Navigator.pop(context);
              }
              else{
                showSnackBar(context, 'Please enter name');
              }
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: blueDarkColor,
                borderRadius: BorderRadius.circular(5),
              ),
              height: 50,
              child: const Text(
                'Rename task',
                style: TextStyle(color: whiteColor, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renameCard(int id, List<CardModel> cardModel) {
    TextEditingController taskNameController = TextEditingController();
    saveData();
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: const Text(
          'Enter new card name',
          style: TextStyle(
            color: blackColor,
            fontSize: 20,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50,
            child: TextFormField(
              controller: taskNameController,
              style: const TextStyle(
                color: blackColor,
                fontSize: 24,
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          TextButton(
            onPressed: () {
              cardModel[id].title = taskNameController.text;
              setState(() {});
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: blueDarkColor,
                borderRadius: BorderRadius.circular(5),
              ),
              height: 50,
              child: const Text(
                'Rename card',
                style: TextStyle(color: whiteColor, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addCard(int id) {
    TextEditingController cardNameController = TextEditingController();
    return TextButton(
      onPressed: () => showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: const Text(
              'Enter card name',
              style: TextStyle(
                color: blackColor,
                fontSize: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: TextFormField(
                  controller: cardNameController,
                  style: const TextStyle(
                    color: blackColor,
                    fontSize: 24,
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              TextButton(
                onPressed: () {
                  cardList.add(
                    CardModel(
                        id: id, title: cardNameController.text, tasks: []),
                  );
                  saveData();
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: blueDarkColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 50,
                  child: const Text(
                    'Add card',
                    style: TextStyle(color: whiteColor, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: whiteColor.withOpacity(0.55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.add,
          color: whiteColor,
          size: 50,
        ),
      ),
    );
  }
}

AppBar appBar(BuildContext context, Widget appSetings) {
  return AppBar(
    backgroundColor: purpleColor,
    title: const Text('Trello'),
    centerTitle: true,
    actions: [
      appSetings,
    ],
  );
}
