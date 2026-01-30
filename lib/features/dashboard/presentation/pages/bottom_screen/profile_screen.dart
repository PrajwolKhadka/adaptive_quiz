import 'dart:io';
import 'package:adaptive_quiz/core/api/api_endpoint.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_viewmodel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);

    ImageProvider imageProvider;

    if (state.localImagePath != null) {
      imageProvider = FileImage(File(state.localImagePath!));
    } else if (state.imageUrl != null) {
      imageProvider = NetworkImage(
        "${ApiEndpoints.baseUrl.replaceAll('/api/', '')}${state.imageUrl}",
      );
    } else {
      imageProvider = const AssetImage("assets/image/logo.png");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF1D61E7),
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar with Camera/Gallery
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: imageProvider,
                ),
                Positioned(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text("Camera"),
                              onTap: () {
                                Navigator.pop(context);
                                ref.read(profileViewModelProvider.notifier).pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text("Gallery"),
                              onTap: () {
                                Navigator.pop(context);
                                ref.read(profileViewModelProvider.notifier).pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Upload button if image is picked
            if (state.localImagePath != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isLoading? null : () {
                    ref.read(profileViewModelProvider.notifier).uploadProfilePicture();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D61E7),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Upload Profile Picture",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Full Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 4),
                  Text(state.fullName ?? "", style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 12),
                  Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 4),
                  Text(state.email ?? "", style: const TextStyle(fontSize: 16)),

                  const SizedBox(height: 12),
                  Text(
                    "Class",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 4),
                  Text(state.className ?? "", style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(profileViewModelProvider.notifier).logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
