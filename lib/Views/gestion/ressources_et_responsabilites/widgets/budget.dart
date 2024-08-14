import 'package:flutter/material.dart';

class Budget extends StatefulWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Page du budget",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
