import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/cubit/cubit_todo.dart';
import '../../shared/components/components.dart';
import '../../shared/cubit/states_todo.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubitToDo , AppState>(
      listener: (context , state){},
      builder: (context , state){
        var tasks = AppCubitToDo.get(context).doneTasks;
        return taskBuilder(tasks: tasks);
      },
    );
  }
}