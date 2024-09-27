import 'package:supabase_flutter/supabase_flutter.dart';

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


class Common {
  // Singleton pattern for easy global access
  static final Common _instance = Common._internal();

  factory Common() {
    return _instance;
  }

  Common._internal();

  // Methods
  Future<void> initializeVariables(Function setStateCallback) async {
    await _getCurrentSite(setStateCallback);
  }

  Future<void> _getCurrentSite(Function setStateCallback) async {
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
          return;
        }

        String espaceAcces = data['domaine_clique'] ?? '';

        // Use setState to update the UI and mySite variable
        setStateCallback(() {
          Site = espaceAcces;  // Assign to mySite
        });

        print('Domaine cliqué: $espaceAcces');

      } catch (e) {
        print('Exception lors de la requête: $e');
      }
    } else {
      print('Utilisateur non authentifié.');
    }
  }
}
