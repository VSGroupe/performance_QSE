import 'package:flutter/material.dart';

import '../../../constant/constants.dart';
import '../../../widget/button_header_progress.dart';

class BilanAuditQS extends StatefulWidget {
  const BilanAuditQS({super.key});

  @override
  State<BilanAuditQS> createState() => _BilanAuditQSState();
}

class _BilanAuditQSState extends State<BilanAuditQS> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ButtonProgress(backgroundColor:Colors.cyan,text:"Resultat de l'audit",),
                SizedBox(width: 7,),
                ButtonProgress( backgroundColor: unselectColor,text:"Plan d'action",),
                SizedBox(width: 7,),
                ButtonProgress( backgroundColor: unselectColor,text:"Recommendation",),
                SizedBox(width: 7,),
                ButtonProgress(backgroundColor: unselectColor,text:"Rapport",),
              ],
            ),
          ),
          SizedBox(height: 12,),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(right:12.0,bottom: 13),
            child: Container(
              color: Colors.grey,
            ),
          ))
        ],
      ),
    ));
  }
}
