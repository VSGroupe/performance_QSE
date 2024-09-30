// import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';
// import 'customtext.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:http/http.dart' as http;
//
// class CopyRight extends StatefulWidget {
//   const CopyRight({Key? key}) : super(key: key);
//
//   @override
//   State<CopyRight> createState() => _CopyRightState();
// }
//
// class _CopyRightState extends State<CopyRight> {
//
//   bool isConnected = true ;
//
//   @override
//   void initState() {
//     //getInternetStatus();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Container(
//       height: MediaQuery.of(context).size.width < 850 ? 50:40,
//       decoration: BoxDecoration(
//         color: const Color(0xFF6E4906),
//         border: Border.all(color: Colors.black, width: 1.0),
//       ),
//       // child: MediaQuery.of(context).size.width < 850 ?
//       //     Column(
//       //       crossAxisAlignment: CrossAxisAlignment.center,
//       //       children: [
//       //         Padding(
//       //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       //           child: InkWell(
//       //             onTap: () async {
//       //               const url = "https://visionstrategie.com/";
//       //               final uri = Uri.parse(url);
//       //               if (await canLaunchUrl(uri)) {
//       //                 await launchUrl(uri);
//       //               }
//       //               else {
//       //                 throw "Could not launch $url";
//       //               }
//       //             },
//       //             child: const CustomText(
//       //               text: "Copyright @ Vision & Strategie Groupe",
//       //               size: 15,
//       //               weight: FontWeight.bold,
//       //               color: Colors.white,
//       //             ),
//       //           ),
//       //         ),
//       //         Padding(
//       //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       //           child: RichText(
//       //             text: TextSpan(
//       //               text: "Status : ",
//       //               children: [
//       //                 TextSpan(
//       //                     text: isConnected ? "Connecté" : "Aucune connection internet" ,
//       //                     style: TextStyle(color: isConnected ? Colors.green: Colors.red))
//       //               ],
//       //               style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),
//       //             ),
//       //           ),
//       //         )
//       //       ],
//       //     ) :
//       child:Expanded(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: InkWell(
//                 onTap: () async {
//                   // const url = "https://visionstrategie.com/";
//                   // final uri = Uri.parse(url);
//                   // if (await canLaunchUrl(uri)) {
//                   //   await launchUrl(uri);
//                   // }
//                   // else {
//                   //   throw "Could not launch $url";
//                   // }
//                 },
//                 child: const CustomText(
//                     text: "Copyright @ Vision & Strategie Groupe",
//                    size: 15,
//                   weight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             Expanded(child: Container()),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: RichText(
//                 text: TextSpan(
//                   text: "Statut : ",
//                   children: [
//                     TextSpan(
//                         text: isConnected ? "Connecté" : "Aucune connection internet" ,
//                         style: TextStyle(color: isConnected ? Colors.green: Colors.red))
//                   ],
//                   style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//   //  _showDialog(){
//   //   return showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return Dialog(
//   //             shape:RoundedRectangleBorder(
//   //               borderRadius: BorderRadius.circular(30),
//   //             ),
//   //             child:Container(
//   //               height: 450,
//   //               width: 350,
//   //               child:Column(
//   //                 children: [
//   //                   Center(
//   //                     child: Icon(Icons.wifi_off_sharp,size: 150,),
//   //                   ),
//   //                   SizedBox(height: 10,),
//   //                   Text("Vérifié votre connection et réssayer",textAlign: TextAlign.center,style: TextStyle(fontSize:30,color:Colors.black),),
//   //                   SizedBox(height:80,),
//   //                   SizedBox(
//   //                     height: 90,
//   //                     width: 300,
//   //                     child: OutlinedButton(onPressed:(){
//   //                         Navigator.pop(context);
//   //                     }, style:OutlinedButton.styleFrom(
//   //                       backgroundColor: Colors.green,
//   //                       shape: RoundedRectangleBorder(
//   //                         borderRadius: BorderRadius.circular(20)
//   //                       )
//   //                     ),
//   //                         child:Text("Réssayer",style: TextStyle(fontSize:20,color:Colors.white),)),
//   //                   )
//   //                 ],
//   //               )
//   //             )
//   //         );
//   //       }
//   //
//   //   );
//   // }
//   // void  getInternetStatus() async {
//   //   while (true) {
//   //     try {
//   //       var response = await http.get(Uri.parse('https://performance-qse.web.app'),headers: {
//   //         "Access-Control-Allow-Origin":"*"
//   //       });
//   //       if (response.statusCode == 200) {
//   //         setState(() {
//   //           isConnected = true;
//   //         });
//   //       }
//   //     } catch (e){
//   //       setState(() {
//   //         print(e.toString());
//   //        //_showDialog();
//   //         isConnected = false;
//   //       });
//   //     }
//   //     await Future.delayed(Duration(seconds: 10));
//   //   }
//   // }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CopyRight extends StatefulWidget {
  const CopyRight({super.key});

  @override
  State<CopyRight> createState() => _CopyRightState();
}

class _CopyRightState extends State<CopyRight> {
  bool isConnected=true;

  @override
  void initState() {
    super.initState();
    stateConnection();
  }

  //Fonction de vérificatoin de l'état de connexion de l'utilisateur courant
  void stateConnection(){
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      isConnected = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width < 850 ? 50:40,
      decoration: BoxDecoration(
        color: const Color(0xFF6E4906),
        border: Border.all(color: Colors.black, width: 1.0),
      ),
      child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: InkWell(
                  onTap: () async {
                    // const url = "https://visionstrategie.com/";
                    // final uri = Uri.parse(url);
                    // if (await canLaunchUrl(uri)) {
                    //   await launchUrl(uri);
                    // }
                    // else {
                    //   throw "Could not launch $url";
                    // }
                  },
                  child: const Text(
                      "Copyright @ Vision & Strategie Groupe",style:TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )

                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: RichText(
                  text: TextSpan(
                    text: "Statut : ",
                    children: [
                      TextSpan(
                          text: isConnected ? "Connecté" : "Déconnecté" ,
                          style: TextStyle(color: isConnected ? Colors.green: Colors.red))
                    ],
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}
