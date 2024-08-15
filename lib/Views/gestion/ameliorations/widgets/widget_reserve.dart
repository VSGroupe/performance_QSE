import 'package:flutter/material.dart';

class WidgetReserve extends StatefulWidget {
  const WidgetReserve({Key? key}) : super(key: key);

  @override
  State<WidgetReserve> createState() => _WidgetReserveState();
}

class _WidgetReserveState extends State<WidgetReserve> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Widget réserve",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
