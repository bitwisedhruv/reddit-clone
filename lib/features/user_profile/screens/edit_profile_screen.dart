import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/common/error_screen.dart';
import 'package:reddit/core/common/loader.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/utils.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/responsive/responsive.dart';
import 'package:reddit/theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectAvatarImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          avatar: profileFile,
          banner: bannerFile,
          context: context,
          name: nameController.text.trim(),
          avatarWeb: profileWebFile,
          bannerWeb: bannerWebFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) {
            return Scaffold(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: const Text('Edit profile'),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: save,
                    child: const Text(
                      "Save",
                    ),
                  ),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Responsive(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: selectBannerImage,
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(10),
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      color: currentTheme
                                          .textTheme.bodyMedium!.color!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: bannerWebFile != null
                                            ? Image.memory(bannerWebFile!)
                                            : bannerFile != null
                                                ? Image.file(bannerFile!)
                                                : user.banner.isEmpty ||
                                                        user.banner ==
                                                            Constants
                                                                .bannerDefault
                                                    ? const Center(
                                                        child: Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: 40,
                                                        ),
                                                      )
                                                    : Image.network(user.banner),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: GestureDetector(
                                      onTap: selectAvatarImage,
                                      child: profileWebFile != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  MemoryImage(profileWebFile!),
                                              radius: 32,
                                            )
                                          : profileFile != null
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      FileImage(profileFile!),
                                                  radius: 32,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      user.profilePic),
                                                  radius: 32,
                                                ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                filled: true,
                                hintText: 'Name',
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(18),
                              ),
                            )
                          ],
                        ),
                      ),
                  ),
            );
          },
          error: (error, stackTrace) => ErrorScreen(
            data: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
