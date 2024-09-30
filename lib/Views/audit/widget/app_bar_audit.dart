import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBarEvaluation extends StatefulWidget {

  const AppBarEvaluation({Key? key}) : super(key: key);

  @override
  State<AppBarEvaluation> createState() => _AppBarEvaluationState();
}

class _AppBarEvaluationState extends State<AppBarEvaluation> {

  late final SupabaseClient _supabaseClient;
  late String _userEmail = 'No email available';
  late String _nom = "Aucun nom";
  late String _prenoms = "Aucun prénom";


  @override
  void initState() {
    super.initState();
    _supabaseClient = Supabase.instance.client;
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final user = _supabaseClient.auth.currentUser;
    if (user != null) {
      _userEmail = user.email ?? 'No email available';

      final response = await _supabaseClient
          .from('Users')
          .select('prenom, nom')
          .eq('email', _userEmail)
          .single()
          .execute();
      if (response.data == null) {
        // Gérer les erreurs ici
        print('Error fetching user profile: ${response.data!.message}');
        setState(() {
          _nom = 'Error First Name';
          _prenoms = 'Error Laste Name';
        });
      } else {
        final data = response.data as Map<String, dynamic>;
        setState(() {
          _nom = data['nom'] ?? 'Aucun nom';
          _prenoms = data['prenom'] ?? 'Aucun prenom';
        });
      };
    } else {
      // Gérer le cas où l'utilisateur n'est pas authentifié
      setState(() {
        _userEmail = 'No email available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      return Container(
        height: 50,
        color: Color.fromRGBO(170, 160, 150,1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // const SizedBox(
                //   width: 17,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Image.asset(
                //     "assets/logos/Logo_perfQSE.png",
                //     height: 50,
                //   ),
                // ),
                const SizedBox(
                  width: 20,
                ),
                Text("Accueil Général Audit QSE",
                    style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    )
                )
              ],
            ),
            Row(
              children: [
                Row(
                  children: [
                    Center(
                      child: Text("${_prenoms} ${_nom}",style:TextStyle(
                        fontSize: 18,fontWeight: FontWeight.bold,
                        color:Colors.white,
                      )),
                    ),
                    SizedBox(width: 7,),
                    CircleAvatar(
                        backgroundColor: Colors.yellowAccent,
                        child: Center(
                          child: Text(
                            "${_prenoms[0]}${_nom[0]}",style: TextStyle(
                            color:Color(0xFFF1CD0B),
                            fontWeight: FontWeight.bold,
                          fontSize: 20,
                          )),
                        ),
                      ),

                  ],
                ),
                const SizedBox(width: 25,),
                IconButton(
                  icon:Icon(Icons.add_alert_outlined,size:38,color:Colors.white),
                  onPressed: (){

                  },
                )
              ],
            )
          ],
        ),
      );
  }
}
