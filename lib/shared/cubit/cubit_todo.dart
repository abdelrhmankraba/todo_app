import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archived_tasks/archived_tasks.dart';
import 'package:todo/modules/done_tasks/done_screen.dart';
import 'package:todo/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo/shared/cubit/states_todo.dart';

class AppCubitToDo extends Cubit<AppState> {
  AppCubitToDo() : super(AppInitialState());

  static AppCubitToDo get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  bool isButtonSheetShow = false;
  IconData actionIcon = Icons.edit;
  late Database database;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeBottom(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBar());
  }

  void changeIcon({required bool isButtonSheetShow, required IconData actionIcon,}) {
    this.isButtonSheetShow =isButtonSheetShow;
    this.actionIcon = actionIcon;
    emit(AppChangeBottomSheetState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database is created');
        database.execute(
            'CREATE TABLE Tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)').then((value) {
          print('create table');
        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database is opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  void updateTasks({required String status, required int id}) async {
    database.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        [ status , id]).then((value){
      getDataFromDatabase(database);
      emit(AppUpdateDatabase());
    });
  }

  void deleteTasks({required int id}) async {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value){
      getDataFromDatabase(database);
      emit(AppUpdateDatabase());
    });
  }

  insertDatabase({required String title, required String time, required String date,})async{
    await database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO Tasks(title,date,time,status) VALUES ("$title","$date","$time","new")').then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabase());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when inserted record ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) async {newTasks=[];archiveTasks=[];doneTasks=[];
  emit(AppGetLoadingDatabase());
  database.rawQuery('SELECT * FROM Tasks').then((value) {
    value.forEach((element){
      if(element['status']=='new'){
        newTasks.add(element);
      }
      if(element['status']=='done'){
        doneTasks.add(element);
      }
      if(element['status']=='archive'){
        archiveTasks.add(element);
      }
    });
    emit(AppGetDatabase());
  });
  }

}

