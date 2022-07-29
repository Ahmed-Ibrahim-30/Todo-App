import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Cubit/AppStates.dart';
import '../Cubit/MyCubit.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit,AppStates>(
        listener: (context,state){

        },
        builder: (context,state){
          MyCubit myCubit = MyCubit.get(context);
          return ListView.separated(
              itemBuilder: (context,index){
                return Dismissible(
                  key: Key(myCubit.doneTasks[index].id.toString()),
                  onDismissed: (direction){
                    myCubit.deleteFromDatabase(myCubit.doneTasks[index].id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          child: Text(myCubit.doneTasks[index].taskTime),
                        ),
                        const SizedBox(width: 14,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(myCubit.doneTasks[index].taskTitle,style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                              const SizedBox(height: 3,),
                              Text(myCubit.doneTasks[index].taskDate,style: TextStyle(
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
                              myCubit.updateDatabase('archive',myCubit.doneTasks[index].id);
                            },
                            icon: const Icon(Icons.archive_outlined,color: Colors.black54)
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context,index)=>SizedBox(height: 1,child: Container(color: Colors.grey,),),
              itemCount: myCubit.doneTasks.length
          );
        }
    );
  }
}
