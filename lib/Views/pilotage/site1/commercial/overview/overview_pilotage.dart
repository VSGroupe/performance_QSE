import 'package:flutter/material.dart';
import '../../../../../constants/colors.dart';
import '../../../../../models/pilotage/indicateur_row_model.dart';
import 'widgets/suivi_details/collecte_globale_filiale.dart';
import 'widgets/suivi_details/section_suivi.dart';
import 'widgets/contributeur/liste_contributeur.dart';

class OverviewPilotage extends StatelessWidget {
  final List<IndicateurRowTableauBordModel> indicateurRowTableauBord;
  const OverviewPilotage({super.key, required this.indicateurRowTableauBord});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         SectionSuivi(indicateurRowTableauBord:indicateurRowTableauBord),
        SizedBox(height: defaultPadding),
             Row(
             children: [
            ListeContributeur(),
             const SizedBox(width: defaultPadding),
             Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CollecteGlobale()
            ],),],),
        const SizedBox(width: defaultPadding),
      ],
    );
  }
}
