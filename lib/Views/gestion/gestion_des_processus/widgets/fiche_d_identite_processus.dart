import 'package:flutter/material.dart';

class FicheDIdentiteProcessus extends StatefulWidget {
  const FicheDIdentiteProcessus({Key? key}) : super(key: key);

  @override
  State<FicheDIdentiteProcessus> createState() => _FicheDIdentiteProcessusState();
}

class _FicheDIdentiteProcessusState extends State<FicheDIdentiteProcessus> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Color(0xFF7FC01E),
            child: const SizedBox(
              width: 50,
              height: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("F", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("O", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("U", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("R", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("N", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("I", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("E", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("U", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("R", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10,),

          Container(
            color: Colors.blueGrey,
            child: SizedBox(
              width: 800,
              height: double.maxFinite,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    color: Colors.orange,
                    height: 180,
                    width: double.maxFinite,
                    child: Row(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    color: Colors.white,
                    height: 100,
                    width: double.maxFinite,
                    child: Row(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    color: Colors.green,
                    height: 180,
                    width: double.maxFinite,
                    child: Row(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10,),

          Container(
            color: Color(0xFF7FC01E),
            child: const SizedBox(
              width: 50,
              height: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("C", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("L", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("I", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("E", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("N", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("T", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
