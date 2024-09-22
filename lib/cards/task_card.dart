import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';
import 'package:to_do_lati/models/task_model.dart';
import 'package:to_do_lati/screens/task_details_screen.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.taskModel,
    required this.onTap,
    required this.delete,
  });

  final TaskModel taskModel;
  final Function onTap;
  final Function delete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return TaskDetailsScreen(taskModel: taskModel);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.blue[300],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: taskModel.isCompleted,
                      onChanged: (check) {
                        onTap();
                      },
                      activeColor: Colors.white,
                      checkColor: Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          taskModel.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (taskModel.subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              taskModel.subtitle!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          taskModel.isCompleted
                              ? DateFormat("EEE, dd MMM yyyy").format(
                                  DateTime.parse(
                                      taskModel.createdAt.toIso8601String()))
                              : format(taskModel.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    delete();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
