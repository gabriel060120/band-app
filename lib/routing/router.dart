import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../routing/feature_module.dart';

GoRouter buildRouter(List<FeatureModule> modules) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      ShellRoute(
        builder: (_, __, child) => child,
        routes: modules.expand((m) => m.routes()).toList(),
      ),
      GoRoute(path: '/404', builder: (_, __) => const _NotFound()),
    ],
    errorBuilder: (_, __) => const _NotFound(),
  );
}

class _NotFound extends StatelessWidget {
  const _NotFound();
  @override
  Widget build(BuildContext context) => const Center(child: Text('404'));
}
