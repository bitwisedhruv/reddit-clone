// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderators tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.add_moderator,
              color: Colors.white,
            ),
            title: const Text(
              'Add moderators',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            title: const Text(
              'Edit Community',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => navigateToEditCommunity(context),
          ),
        ],
      ),
    );
  }
}
