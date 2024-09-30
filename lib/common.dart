import 'package:supabase_flutter/supabase_flutter.dart';
late final SupabaseClient supabase;

const String baseUrl = "http://localhost:5000"; // API python flask (hébergé: "https://api-performance-qse.onrender.com")

String Site = "";
String Processus = "";


Future<String> getCurrentSite() async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user != null) {
    final userEmail = user.email ?? 'No email available';
    try {
      print('Début de la requête pour l\'utilisateur $userEmail');
      final response = await Supabase.instance.client
          .from('Users')
          .select('domaine_clique')
          .eq('email', userEmail)
          .single()
          .execute();

      final data = response.data;

      if (data == null || data['domaine_clique'] == null) {
        print('Votre domaine cliqué n\'est pas spécifié dans la base de données');
        throw Exception('Domaine cliqué non spécifié.');
      }

      String espaceAcces = data['domaine_clique'] ?? '';

      print('Domaine cliqué: $espaceAcces');
      return espaceAcces;

    } catch (e) {
      print('Exception lors de la requête: $e');
      throw Exception('Erreur lors de la récupération du domaine cliqué.');
    }
  } else {
    print('Utilisateur non authentifié.');
    throw Exception('Utilisateur non authentifié.');
  }
}


// Fonction pour récupérer le nombre d'indicateurs par Axe (libelle)
Future<int> getNombreIndicateursParAxe(String axe) async {
  try {
    // Récupérer l'id_axe correspondant au libelle de l'axe
    final axeResponse = await supabase
        .from('AxeTable')
        .select('id_axe')
        .eq('libelle', axe)
        .single();

    if (axeResponse.error != null || axeResponse.data == null) {
      throw Exception("Axe non trouvé");
    }

    final idAxe = axeResponse.data['id_axe'];

    // Récupérer les id_enjeu associés à cet axe
    final enjeuxResponse = await supabase
        .from('EnjeuTable')
        .select('id_enjeu')
        .eq('id_axe', idAxe);

    if (enjeuxResponse.error != null || enjeuxResponse.data == null) {
      throw Exception("Enjeux non trouvés pour cet axe");
    }

    final enjeuxIds = (enjeuxResponse.data as List)
        .map((e) => e['id_enjeu'])
        .toList();

    if (enjeuxIds.isEmpty) {
      return 0; // Aucun indicateur trouvé pour cet axe
    }

    // Compter le nombre d'indicateurs liés aux enjeux de cet axe
    final indicateursResponse = await supabase
        .from('IndicateurTable')
        .select('numero') // On ne sélectionne rien de spécifique, juste les numéros
        .in_('enjeux', enjeuxIds);

    if (indicateursResponse.error != null || indicateursResponse.data == null) {
      throw Exception("Erreur lors de la récupération des indicateurs");
    }

    // Retourner le nombre d'indicateurs trouvés
    return (indicateursResponse.data as List).length;
  } catch (e) {
    print("Erreur: $e");
    return 0;
  }
}



Future<void> updateProcessusClique(String processusClique) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user != null) {
    final _userEmail = user.email ?? 'No email available';
    try {
      print('Mise à jour du domaine cliqué pour $_userEmail');
      final response = await Supabase.instance.client
          .from('AccesPilotage')
          .update({'processus_clique': processusClique})
          .eq('email', _userEmail)
          .execute();

      Processus = processusClique;
    } catch (e) {
      print('Exception lors de la mise à jour de processus_clique: $e\n');
    }
  }
}


Future<String> getProcessusClique() async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user != null) {
    final _userEmail = user.email ?? 'No email available';
    try {
      print('Récupération du processus cliqué pour $_userEmail');
      final response = await Supabase.instance.client
          .from('AccesPilotage')
          .select('processus_clique')
          .eq('email', _userEmail)
          .single()
          .execute();

      if (response.data == null) {
        print('Erreur lors de la récupération : ${response.status}');
        throw Exception('Erreur lors de la récupération du processus cliqué');
      } else {
        final processusClique = response.data['processus_clique'] as String?;
        if (processusClique == null) {
          throw Exception('Le champ "processus_clique" est vide');
        }
        return processusClique;
      }
    } catch (e) {
      print('Exception lors de la récupération : $e');
      throw Exception('Erreur lors de la récupération : $e');
    }
  } else {
    throw Exception('Utilisateur non connecté');
  }
}



// class Common {
//   // Singleton pattern for easy global access
//   static final Common _instance = Common._internal();
//
//   factory Common() {
//     return _instance;
//   }
//
//   Common._internal();
//
//   // Methods
//   Future<void> initializeVariables(Function setStateCallback) async {
//     await _getCurrentSite(setStateCallback);
//   }
//
//   Future<void> _getCurrentSite(Function setStateCallback) async {
//     final user = Supabase.instance.client.auth.currentUser;
//     if (user != null) {
//       final userEmail = user.email ?? 'No email available';
//       try {
//         print('Début de la requête pour l\'utilisateur $userEmail');
//         final response = await Supabase.instance.client
//             .from('Users')
//             .select('domaine_clique')
//             .eq('email', userEmail)
//             .single()
//             .execute();
//
//         final data = response.data;
//
//         if (data == null || data['domaine_clique'] == null) {
//           print('Votre domaine cliqué n\'est pas spécifié dans la base de données');
//           return;
//         }
//
//         String espaceAcces = data['domaine_clique'] ?? '';
//
//         // Use setState to update the UI and mySite variable
//         setStateCallback(() {
//           Site = espaceAcces;  // Assign to mySite
//         });
//
//         print('Domaine cliqué: $espaceAcces');
//
//       } catch (e) {
//         print('Exception lors de la requête: $e');
//       }
//     } else {
//       print('Utilisateur non authentifié.');
//     }
//   }
// }
