import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_lati/cards/task_card.dart';
import 'package:to_do_lati/clicables/drawer_tile.dart';
import 'package:to_do_lati/dialog/task_dialog.dart';
import 'package:to_do_lati/models/task_model.dart';
import 'package:to_do_lati/providers/dark_mode_provider.dart';
import 'package:to_do_lati/providers/tasks_provider.dart';
import 'package:to_do_lati/screens/task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskSubtitleController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<TasksProvider>(context, listen: false).getTasks();
    Provider.of<DarkModeProvider>(context, listen: false).getMode();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DarkModeProvider, TasksProvider>(
      builder: (context, darkModeProvider, tasksProvider, child) {
        return Scaffold(
          drawer: Drawer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  DrawerTile(
                    icon :darkModeProvider.isDark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                    Text: darkModeProvider.isDark == true
                                ? "Dark Mode"
                                : "Light Mode",
                    onTap: (){
                      darkModeProvider.SwitchMode();
                    },        
                  ),
                  Row(
                    children: [
                      Icon(
                        darkModeProvider.isDark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                      SizedBox(
                        width: 250,
                        child: SwitchListTile(
                            title: Text(darkModeProvider.isDark == true
                                ? "Dark Mode"
                                : "Light Mode"),
                            value: darkModeProvider.isDark,
                            onChanged: (value) {
                              darkModeProvider.SwitchMode();
                            },
                            activeColor: darkModeProvider.isDark == true
                                ? Colors.black
                                : Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: const Text(
              "TO DO Lati",
              style: TextStyle(color: Colors.white),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddTaskDialog(
                    titleController: taskTitleController,
                    subTitleController: taskSubtitleController,
                    formKey: formKey,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        Provider.of<TasksProvider>(context, listen: false)
                            .addTask(
                          TaskModel(
                            title: taskTitleController.text,
                            subtitle: taskSubtitleController.text.isEmpty
                                ? null
                                : taskSubtitleController.text,
                            createdAt: DateTime.now(),
                          ),
                        );
                        taskTitleController.clear();
                        taskSubtitleController.clear();
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              );
            },
          ),
          body: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: [
                    Tab(text: "Pending Tasks"),
                    Tab(text: "Completed Tasks"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      buildTaskList(tasksProvider, false),
                      buildTaskList(tasksProvider, true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTaskList(TasksProvider tasksProvider, bool isCompleted) {
    final filteredTasks = tasksProvider.tasks
        .where((task) => task.isCompleted == isCompleted)
        .toList();

    if (filteredTasks.isEmpty) {
      return const Center(
        child: Text("No tasks available."),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        return TaskCard(
          taskModel: filteredTasks[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(
                  taskModel: filteredTasks[index],
                ),
              ),
            );
          },
          onToggleComplete: () {
            Provider.of<TasksProvider>(context, listen: false)
                .switchValue(filteredTasks[index]);
          },
          delete: () {
            Provider.of<TasksProvider>(context, listen: false)
                .delete(filteredTasks[index]);
          },
        );
      },
    );
  }
}
