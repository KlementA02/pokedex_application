import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/providers.dart';


class UserActivityDetector extends ConsumerWidget {
  final Widget child;

  const UserActivityDetector({super.key, required this.child});

  void _onActivity(WidgetRef ref) {
    ref.read(sessionTimeoutProvider.notifier).resetTimer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _onActivity(ref),
      onPanDown: (_) => _onActivity(ref),
      //onScroll: (_) => _onActivity(ref), //TODO: implement an onScroll functionality as well by wrapping the widget with a scrollable
      child: Listener(
        onPointerDown: (_) => _onActivity(ref),
        child: child,
      ),
    );
  }
}