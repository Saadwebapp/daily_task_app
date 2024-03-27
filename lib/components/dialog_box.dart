import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoapp_codesoft/components/my_buttons.dart';

class DialogBox extends StatefulWidget {
  final titleController;
  final descController;
  final String value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  final Function(String)
      onPrioritySelected; // Add callback for selected priority

  DialogBox({
    Key? key,
    required this.titleController,
    required this.descController,
    required this.onSave,
    required this.onCancel,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.onPrioritySelected,
  }) : super(key: key);

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue = widget.items.first;
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Add a new task"),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: TextField(
                controller: widget.titleController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "Title"),
              ),
            ),
            TextField(
              controller: widget.descController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Description..."),
            ),

            //drop down button for priority
            Text("Select priority"),
            DropdownButton<String>(
              value: widget.value,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  print(dropdownValue);
                  dropdownValue = value!;
                  // Call the callback function with the selected priority value
                  widget.onPrioritySelected.call(dropdownValue);
                  
                });
              },
              items: widget.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            //buttons -> save + cancel

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //save button
                MyButtons(text: "Save", onPressed: widget.onSave),
                Gap(5),
                //cancel button
                MyButtons(text: "Cancel", onPressed: widget.onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
