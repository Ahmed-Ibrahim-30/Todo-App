import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/Cubit/MyCubit.dart';
import 'package:todolist/Layout/firstScreen.dart';
import 'package:todolist/Layout/secondScreen.dart';
import 'package:todolist/Layout/thirdScreen.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:todolist/Moduels/MyTextFromField.dart';
import 'package:todolist/models/Task.dart';
import '../Cubit/AppStates.dart';
import '../shared/components/constraint.dart';

class HomeScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var firstController = TextEditingController();
  var secondController = TextEditingController();
  var thirdController = TextEditingController();

  bool isButtonSheetShown = false;
  Task ?newTask;

  List<Widget> screens = [
    const FirstScreen(),
    const SecondScreen(),
    const ThirdScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MyCubit()..createDatabase(context),
      child: BlocConsumer<MyCubit, AppStates>(
          listener: (BuildContext context, state) {},
          builder: (context, state) {
            MyCubit myCubit = MyCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(title: const Text("Todo App")),
              body: ConditionalBuilder(
                condition: true,
                builder: (context) => screens[myCubit.index],
                fallback: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(myCubit.floatingActionButtonIcon),
                onPressed: () {
                  if (isButtonSheetShown) {
                    if (formKey.currentState!.validate()) {
                      newTask=Task(
                          taskTitle:firstController.text,
                          taskTime: secondController.text,
                          taskDate: thirdController.text
                      );

                      firstController.text="";
                      secondController.text="";
                      thirdController.text="";
                      myCubit.insertToDatabase(newTask!)
                          .then((value) {
                        Navigator.pop(context);
                        isButtonSheetShown = false;
                        myCubit.changeFloatingIcon();
                      });
                    }
                  }
                  else {
                    scaffoldKey.currentState!
                        .showBottomSheet((context) => Form(
                              key: formKey,
                              child: Container(
                                color: Colors.grey[200],
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    myTextFromField(
                                      labelText: "Task title",
                                      controller: firstController,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Task title";
                                        }
                                        return null;
                                      },
                                      icon: Icons.title,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    myTextFromField(
                                      labelText: "Text Time",
                                      controller: secondController,
                                      keyboardType: TextInputType.datetime,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Task Date";
                                        }
                                        return null;
                                      },
                                      icon: Icons.timelapse,
                                      ontap: () {
                                        showTimePicker(context: context, initialTime: TimeOfDay.now())
                                            .then((value) {
                                          secondController.text = value!.format(context);
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 10,),
                                    myTextFromField(
                                      labelText: "Text Date",
                                      controller: thirdController,
                                      keyboardType: TextInputType.datetime,
                                      validate: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Task date";
                                        }
                                        return null;
                                      },
                                      icon: Icons.date_range,
                                      ontap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2025),
                                        ).then((value) {
                                          thirdController.text =
                                              "${value!.year}/${value.month}/${value.day}";
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )).closed.then((value) {
                              isButtonSheetShown = false;
                              myCubit.changeFloatingIcon();//state
                            });
                    myCubit.changeFloatingIcon(icon: false); //state
                    isButtonSheetShown = true;
                  }
                },
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: myCubit.index,
                onTap: (choiceIndex) {
                  myCubit.changeBottomNavBarScreen(choiceIndex);
                },
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                  BottomNavigationBarItem(icon: Icon(Icons.cloud_done_rounded), label: "Done"),
                  BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: "Archived"),
                ],
              ),
            );
          }),
    );
  }


}
