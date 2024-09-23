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
                    icon: darkModeProvider.isDark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    text: darkModeProvider.isDark ? "Dark Mode" : "Light Mode",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                          darkModeProvider.isDark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: darkModeProvider.isDark
                              ? Colors.white
                              : Colors.black),
                      SizedBox(
                        width: 250,
                        child: SwitchListTile(
                          activeColor: darkModeProvider.isDark
                              ? Colors.white
                              : Colors.black,
                          title: Text(
                            darkModeProvider.isDark == true
                                ? "Dark Mode"
                                : "Light Mode",
                            style: TextStyle(
                                color: darkModeProvider.isDark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          value: darkModeProvider.isDark,
                          onChanged: (value) {
                            darkModeProvider.SwitchMode();
                          },
                        ),
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
            backgroundColor:
                darkModeProvider.isDark ? Colors.white : Colors.blue,
            child: Icon(Icons.add,
                color: darkModeProvider.isDark ? Colors.blue : Colors.white),
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
                TabBar(
                  labelColor:
                      darkModeProvider.isDark ? Colors.white : Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(text: "Pending Tasks"),
                    Tab(text: "Completed Tasks"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      buildTaskList(tasksProvider, false, darkModeProvider),
                      buildTaskList(tasksProvider, true, darkModeProvider),
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

  Widget buildTaskList(TasksProvider tasksProvider, bool isCompleted,
      DarkModeProvider darkModeProvider) {
    final filteredTasks = tasksProvider.tasks
        .where((task) => task.isCompleted == isCompleted)
        .toList();

    if (filteredTasks.isEmpty) {
      return Center(
        child: Text(
          "No tasks available.",
          style: TextStyle(
              color: darkModeProvider.isDark ? Colors.white : Colors.black),
        ),
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
