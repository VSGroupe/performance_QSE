import 'package:flutter/material.dart';

class Banniere extends StatelessWidget {
  const Banniere({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 4,
        child: Card(
          elevation:1,
          child: Container(
            height: 220,
            width: 1200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 6),
                    color: Colors.green.withOpacity(.1),
                    blurRadius: 12)
              ],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  'assets/images/Banière_Performance_QSE.png',
                  fit: BoxFit.contain,
                )),
          ),
        ));

  }
}