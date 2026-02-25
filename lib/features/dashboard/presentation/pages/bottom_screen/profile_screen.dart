import 'dart:io';
import 'package:adaptive_quiz/core/api/api_endpoint.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_provider.dart';
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
      final url = state.imageUrl!.startsWith('http')
          ? state.imageUrl!
          : '${ApiEndpoints.serverUrl}${state.imageUrl}';
      imageProvider = NetworkImage(url);
    } else {
      imageProvider = const AssetImage('assets/image/logo.png');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),

      // ───────────────── AppBar ─────────────────
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1D61E7),
      ),

      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ───────────────── Avatar Section ─────────────────
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1D61E7),
                        Color(0xFF88A4E0),
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: imageProvider,
                  ),
                ),

                // Edit Button
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (_) => Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text("Camera"),
                            onTap: () {
                              Navigator.pop(context);
                              ref
                                  .read(profileViewModelProvider
                                  .notifier)
                                  .pickImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading:
                            const Icon(Icons.photo_library),
                            title: const Text("Gallery"),
                            onTap: () {
                              Navigator.pop(context);
                              ref
                                  .read(profileViewModelProvider
                                  .notifier)
                                  .pickImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit,
                        color: Color(0xFF1D61E7)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ───────────────── Upload Button ─────────────────
            if (state.localImagePath != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () => ref
                      .read(profileViewModelProvider.notifier)
                      .uploadProfilePicture(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D61E7),
                    padding:
                    const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Upload Profile Picture",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // ───────────────── Info Card ─────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _infoRow("Full Name", state.fullName ?? ""),
                  const Divider(height: 24),
                  _infoRow("Email", state.email ?? ""),
                  const Divider(height: 24),
                  _infoRow(
                    "Class",
                    state.className != null
                        ? "Class ${state.className}"
                        : "",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ───────────────── Logout Button ─────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ref
                    .read(profileViewModelProvider.notifier)
                    .logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value.isEmpty ? "Not Set" : value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}