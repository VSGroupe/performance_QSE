import 'package:flutter/material.dart';

class CartographieProcessus extends StatefulWidget {
  const CartographieProcessus({Key? key}) : super(key: key);

  @override
  State<CartographieProcessus> createState() => _CartographieProcessusState();
}

class _CartographieProcessusState extends State<CartographieProcessus> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Cartographie générale des processus",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
