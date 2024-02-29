import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_screen.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/common/post_card.dart';
import 'package:reddit/features/post/controller/post_controller.dart';
import 'package:reddit/features/post/widgets/comment_card.dart';
import 'package:reddit/models/post_model.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void addComment(Post post) {
    ref.watch(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  TextField(
                    onSubmitted: (val) => addComment(data),
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ref.watch(getUserCommentsProvider(widget.postId)).when(
                        data: (comments) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                final comment = comments[index];
                                return CommentCard(comment: comment);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorScreen(data: error.toString()),
                        loading: () => const Loader(),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorScreen(data: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
