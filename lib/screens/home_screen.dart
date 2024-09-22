import 'package:flutter/material.dart';
import 'package:to_do_lati/cards/task_card.dart';
import 'package:to_do_lati/dialog/task_dialog.dart';
import 'package:to_do_lati/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskSubtitleController = TextEditingController();

  List<TaskModel> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
        child: const Icon(Icons.add,color: Colors.white,),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTaskDialog(
                titleController: taskTitleController,
                subTitleController: taskSubtitleController,
                formKey: formKey,
                onTap: () {
                  tasks.add(TaskModel(
                      title: taskTitleController.text,
                      subtitle: taskSubtitleController.text.isEmpty
                          ? null
                          : taskSubtitleController.text,
                      createdAt: DateTime.now()));

                  setState(() {});

                  taskTitleController.clear();
                  taskSubtitleController.clear();

                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
      appBar: AppBar(
        centerTitle :true,
        backgroundColor: Colors.blue,
        title: const Text("TODO",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),

        ),
        
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              isScrollable: false,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  text: "Waiting",
                ),
                Tab(
                  text: "Completed",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return tasks[index].isCompleted
                          ? const SizedBox()
                          : TaskCard(
                              taskModel: tasks[index],
                              onTap: () {
                                setState(() {
                                  tasks[index].isCompleted =
                                      !tasks[index].isCompleted;
                                });
                              },
                              delete: () {
                                setState(() {
                                  tasks.removeAt(index);
                                });
                              },
                            );
                    },
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return !tasks[index].isCompleted
                          ? const SizedBox()
                          : TaskCard(
                              taskModel: tasks[index],
                              onTap: () {
                                setState(() {
                                  tasks[index].isCompleted =
                                      !tasks[index].isCompleted;
                                });
                              },
                              delete: () {
                                setState(() {
                                  tasks.removeAt(index);
                                });
                              },
                            );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
