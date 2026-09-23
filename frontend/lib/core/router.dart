import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/learn/learn_screen.dart';
import '../features/safety/safety_screen.dart';
import '../safety/alert_overlay.dart';
import 'theme.dart';

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
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
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

class _Shell extends StatelessWidget {
  const _Shell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 900;
        final body = Stack(
          children: [
            navigationShell,
            const AlertOverlay(),
          ],
        );

        if (useRail) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: navigationShell.goBranch,
                  leading: const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 28),
                    child: _CatMark(),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.grid_view_rounded),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.radar_rounded),
                      label: Text('Safety'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school_rounded),
                      label: Text('Learn'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            ),
          );
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.grid_view_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.radar_rounded),
                label: 'Safety',
              ),
              NavigationDestination(
                icon: Icon(Icons.school_rounded),
                label: 'Learn',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CatMark extends StatelessWidget {
  const _CatMark();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'CAT Operator Copilot',
      child: SizedBox(
        width: 52,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              'CAT',
              style: TextStyle(
                color: CatTheme.textPrimary,
                fontSize: 19,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            Positioned(
              bottom: 1,
              child: CustomPaint(
                size: const Size(24, 7),
                painter: _CatWedgePainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatWedgePainter extends CustomPainter {
  const _CatWedgePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = CatTheme.yellow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
