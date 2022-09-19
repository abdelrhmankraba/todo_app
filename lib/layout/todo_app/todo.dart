// ignore_for_file: avoid_print
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/cubit_mode.dart';
import 'package:todo/shared/cubit/cubit_todo.dart';
import 'package:intl/intl.dart';

import '../../shared/cubit/states_todo.dart';

class HomeLayout extends StatelessWidget {

  HomeLayout({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleControl = TextEditingController();
  var timeControl = TextEditingController();
  var dateControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubitToDo()..createDatabase(),
      child: BlocConsumer<AppCubitToDo, AppState>(
        listener: (context, state) {
          if(state is AppInsertDatabase)
            {
              Navigator.pop(context);
              timeControl.text= '';
              dateControl.text = '';
              titleControl.text= '';

            }
        },
        builder: (context, state) {
          AppCubitToDo cubit = AppCubitToDo.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  cubit.titles[cubit.currentIndex],
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              actions:
              [
                IconButton(
                  icon: const Icon(Icons.brightness_4_outlined,),
                  onPressed: (){
                    AppCubitMode.get(context).changeAppMode();
                  },
            ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isButtonSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(title: titleControl.text, time: timeControl.text, date: dateControl.text);
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20.0),
                          color: Colors.white38,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextForm(
                                  onSubmit: (String? value) {
                                    if (formKey.currentState!.validate()) {
                                      print('kraba');
                                    }
                                  },
                                  onChange: (value) {},
                                  onTap: () {},
                                  controller: titleControl,
                                  keyboardType: TextInputType.text,
                                  label: 'Task title',
                                  prefix: Icons.title,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'title must be not empty';
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                defaultTextForm(
                                  controller: timeControl,
                                  keyboardType: TextInputType.datetime,
                                  label: 'Task time',
                                  prefix: Icons.watch_later_outlined,
                                  onSubmit: (value) {},
                                  onChange: (value) {},
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeControl.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'time must be not empty';
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                defaultTextForm(
                                  controller: dateControl,
                                  keyboardType: TextInputType.datetime,
                                  label: 'Task Date',
                                  prefix: Icons.date_range_outlined,
                                  onSubmit: (value) {},
                                  onChange: (value) {},
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-08-11'),
                                    ).then((value) {
                                      dateControl.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty) {
                                      return 'date must be not empty';
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      ).closed.then((value) {
                        cubit.changeIcon(
                          isButtonSheetShow: false,
                          actionIcon: Icons.edit,
                    );
                  });
                  cubit.changeIcon(
                    isButtonSheetShow: true,
                    actionIcon: Icons.add,
                  );
                }
              },
              child: Icon(
                cubit.actionIcon,
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetLoadingDatabase,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottom(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.done,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
