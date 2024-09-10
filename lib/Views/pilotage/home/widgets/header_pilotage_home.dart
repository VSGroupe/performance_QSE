import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/customtext.dart';
import '/views/common/main_page/widget/banniere.dart';
import 'listeProcessus.dart';


class HeaderPilotageHome extends StatefulWidget {
  const HeaderPilotageHome({Key? key}) : super(key: key);

  @override
  State<HeaderPilotageHome> createState() => _HeaderPilotageHomeState();
}

class _HeaderPilotageHomeState extends State<HeaderPilotageHome> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Padding(
              padding: EdgeInsets.all(0),
              child: RichText(text:TextSpan(
                  text:"PILOTAGE",style: TextStyle(fontSize: 50,color:Colors.black,fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text:" PERFORMANCE ",style: TextStyle(fontSize: 50,color:Color.fromRGBO(42,77,4,1),fontWeight: FontWeight.bold),),
                    TextSpan(text:" Q",style: TextStyle(fontSize: 50,color:Color.fromRGBO(172,28,12,1),fontWeight: FontWeight.bold),),
                    TextSpan(text:"S",style: TextStyle(fontSize: 50,color:Color.fromRGBO(206,131,0,1),fontWeight: FontWeight.bold),),
                    TextSpan(text:"E",style: TextStyle(fontSize: 50,color:Color.fromRGBO(42,77,4,1),fontWeight: FontWeight.bold),)
                  ]
              ),

              )
            ),

          ],
        ),
        //const SizedBox(height:15,),
        Container(
          width: 780,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  flex: 6,
                  child: Card(
                    elevation: 5,
                    child: Container(
                      height: 100,
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
                            'assets/images/banniereQSE.png',
                            fit: BoxFit.contain,
                          )),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}