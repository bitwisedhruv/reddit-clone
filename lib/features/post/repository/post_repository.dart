import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit/core/constants/firebase_constants.dart';
import 'package:reddit/core/failure.dart';
import 'package:reddit/core/providers/firebase_provider.dart';
import 'package:reddit/core/typedefs.dart';
import 'package:reddit/models/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(
      firestoreProvider,
    ),
  );
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid addPosts(Post post) async {
    try {
      return right(
        _posts.doc(post.id).set(
              post.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }
}