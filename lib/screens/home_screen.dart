import 'package:flutter/material.dart';
import 'package:to_do_lati/models/task_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskModel> tasks = [];
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            tasks.add(TaskModel(
                title: "Task ${tasks.length}",
                subtitle:
                    tasks.length.isOdd ? null : "Subtitle ${tasks.length}",
                createdAt: DateTime.now()));
          });
        },
      ),
      appBar: AppBar(
        title: const Text("TODO"),
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
                  )
                ]),
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
                          : ListTile(
                              tileColor: Colors.blue.withOpacity(0.1),
                              trailing: Checkbox(
                                value: tasks[index].isCompleted,
                                onChanged: (check) {
                                  setState(() {
                                    tasks[index].isCompleted = check!;
                                  });
                                },
                              ),
                              title: Text(tasks[index].title),
                              subtitle: tasks[index].subtitle != null
                                  ? Text(tasks[index].subtitle!)
                                  : null,
                            );
                    },
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return !tasks[index].isCompleted
                          ? const SizedBox()
                          : ListTile(
                              tileColor: Colors.blue.withOpacity(0.1),
                              trailing: Checkbox(
                                value: tasks[index].isCompleted,
                                onChanged: (check) {
                                  setState(() {
                                    tasks[index].isCompleted = check!;
                                  });
                                },
                              ),
                              title: Text(tasks[index].title),
                              subtitle: tasks[index].subtitle != null
                                  ? Text(tasks[index].subtitle!)
                                  : null,
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
