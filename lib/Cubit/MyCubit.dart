import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/Cubit/AppStates.dart';
import 'package:path/path.dart';
import '../models/Task.dart';

class MyCubit extends Cubit<AppStates> {
  MyCubit() :super(InitState());

  static MyCubit get(context) => BlocProvider.of(context);
  IconData floatingActionButtonIcon = Icons.edit;
  List<Task> newTasks = [];
  List<Task> doneTasks = [];
  List<Task> archiveTasks = [];
  var index = 0;
  Database? database;
  IconData doneIcon=Icons.check_box_outline_blank;
  void changeDoneIcon(IconData newIcon){
    doneIcon=newIcon;
    emit(ChangeDoneIconState());
  }

  void changeFloatingIcon({bool icon = true}) {
    if (icon) {
      floatingActionButtonIcon = Icons.edit;
    }
    else {
      floatingActionButtonIcon = Icons.add;
    }
    emit(ChangeFloatingIconState());
  }
  void changeBottomNavBarScreen(current) {
    index = current;
    emit(ChangeBottomNavState());
  }
  void createDatabase(context) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    openDatabase(
        path,
        version: 1,
        onCreate: (Database database, int version) {
          print("Database Created Successfuly");
          database
              .execute("CREATE TABLE tasks "
              '(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
              .then((value) => print("Table Created successfuly"))
              .catchError((error) {
            print(error);
          });
        }, onOpen: (database) async {
          print("Database Opened Successfuly");
          getDataFromDataBase(database);
        }).then((value) {
          database=value;
          emit(CreateDataBase());
        });
  }

  Future<void> insertToDatabase(Task newTask) async {
    return await database!.transaction((txn) async {

      await txn.rawInsert('INSERT INTO tasks (title,date,time,status) '
          'VALUES("${newTask.taskTitle}","${newTask.taskDate}","${newTask.taskTime}","${newTask.status}")')
          .then((value) => print("id = ${value}"))
          .catchError((error) {
        print(error);
      });
    }).then((value) {
      emit(UpdateDataBase());
      getDataFromDataBase(database!);
    });
  }

  void deleteFromDatabase(int id) async {
    await database!
        .rawDelete("DELETE FROM tasks WHERE id='$id'")
        .then((value) {
      print("Deleted success");
      emit(DeleteFromDataBase());
      getDataFromDataBase(database!);
    });
  }

  void updateDatabase(String status,int id) {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id= ?',
        ['$status',id]).then((value) {
      getDataFromDataBase(database!);
    });
    emit(UpdateDataBase());
  }

  void getDataFromDataBase(Database database) async {
    database.rawQuery("SELECT * FROM tasks").then((value){
      Task myTask;
      newTasks=[]; doneTasks=[]; archiveTasks=[];
      value.forEach((element) {
        myTask=Task(
          id: int.parse(element['id'].toString()),
          taskTitle: element['title'].toString(),
          taskTime: element['time'].toString(),
          taskDate: element['date'].toString(),
          status: element['status'].toString(),
        );
        if(element['status']=='new') {
          newTasks.add(myTask);
        } else if(element['status']=='done') {
          doneTasks.add(myTask);
        } else if(element['status']=='archive') {
          archiveTasks.add(myTask);
        }
      });
      emit(GetFromDataBase());
    });
  }

}