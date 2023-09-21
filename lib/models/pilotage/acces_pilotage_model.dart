import 'dart:convert';

class AccesPilotageModel {
  String? email;
  bool? estSpectateur;
  bool? estCollecteur;
  bool? estValidateur;
  bool? estAdmin;
  bool? estBloque;
  int? niveauAdmin;
  List<dynamic>? espace;

  AccesPilotageModel({
    this.email,
    this.estSpectateur,
    this.estCollecteur,
    this.estValidateur,
    this.estAdmin,
    this.estBloque,
    this.niveauAdmin,
    this.espace,
  });

  factory AccesPilotageModel.fromRawJson(String str) => AccesPilotageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccesPilotageModel.fromJson(Map<dynamic, dynamic> json) => AccesPilotageModel(
    email: json["email"],
    estSpectateur: json["est_spectateur"],
    estCollecteur: json["est_collecteur"],
    estValidateur: json["est_validateur"],
    estAdmin: json["est_admin"],
    estBloque: json["est_bloque"],
    niveauAdmin: json["niveau_admin"],
    espace: List<dynamic>.from(json["espace"].map((x) => x)
    ),
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "est_spectateur": estSpectateur,
    "est_collecteur": estCollecteur,
    "est_validateur": estValidateur,
    "est_admin": estAdmin,
    "est_bloque": estBloque,
    "niveau_admin": niveauAdmin,
    "restrictions": espace,
  };
}