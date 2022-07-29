import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/Cubit/BlocObserver.dart';
import 'package:todolist/Cubit/MyCubit.dart';

import 'Cubit/AppStates.dart';
import 'Layout/homePage.dart';

void main() {
  BlocOverrides.runZoned(() {runApp(MyApp());},
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  late int counter=0;
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        home: HomeScreen()
    );
  }
}
