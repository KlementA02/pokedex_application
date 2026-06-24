import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:innox/auth/shared/providers.dart';

import '../domain/user_activity_detector.dart';
import '../presentation/widget/lock_screen_overlay.dart';

@RoutePage(name: 'AppShellRoute')
class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = ref.watch(sessionTimeoutProvider);

    return UserActivityDetector(
      child: Stack(
        children: [
          const AutoRouter(),
          if (isLocked) const LockScreenOverlay(),
        ],
      ),
    );
  }
}