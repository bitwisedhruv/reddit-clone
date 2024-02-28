import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_screen.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';
// import 'package:reddit/theme/pallete.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 250,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            user.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding:
                              const EdgeInsets.all(20).copyWith(bottom: 70),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 45,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(20),
                          child: OutlinedButton(
                            onPressed: () => navigateToEditProfile(context),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                            ),
                            child: const Text(
                              'Edit profile',
                            ),
                          ),
                        )
                      ],
                    ),
                    // actions: [
                    //   GestureDetector(
                    //     child: const CircleAvatar(
                    //       backgroundColor: Pallete.drawerColor,
                    //       child: Icon(
                    //         Icons.search,
                    //       ),
                    //     ),
                    //   ),
                    //   const SizedBox(
                    //     width: 20,
                    //   ),
                    //   GestureDetector(
                    //     child: const CircleAvatar(
                    //       backgroundColor: Pallete.drawerColor,
                    //       child: Icon(
                    //         Icons.search,
                    //       ),
                    //     ),
                    //   ),
                    //   const SizedBox(
                    //     width: 20,
                    //   ),
                    //   GestureDetector(
                    //     child: const CircleAvatar(
                    //       backgroundColor: Pallete.drawerColor,
                    //       child: Icon(
                    //         Icons.search,
                    //       ),
                    //     ),
                    //   ),
                    //   const SizedBox(
                    //     width: 20,
                    //   ),
                    // ],
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'u/${user.name}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: Text(
                              '${user.karma} karma',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: const Text(
                'data',
              ),
            ),
            error: (error, stackTrace) => ErrorScreen(data: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}