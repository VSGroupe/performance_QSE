import 'package:supabase_flutter/supabase_flutter.dart';


// Récupération des processus Support
Future<List<Map<String, String>>> getSupportProcessus() async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('Processus')
      .select('libelle_processus')
      .eq('type_processus', 'Support')
      .order('libelle_processus', ascending: true)
      .execute();

  if (response.data == null) {
    print('Erreur lors de la récupération des processus: ${response.data!.message}');
    return [];
  }

  final filliale = (response.data as List<dynamic>)
      .map((item) => {'support': item['libelle_processus'] as String})
      .toList();

  return filliale;
}

// Récupération des processus Management
Future<List<Map<String, String>>> getManagementProcessus() async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('Processus')
      .select('libelle_processus')
      .eq('type_processus', 'Management')
      .order('libelle_processus', ascending: true)
      .execute();

  if (response.data == null) {
    print('Erreur lors de la récupération des processus: ${response.data!.message}');
    return [];
  }

  final managementProcess = (response.data as List<dynamic>)
      .map((item) => {'management': item['libelle_processus'] as String})
      .toList();

  return managementProcess;
}


// Récupération des processus Operationnels
Future<List<Map<String, String>>> getOperationnelsProcessus() async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('Processus')
      .select('libelle_processus')
      .eq('type_processus', 'Operationnels')
      .order('libelle_processus', ascending: true)
      .execute();

  if (response.data == null) {
    print('Erreur lors de la récupération des processus: ${response.data!.message}');
    return [];
  }

  final operationnelsProcess = (response.data as List<dynamic>)
      .map((item) => {'operationnels': item['libelle_processus'] as String})
      .toList();

  return operationnelsProcess;
}