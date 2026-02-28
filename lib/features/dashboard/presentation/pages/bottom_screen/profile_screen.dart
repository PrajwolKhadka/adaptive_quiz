import 'dart:io';
import 'package:adaptive_quiz/core/api/api_endpoint.dart';
import 'package:adaptive_quiz/core/sensors/app_lock_service.dart';
import 'package:adaptive_quiz/core/sensors/biometric_service.dart';
import 'package:adaptive_quiz/features/dashboard/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _appLockEnabled = false;
  bool _biometricsAvailable = false;

  @override
  void initState() {
    super.initState();
    _loadAppLockState();
  }

  Future<void> _loadAppLockState() async {
    final enabled = await AppLockService.isEnabled();
    final available = await BiometricService.isAvailable();
    if (mounted) {
      setState(() {
        _appLockEnabled = enabled;
        _biometricsAvailable = available;
      });
    }
  }

  Future<void> _toggleAppLock(bool value) async {
    if (value) {
      // Require a successful biometric before enabling
      final authenticated = await BiometricService.authenticate();
      if (!authenticated) {
        if (mounted) {
          _showSnack(
            "Authentication failed. App lock not enabled.",
            const Color(0xFFEF4444),
          );
        }
        return;
      }
    }

    await AppLockService.setEnabled(value);
    if (mounted) {
      setState(() => _appLockEnabled = value);
      _showSnack(
        value ? "App lock enabled" : "App lock disabled",
        const Color(0xFF111827),
      );
    }
  }

  void _showSnack(String message, Color color) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF1D61E7), Color(0xFF88A4E0)],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: imageProvider,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20)),
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
                    child: Icon(Icons.edit, color: Color(0xFF1D61E7)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

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
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Upload Profile Picture",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

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
                crossAxisAlignment: CrossAxisAlignment.start,
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

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 18),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section label
                  const Text(
                    "SECURITY",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D61E7)
                              .withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.fingerprint_rounded,
                          color: Color(0xFF1D61E7),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Fingerprint App Lock",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _biometricsAvailable
                                  ? "Require fingerprint on resume"
                                  : "Not available on this device",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _appLockEnabled,
                        onChanged: _biometricsAvailable
                            ? _toggleAppLock
                            : null,
                        activeColor: const Color(0xFF1D61E7),
                      ),
                    ],
                  ),

                  // Info hint when enabled
                  if (_appLockEnabled) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1D61E7)
                            .withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 15, color: Color(0xFF1D61E7)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "App will prompt fingerprint every time you return from background.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1D61E7),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ref
                    .read(profileViewModelProvider.notifier)
                    .logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
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

            const SizedBox(height: 20),
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
