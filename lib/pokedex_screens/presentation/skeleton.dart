import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_application/auth/application/auth_provider.dart';
import 'package:pokedex_application/pokedex_screens/presentation/Pages/get_page.dart';
import 'package:pokedex_application/pokedex_screens/presentation/Pages/post_page.dart';
import 'package:pokedex_application/pokedex_screens/presentation/shared/presentation_provider.dart';

class Skeleton extends ConsumerStatefulWidget {
  const Skeleton({super.key});

  @override
  ConsumerState<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends ConsumerState<Skeleton> {
  List pages = [GetPage(), const PostPage()];
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(pageNumber);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Pokedex'),
      //   actions: [
      //     IconButton(
      //       onPressed: () async {
      //         await ref.read(authNotifierProvider.notifier).signOut();
      //       },
      //       icon: const Icon(Icons.logout),
      //       tooltip: 'Log out',
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,

        onPressed: () async {
          await ref.read(authNotifierProvider.notifier).signOut();
        },
        child: const Icon(Icons.logout, color: Colors.white),
      ),
      body: pages.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.redAccent,
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(pageNumber.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.white), label: 'Get'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add, color: Colors.white), label: 'Post'),
        ],
      ),
    );
  }
}
