import 'package:flutter/material.dart';

class OngoingTask extends StatefulWidget {
  const OngoingTask({Key? key}) : super(key: key);

  @override
  State<OngoingTask> createState() => _OngoingTaskState();
}

class _OngoingTaskState extends State<OngoingTask>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
