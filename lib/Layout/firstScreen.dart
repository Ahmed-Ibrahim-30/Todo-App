import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Cubit/AppStates.dart';
import '../Cubit/MyCubit.dart';
class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit,AppStates>(
        listener: (context,state){

        },
        builder: (context,state){
          MyCubit myCubit = MyCubit.get(context);
          print("new Tasks = ${myCubit.newTasks}");
          print("done Tasks = ${myCubit.doneTasks}");
          print("arcieve Tasks = ${myCubit.archiveTasks}");
          return ListView.separated(
              itemBuilder: (context,index){
                return Dismissible(
                  key: Key(myCubit.newTasks[index].id.toString()),
                  onDismissed: (direction){
                    myCubit.deleteFromDatabase(myCubit.newTasks[index].id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          child: Text(myCubit.newTasks[index].taskTime),
                        ),
                        const SizedBox(width: 14,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(myCubit.newTasks[index].taskTitle,style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                              const SizedBox(height: 3,),
                              Text(myCubit.newTasks[index].taskDate,style: TextStyle(
                                  color: Colors.grey[500]
                              ),),
                            ],
                          ),
                        ),
                        const SizedBox(width: 26,),
                        IconButton(
                            onPressed: (){
                              //print(MyCubit.tasks[index]['id']);
                              myCubit.updateDatabase('done',myCubit.newTasks[index].id );
                            },
                            icon: Icon(myCubit.newTasks[index].status=="new"?Icons.check_box_outline_blank:Icons.check_box,color: Colors.green)
                        ),
                        const SizedBox(width: 10,),
                        IconButton(
                            onPressed: (){
                              myCubit.updateDatabase('archive',myCubit.newTasks[index].id );
                            },
                            icon: const Icon(Icons.archive_outlined,color: Colors.black54)
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context,index)=>SizedBox(height: 1,child: Container(color: Colors.grey,),),
              itemCount: myCubit.newTasks.length
          );
        }
    );
  }
}
