var filliale = [

  {
    "commune":"Bouafle",
  },
  {
    "commune":"Sicodis",
  },
  {
    "commune":"Trechville",
  },
  {
    "commune":"Yopougon ZI"
  },
  {
    "commune":"Yopougon TR"
  },
  {
    "commune":"Yopougon LBI"
  },

];

var processTrans=[
  {
  "name":"Processus ACHAT",
  "prefix":"PA"
  },
  {
  "name":"Processus RH",
  "prefix":"PR"
  },
  {
  "name":"Processus QSE",
  "prefix":"PQ"
  },
  {
  "name":"Processus MI(Consolidé)",
  "prefix":"PM"
  },
];

var processGene=[
  {
    "name":"Processus COM",
    "prefix":"PC"
  },
  {
    "name":"Processus DAP",
    "prefix":"PD"
  },
  {
    "name":"Processus RE",
    "prefix":"PR"
  },
  {
    "name":"Processus SI",
    "prefix":"PS"
  },
  {
    "name":"Processus MG",
    "prefix":"PM"
  },
];


// ListView.builder(
// scrollDirection: Axis.vertical,
// itemCount:filliale.length,
// itemBuilder: (BuildContext context, int index) {
// return TextButton.icon(
// icon:CircleAvatar(
// radius: 15,
// child:Text(filliale[index]["prefix"]!),
// ) ,
// onPressed: () {  },
// label: Text(filliale[index]["name"]!),
// );
// },
// ),