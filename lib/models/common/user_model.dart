import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  String email;
  String? nom;
  String? titre;
  String? prenom;
  String? accesPilotage;
  String? accesEvaluation;
  String? fonction;
  String? entreprise;
  String? langue;
  String? adresse;
  List<dynamic>? ref;
  String? ville;
  String? pays;
  String? numero;
  String? photoProfil;
  String? tokenCode;
  DateTime? expirationTime;

  UserModel({
    required this.email,
    this.nom,
    this.prenom,
    this.accesPilotage,
    this.accesEvaluation,
    this.fonction,
    this.titre,
    this.entreprise,
    this.langue,
    this.adresse,
    this.ville,
    this.ref,
    this.pays,
    this.numero,
    this.photoProfil,
    this.tokenCode,
    this.expirationTime,
  });

  factory UserModel.init() => UserModel(email: "");

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));


  factory UserModel.fromJson(Map<dynamic, dynamic> json) => UserModel(
    email: json["email"],
    nom: json["nom"],
    titre: json["titre"],
    prenom: json["prenom"],
    accesPilotage: json["acces_pilotage"],
    accesEvaluation: json["acces_evaluation"],
    fonction: json["fonction"],
    entreprise: json["entreprise"],
    langue: json["langue"],
    adresse: json["adresse"],
    ville: json["ville"],
    pays: json["pays"],
    numero: json["numero"],
    photoProfil: json["photo_profil"],
    tokenCode: json["token_code"],
    expirationTime: json["expiration_time"],
    ref:List<dynamic>.from(json["reference"].map((x) => x)),
  );
}