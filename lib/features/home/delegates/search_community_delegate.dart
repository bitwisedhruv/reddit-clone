import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_screen.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.white), // Adjust as needed
          filled: true,
          fillColor: currentTheme.appBarTheme.backgroundColor, // Or your color
          border: InputBorder.none
          ),
      // Optional: Use textSelectionTheme for cursor color
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.white),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(searchCommunityProvider(query)).when(
          data: (communities) => ListView.builder(
            itemCount: communities.length,
            itemBuilder: (BuildContext context, int index) {
              final community = communities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.avatar),
                ),
                title: Text(
                  'r/${community.name}',
                  style: TextStyle(
                    color: currentTheme == Pallete.darkModeAppTheme
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                onTap: () => navigateToCommunity(context, community.name),
              );
            },
          ),
          error: (error, stackTrace) => ErrorScreen(
            data: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }
}
