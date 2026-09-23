import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/learn/learn_screen.dart';
import '../features/safety/safety_screen.dart';
import '../safety/alert_overlay.dart';
import '../safety/alert_providers.dart';
import '../safety/latency_debug_overlay.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _Shell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/safety',
              builder: (context, state) => const SafetyScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learn',
              builder: (context, state) => const LearnScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class _Shell extends ConsumerWidget {
  const _Shell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showLatency = ref.watch(latencyOverlayVisibleProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Main page content.
          navigationShell,

          // Always-mounted alert overlay (toggles its own visibility).
          const AlertOverlay(),

          // Debug latency overlay — bottom-left, toggled by FAB.
          if (showLatency)
            const Positioned(
              left: 8,
              bottom: 8,
              child: LatencyDebugOverlay(),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ask Copilot',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Safety',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Learn',
          ),
        ],
      ),
      // Debug FAB to toggle the latency overlay.
      floatingActionButton: kDebugMode
          ? FloatingActionButton.small(
              heroTag: 'latency_toggle',
              tooltip: 'Toggle latency overlay',
              backgroundColor: showLatency ? Colors.greenAccent : Colors.white24,
              onPressed: () {
                ref.read(latencyOverlayVisibleProvider.notifier).state =
                    !showLatency;
              },
              child: const Icon(Icons.speed, size: 20),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}
