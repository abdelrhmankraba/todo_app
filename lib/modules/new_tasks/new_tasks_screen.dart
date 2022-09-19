import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit_todo.dart';
import '../../shared/cubit/states_todo.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubitToDo , AppState>(
        listener: (context , state){},
        builder: (context , state){
          var tasks = AppCubitToDo.get(context).newTasks;
          return taskBuilder(tasks: tasks);
        },
      );
  }
}
