import 'package:flutter/material.dart';
import 'package:to_do_lati/models/task_model.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key, required this.taskModel});
  final TaskModel taskModel;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Task Details"),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 150,
                width: double.infinity,
              ),
              Text(
                "Title : ${widget.taskModel.title}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              if (widget.taskModel.subtitle != null)
                Text("Description : ${widget.taskModel.subtitle}"),
              Icon(
                widget.taskModel.isCompleted ? Icons.check : Icons.close,
                color: widget.taskModel.isCompleted ? Colors.green : Colors.red,
                size: 200,
              ),
              Text(
                "Created At : ${widget.taskModel.createdAt.toString().substring(0, 10).replaceAll("-", "/")}",
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(
                height: 150,
              ),
            ]));
  }
}
