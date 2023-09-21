import 'dart:convert';

class IndicateurModel {
  int idIndicateur;
  var axe;
  var enjeu; 
  var critereNormatif;
  var intitule;
  var unite;
  var type;
  var definition;

  IndicateurModel({
    required this.idIndicateur,
    required this.axe,
    required this.enjeu,
    required this.critereNormatif,
    required this.intitule,
    required this.unite,
    required this.type,
    required this.definition,
  });

  factory IndicateurModel.fromRawJson(String str) => IndicateurModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndicateurModel.fromJson(Map<String, dynamic> json) => IndicateurModel(
    idIndicateur: json["numero"],
    axe: json["axe"],
    enjeu: json["enjeu"],
    critereNormatif: json["critereNormatif"],
    intitule: json["intitule"],
    unite: json["unite"],
    type: json["type"],
    definition: json["definition"],
  );

  Map<String, dynamic> toJson() => {
    "numero": idIndicateur,
    "axe": axe,
    "enjeu": enjeu,
    "critereNormatif": critereNormatif,
    "intitule": intitule,
    "unite": unite,
    "type": type,
    "definition": definition,
  };
}

class Aout {
  int? value;
  int? isValidate;

  Aout({
    required this.value,
    required this.isValidate,
  });

  factory Aout.fromRawJson(String str) => Aout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Aout.fromJson(Map<String, dynamic> json) => Aout(
    value: json["value"],
    isValidate: json["isValidate"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "isValidate": isValidate,
  };
}
