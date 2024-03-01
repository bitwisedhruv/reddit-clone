import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  final String name;
  const ModToolsScreen({
    super.key,
    required this.name,
  });

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  void navigateToAddMod(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderators tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.add_moderator,
              color: currentTheme == Pallete.darkModeAppTheme
                  ? Colors.white
                  : Colors.black,
            ),
            title: Text(
              'Add moderators',
              style: TextStyle(
                color: currentTheme == Pallete.darkModeAppTheme
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            onTap: () => navigateToAddMod(context),
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: currentTheme == Pallete.darkModeAppTheme
                  ? Colors.white
                  : Colors.black,
            ),
            title: Text(
              'Edit Community',
              style: TextStyle(
                color: currentTheme == Pallete.darkModeAppTheme
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            onTap: () => navigateToEditCommunity(context),
          ),
        ],
      ),
    );
  }
}
