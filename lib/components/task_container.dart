import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTasks extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final String taskDescription;
  final Function(bool?) onChanged;
  final Function(BuildContext)? deleteFunction;
  final Function(BuildContext)? updateFunction;
  final String priority;

  const ToDoTasks({
    Key? key,
    required this.taskName,
    required this.taskCompleted,
    required this.taskDescription,
    required this.onChanged,
    required this.deleteFunction,
    required this.updateFunction,
    required this.priority, // Accept priority parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color containerColor;
    if (priority == 'Low') {
      containerColor = Colors.green.shade400; // Set color for Low priority
    } else if (priority == 'Medium') {
      containerColor = Colors.orange.shade400; // Set color for Medium priority
    } else {
      containerColor = Colors.red.shade400; // Set color for High priority
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Slidable(
        startActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: updateFunction,
              icon: Icons.edit,
              backgroundColor: containerColor, // Use priority-based color
              borderRadius: BorderRadius.circular(15),
            )
          ],
        ),
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: containerColor, // Use priority-based color
            borderRadius: BorderRadius.circular(15),
          )
        ]),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: containerColor, // Use priority-based color
            border: Border.all(
              color: Colors.grey,
            ), // Add border for visual separation
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Checkbox(
              activeColor: Colors.black,
              value: taskCompleted,
              onChanged: onChanged,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  taskName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: taskCompleted ? FontWeight.bold : FontWeight.bold,
                    decoration: taskCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: Colors.black, // Set text color to white for contrast
                  ),
                ),
                Text(
                  "$priority",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black, // Set text color to white for contrast
                  ),
                ),
              ],
            ),
            subtitle: Text(
              taskDescription,
              maxLines: 2, // Limit the number of lines for description
              overflow: TextOverflow.ellipsis, // Handle overflow
              style: TextStyle(
                color: Colors.black,
              ), // Set text color to white for contrast
            ),
          ),
        ),
      ),
    );
  }
}
