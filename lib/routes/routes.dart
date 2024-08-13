import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:perfqse/Views/gestion/screen_gestion.dart';
import 'package:perfqse/Views/rapport/home_rapport.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Views/audit/audit_management/panneau_gestion/screen_admin.dart';
import '../Views/audit/gestion_audits/auditE/screen_gestions_audits.dart';
import '../Views/audit/gestion_audits/auditQ/screen_gestions_audits.dart';
import '../Views/audit/gestion_audits/auditQE/screen_gestions_audits.dart';
import '../Views/audit/gestion_audits/auditQS/screen_gestions_audits.dart';
import '../Views/audit/gestion_audits/auditQSE/screen_gestions_audits.dart';
import '../Views/audit/gestion_audits/auditS/screen_gestions_audits.dart';
import '../Views/audit/gestion_audits/auditSE/screen_gestions_audits.dart';
import '../Views/audit/overview/E/overview_evaluation_page.dart';
import '../Views/audit/overview/Q/overview_evaluation_page.dart';
import '../Views/audit/overview/QE/overview_evaluation_page.dart';
import '../Views/audit/overview/QS/overview_evaluation_page.dart';
import '../Views/audit/overview/QSE/all_list_evaluation/all_list_evaluation.dart';
import '../Views/audit/overview/QSE/overview_evaluation_page.dart';
import '../Views/audit/overview/S/overview_evaluation_page.dart';
import '../Views/audit/overview/SE/overview_evaluation_page.dart';
import '../Views/audit/screen_evaluation.dart';
import '../Views/audit/transiteAudit.dart';
import '../Views/common/error_page/page_not_found.dart';
import '../Views/common/forgot_password/forgot_password.dart';
import '../Views/common/login_page/login_page.dart';
import '../Views/common/main_page/common_home_page.dart';
import '../Views/common/reload_page/reload_page.dart';
import '../Views/gestion/contexte/screen_contexte.dart';
import '../Views/gestion/home_gestion.dart';
import '../Views/gestion/parties_interessees/screen_partie_interessees.dart';
import '../Views/gestion/perimetres_et_domaines_d_application/screen_perimetres_et_domaines_d_application.dart';
import '../Views/gestion/politique_qse/politique_qse.dart';
import '../Views/gestion/widgets/dashboard_gestion.dart';
import '../Views/pilotage/entity/admin/screen_admin_pilotage.dart';
import '../Views/pilotage/entity/entity_piloatage_main.dart';
import '../Views/pilotage/entity/overview/screen_overview_pilotage.dart';
import '../Views/pilotage/entity/performs/screen_pilotage_perform.dart';
import '../Views/pilotage/entity/profil/screen_pilotage_profil.dart';
import '../Views/pilotage/entity/suivi/screen_suivi_pilotage.dart';
import '../Views/pilotage/entity/support_client/screen_support_client.dart';
import '../Views/pilotage/entity/tableau_bord/indicateur_screen.dart';
import '../Views/pilotage/entity/tableau_bord/screen_tableau_bord_pilotage.dart';
import '../Views/pilotage/entity/tableau_bord/transite_tableau_bord.dart';
import '../Views/pilotage/entity/widgets/get_info_espace.dart';
import '../Views/pilotage/home/pilotage_home.dart';
import '../helpers/helper_methods.dart';
import '../widgets/loading_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class RouteClass {
  static final supabase = Supabase.instance.client;
  static final _espace=InfoEspace().getNameEspace();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: supabase.auth.currentSession != null ? "/" : "/account/login",
    errorBuilder: (context, state) {
      return PageNotFound();
    },
    routes: [
      GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const MainPage(),
          ),
      ),
      GoRoute(
        path: '/reload-page',
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          restorationId: state.pageKey.value,
          child: ReloadScreen(redirection: state.extra.toString(),),
        ),
      ),
      GoRoute(path: "/rapport",
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          restorationId: state.pageKey.value,
          child: const DrawerRapport(),
        ),
      ),
      GoRoute(
          path: '/pilotage',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const PilotageHome(),
          ),
          routes: [
            GoRoute(
                path: 'espace/Bouafle',
                name: "Bouaflé",
                pageBuilder: (context, state) => NoTransitionPage<void>(
                    key: state.pageKey,
                    restorationId: state.pageKey.value,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Center(
                        child: loadingPageWidget(),
                      ),
                    )//const PilotageEntiteOverview(urlPath: "profil"),
                ),
                routes:[
                  ShellRoute(
                    navigatorKey: _shellNavigatorKey,
                    builder: (BuildContext context, GoRouterState state, Widget child) {
                      return EntityPilotageMain(child: child);
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'accueil',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenOverviewPilotage()
                        ),
                      ),
                      GoRoute(path: 'tableau-de-bord',
                          pageBuilder: (context, state) => NoTransitionPage<void>(
                              key: state.pageKey,
                              child: const ScreenTableauBordPilotage(),),
                      routes:[
                      GoRoute(
                        path: 'transite-tableau-bord',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child:  NewTableauBord()
                        ),
                        routes: [
                          GoRoute(
                              path: 'indicateurs',
                              pageBuilder: (context, state) => NoTransitionPage<void>(
                                  key: state.pageKey,
                                  child: IndicateurScreen()
                              ),
                          )
                        ]
                      ),]),
                      GoRoute(
                        path: 'profil',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: ScreenPilotageProfil()
                        ),
                      ),
                      //
                      GoRoute(
                        path: 'performances',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenPilotagePerform()
                        ),
                      ),
                      GoRoute(
                        path: 'suivi-des-donnees',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenPilotageSuivi()
                        ),
                      ),
                      GoRoute(
                        path: 'admin',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenPilotageAdmin()
                        ),
                      ),
                      GoRoute(
                        path: 'support-client',
                        pageBuilder: (context, state) => NoTransitionPage<void>(
                            key: state.pageKey,
                            child: const ScreenSupportClient()
                        ),
                      )
                    ],
                  ),
                ]
            ),
          ]),

      // Routes pour la gestion du module Gestion

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScreenGestion(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/gestion/accueil',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const DashboardGestion()
            ),
          ),
          GoRoute(
            path: '/gestion/profil',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenPilotageProfil()
            ),
          ),
          GoRoute(
            path: '/gestion/contexte',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenContexte()
            ),
          ),
          GoRoute(
            path: '/gestion/partiesInteressees',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenPartieInteressees()
            ),
          ),
          GoRoute(
            path: '/gestion/perimetresEt/domaines/Dapplication',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenPerimetresEtDomainesDApplication()
            ),
          ),
          GoRoute(
            path: '/gestion/politiqueQSE',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: PolitiqueQse()
            ),
          ),
        ],
      ),


      // Les routes pour le module Audit

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return ScreenEvaluation(child: child);
        },
        routes: <RouteBase>[

          // Route du Dashboaord des Audits

          GoRoute(
            path: '/audit/transite',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const TransiteAudit()
            ),
          ),

          //Routes des pages d'aperçu des Audits

          // Pour les audits QSE
          GoRoute(
            path: '/audit/accueil',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const OverviewEvaluationPage()
            ),
          ),

          // Pour les audits Environnement (E)
          GoRoute(
            path: '/apercu/auditsE',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const OverviewEvaluationPageE()
            ),
          ),

          //Pour les audits Qualité (Q)
          GoRoute(
            path: '/apercu/auditsQ',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const OverviewEvaluationPageQ()
            ),
          ),

          //Pour les audits QE
          GoRoute(
            path: '/apercu/auditsQE',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const OverviewEvaluationPageQE()
            ),
          ),

          //Pour les audits QS
          GoRoute(
            path: '/apercu/auditsQS',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const OverviewEvaluationPageQS()
            ),
          ),

          //Pour les audits S
          GoRoute(
            path: '/apercu/auditsS',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const OverviewEvaluationPageS()
            ),
          ),

          //Pour les audits SE
          GoRoute(
            path: '/apercu/auditsSE',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const OverviewEvaluationPageSE()
            ),
          ),

          //Routes des pages d'affichage de la liste des audits.

          //Liste des audits Environnements
          GoRoute(
            path: '/audit/list-audits',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const AllListView()
            ),
          ),


          // Routes des pages d'édition d'audits

          GoRoute(
            path: '/audit/gestion-audits',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenGestionAudit()
            ),
          ),
          GoRoute(
            path: '/audit/gestion-auditsE',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenGestionAuditE()
            ),
          ),
          GoRoute(
            path: '/audit/gestion-auditsQ',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenGestionAuditQ()
            ),
          ),
          GoRoute(
            path: '/audit/gestion-auditsQE',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenGestionAuditQE()
            ),
          ),
          GoRoute(
            path: '/audit/gestion-auditsQS',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenGestionAuditQS()
            ),
          ),
          GoRoute(
            path: '/audit/gestion-auditsS',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenGestionAuditS()
            ),
          ),
          GoRoute(
            path: '/audit/gestion-auditsSE',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenGestionAuditSE()
            ),
          ),
          GoRoute(
            path: '/audit/admin',
            pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: ScreenAdmin()
            ),
          ),
        ],
      ),

      GoRoute(
          path: '/account/login',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const LoginPage(),
          )
      ),
      GoRoute(
          path: '/account/reset-password',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            restorationId: state.pageKey.value,
            child: const ResetPassword(),
          )
      ),
    ],
    redirect: (context ,state) async {

      if (state.fullPath!=null && state.fullPath =="/account/reset-password"){
        return null;
      }
      final storage = FlutterSecureStorage();
      String? loggedPref = await storage.read(key: 'logged');
      String? email = await storage.read(key: 'email');

      bool sessionVerification = false;
      final session = supabase.auth.currentSession;
      if (session != null) {
        sessionVerification = true;
      } else {
        sessionVerification = false;
      }
      if (loggedPref == "true" && email!=null && GetUtils.isEmail(email) && sessionVerification == true)//appVersionFlutter )
      {
        return null;
      }
      return "/account/login";
    },
  );

  static getAppVersion() async {
    final result = await supabase.from("System").select("app_version").eq("id", 0);
    return result[0]["app_version"];
  }
}
