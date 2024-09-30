import 'package:supabase_flutter/supabase_flutter.dart';

// Récupération des processus Support par Site

Future<List<Map<String, String>>> getSupportProcessus(String site) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('Processus')
      .select('libelle_processus')
      .eq('type_processus', 'Support')
      .contains('sites', [site])
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


// Récupération des processus Management par Site
Future<List<Map<String, String>>> getManagementProcessus(String site) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('Processus')
      .select('libelle_processus')
      .eq('type_processus', 'Management')
      .contains('sites', [site])
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


// Récupération des processus Operationnels par Site
Future<List<Map<String, String>>> getOperationnelsProcessus(String site) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('Processus')
      .select('libelle_processus')
      .eq('type_processus', 'Operationnels')
      .contains('sites', [site])
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