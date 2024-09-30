import 'package:flutter/material.dart';

class WidgetReserve3 extends StatefulWidget {
  const WidgetReserve3({Key? key}) : super(key: key);

  @override
  State<WidgetReserve3> createState() => _WidgetReserve3State();
}

class _WidgetReserve3State extends State<WidgetReserve3> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Widget réserve 3",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
