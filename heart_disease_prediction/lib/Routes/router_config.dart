import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heart_disease_prediction/views/Dashboard/Subsections/consult_page.dart';
import 'package:heart_disease_prediction/views/Dashboard/Subsections/past_records.dart';
import 'package:heart_disease_prediction/views/Dashboard/Subsections/predict.dart';
import 'package:heart_disease_prediction/views/Dashboard/dashboard.dart';
import 'package:heart_disease_prediction/views/login.dart';

GlobalKey<NavigatorState> _shellNavigator1 = GlobalKey(debugLabel: 'shell1');
GlobalKey<NavigatorState> _shellNavigator2 = GlobalKey(debugLabel: 'shell2');
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _shellNavigator1,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'loginPage',
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: LoginPage());
        },
      ),
      ShellRoute(
          navigatorKey: _shellNavigator2,
          builder: (context, state, child) {
            return DashBoard(child: child);
          },
          routes: [
            GoRoute(
              path: '/dashBoard/predict',
              name: 'predict',
              pageBuilder: (context, state) {
                return NoTransitionPage(child: Predict(uri: state.uri));
              },
            ),
            GoRoute(
              path: '/dashBoard/pastRecords',
              name: 'pastRecords',
              pageBuilder: (context, state) {
                return NoTransitionPage(child: PastRecords(uri: state.uri));
              },
            ),
            GoRoute(
              path: '/dashBoard/consult',
              name: 'consult',
              pageBuilder: (context, state) {
                return NoTransitionPage(child: ConsultPage(uri: state.uri));
              },
            ),
          ]),
    ],
    redirect: (context, state) {
      bool isAuth = FirebaseAuth.instance.currentUser != null;
      if (!isAuth && state.fullPath != '/') {
        return '/';
      } else if (isAuth && state.fullPath == '/') {
        return '/dashBoard/predict';
      }
      return null;
    },
  );
});
