import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Cubit/AppStates.dart';
import '../Cubit/MyCubit.dart';
import '../shared/components/constraint.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({Key? key}) : super(key: key);

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
                  key: Key(myCubit.archiveTasks[index].id.toString()),
                  onDismissed: (direction){
                    myCubit.deleteFromDatabase(myCubit.archiveTasks[index].id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          child: Text(myCubit.archiveTasks[index].taskTime),
                        ),
                        const SizedBox(width: 14,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(myCubit.archiveTasks[index].taskTitle,style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                              const SizedBox(height: 3,),
                              Text(myCubit.archiveTasks[index].taskDate,style: TextStyle(
                                  color: Colors.grey[500]
                              ),),
                            ],
                          ),
                        ),
                        const SizedBox(width: 26,),
                        const Icon(
                          Icons.check_box,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10,),
                        IconButton(
                            onPressed: (){
                              myCubit.updateDatabase('new',myCubit.archiveTasks[index].id );
                            },
                            icon: const Icon(Icons.archive_outlined,color: Colors.black54)
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context,index)=>SizedBox(height: 1,child: Container(color: Colors.grey,),),
              itemCount: myCubit.archiveTasks.length
          );
        }
    );
  }
}
