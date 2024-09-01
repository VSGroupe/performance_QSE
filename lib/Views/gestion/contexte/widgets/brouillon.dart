// Future<void> _showAddEnjeuDialog(BuildContext context) async {
//   final TextEditingController _idEnjeuController = TextEditingController();
//   final TextEditingController _libelleController = TextEditingController();
//   String? _selectedAxeId;
//   String? _selectedType;
//   bool _idEnjeuExists = false;
//
//   // Méthode pour vérifier si l'id_enjeu existe déjà
//   Future<void> _checkIdEnjeuExists(String idEnjeu) async {
//     print('Vérification si l\'id_enjeu $idEnjeu existe déjà');
//     final response = await Supabase.instance.client
//         .from('EnjeuTable')
//         .select('id_enjeu')
//         .eq('id_enjeu', idEnjeu)
//         .execute();
//
//     if (response.data == null) {
//       print('Erreur lors de la vérification de l\'id enjeu: ${response.status}');
//       return;
//     }
//
//     _idEnjeuExists = response.data.isNotEmpty;
//     print('L\'ID de l\'enjeu existe déjà : $_idEnjeuExists');
//   }
//
//   // Méthode pour récupérer les axes disponibles
//   Future<List<Map<String, dynamic>>> _fetchAxes() async {
//     print('Récupération des axes disponibles');
//     final response = await Supabase.instance.client
//         .from('AxeTable')
//         .select('id_axe, libelle')
//         .execute();
//
//     if (response.data == null) {
//       print('Erreur lors de la récupération des axes: ${response.status}');
//       return [];
//     }
//
//     return List<Map<String, dynamic>>.from(response.data);
//   }
//
//   // Méthode pour ajouter l'enjeu
//   Future<void> _addEnjeu() async {
//     final idEnjeu = _idEnjeuController.text;
//     final libelle = _libelleController.text;
//     bool enjeuAdded = false;
//
//     print('Tentative d\'ajouter un enjeu avec ID: $idEnjeu, Libellé: $libelle, Axe: $_selectedAxeId, Type: $_selectedType');
//
//     // Vérifier si id_enjeu existe déjà
//     await _checkIdEnjeuExists(idEnjeu);
//
//     if (_idEnjeuExists) {
//       print('L\'ID de l\'enjeu existe déjà, ajout annulé.');
//       return; // Ne pas continuer si id_enjeu existe déjà
//     }
//
//     if (idEnjeu.isNotEmpty && libelle.isNotEmpty && _selectedAxeId != null && _selectedType != null) {
//       final response = await Supabase.instance.client
//           .from('EnjeuTable')
//           .insert({
//         'id_enjeu': idEnjeu,
//         'libelle': libelle,
//         'id_axe': _selectedAxeId,
//         'type_enjeu': _selectedType,
//       }).execute();
//
//       if (response.data == null) {
//         print('Enjeu ajouté avec succès: ${response.status}');
//         // Réinitialiser les contrôleurs et fermer le dialogue
//         _idEnjeuController.clear();
//         _libelleController.clear();
//         _selectedAxeId = null;
//         _selectedType = null;
//         setState(() {
//           print("Avant, enjeuAdded = : $enjeuAdded");
//           enjeuAdded = true;
//           print("Après, enjeuAdded = : $enjeuAdded");
//         });
//
//         if(enjeuAdded == true){
//           Navigator.of(context).pop(); // Ferme la boîte de dialogue
//           // setState(() {
//           //   print("Avant, enjeuAdded = : $enjeuAdded");
//           //   enjeuAdded = true;
//           //   print("Après, enjeuAdded = : $enjeuAdded");
//           // });
//         }
//       } else {
//         print('Erreur lors de l\'ajout de l\'enjeu: ${response.status}');
//       }
//     } else {
//       print('Certains champs sont vides ou non sélectionnés');
//     }
//   }
//
//   // Afficher le dialogue
//   await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return Dialog(
//             child: Container(
//               width: 800, // Ajuste la largeur en fonction de vos besoins
//               height: 400, // Hauteur fixe de la boîte de dialogue
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // En-tête de la boîte de dialogue
//                   Text(
//                     'Ajouter un Enjeu',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Contenu scrollable
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           TextField(
//                             controller: _idEnjeuController,
//                             decoration: InputDecoration(labelText: 'ID Enjeu'),
//                           ),
//                           TextField(
//                             controller: _libelleController,
//                             decoration: InputDecoration(labelText: 'Libellé'),
//                           ),
//                           FutureBuilder<List<Map<String, dynamic>>>(
//                             future: _fetchAxes(),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return CircularProgressIndicator();
//                               }
//                               final axes = snapshot.data!;
//                               return DropdownButton<String>(
//                                 hint: Text('Sélectionner un axe'),
//                                 value: _selectedAxeId,
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     _selectedAxeId = newValue!;
//                                   });
//                                 },
//                                 items: axes.map((axe) {
//                                   return DropdownMenuItem<String>(
//                                     value: axe['id_axe'],
//                                     child: Text('${axe['libelle']} (${axe['id_axe']})'),
//                                   );
//                                 }).toList(),
//                               );
//                             },
//                           ),
//                           DropdownButton<String>(
//                             hint: Text('Sélectionner un type'),
//                             value: _selectedType,
//                             onChanged: (newValue) {
//                               setState(() {
//                                 _selectedType = newValue!;
//                               });
//                             },
//                             items: ['interne', 'externe'].map((type) {
//                               return DropdownMenuItem<String>(
//                                 value: type,
//                                 child: Text(type),
//                               );
//                             }).toList(),
//                           ),
//                           const SizedBox(height: 16), // Ajoute de l'espace pour séparer les éléments
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   // Boutons fixes en bas de la boîte de dialogue
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop(); // Ferme la boîte de dialogue
//                         },
//                         child: Text('Annuler'),
//                       ),
//                       const SizedBox(width: 8),
//                       ElevatedButton(
//                         onPressed: () {
//                           _addEnjeu();
//                         },
//                         child: Text('Ajouter'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }