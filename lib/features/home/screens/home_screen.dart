import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/home/delegates/search_community_delegate.dart';
import 'package:reddit/features/home/drawers/community_list_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => displayDrawer(context),
              child: const Icon(
                Icons.menu,
              ),
            );
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showSearch(
                context: context,
                delegate: SearchCommunityDelegate(ref),
              );
            },
            child: const Icon(
              Icons.search,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                user.profilePic,
              ),
              radius: 15,
            ),
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
    );
  }
}
