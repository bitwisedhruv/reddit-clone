import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_screen.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/sign_in_button.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    bool isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? const SignInButton()
                : ListTile(
                    title: Text(
                      'Create a community',
                      style: TextStyle(
                        color: currentTheme == Pallete.darkModeAppTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    leading: Icon(
                      Icons.add,
                      color: currentTheme == Pallete.darkModeAppTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                    onTap: () => navigateToCreateCommunity(context),
                  ),
            if (!isGuest)
              ref.watch(userCommunitiesProvider).when(
                    data: (data) => Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final community = data[index];
                          return ListTile(
                            title: Text(
                              'r/${community.name}',
                              style: TextStyle(
                                color: currentTheme == Pallete.darkModeAppTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(community.avatar),
                              radius: 15,
                            ),
                            onTap: () =>
                                navigateToCommunity(context, community),
                          );
                        },
                      ),
                    ),
                    error: (error, stackTrace) => ErrorScreen(
                      data: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
          ],
        ),
      ),
    );
  }
}
