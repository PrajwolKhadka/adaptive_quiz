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
appBar: AppBar(
title: const Text('Profile'),
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

// Avatar
Stack(
alignment: Alignment.bottomRight,
children: [
CircleAvatar(
radius: 60,
backgroundImage: imageProvider,
),
InkWell(
onTap: () {
showModalBottomSheet(
context: context,
builder: (_) => Wrap(
children: [
ListTile(
leading: const Icon(Icons.camera_alt),
title: const Text('Camera'),
onTap: () {
Navigator.pop(context);
ref
    .read(profileViewModelProvider.notifier)
    .pickImage(ImageSource.camera);
},
),
ListTile(
leading: const Icon(Icons.photo_library),
title: const Text('Gallery'),
onTap: () {
Navigator.pop(context);
ref
    .read(profileViewModelProvider.notifier)
    .pickImage(ImageSource.gallery);
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
],
),

const SizedBox(height: 20),

// Upload button
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
padding: const EdgeInsets.symmetric(vertical: 14),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: const Text(
'Upload Profile Picture',
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
boxShadow: const [
BoxShadow(
color: Colors.black12,
blurRadius: 8,
offset: Offset(0, 4),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_infoRow('Full Name', state.fullName ?? ''),
const SizedBox(height: 12),
_infoRow('Email', state.email ?? ''),
const SizedBox(height: 12),
_infoRow(
'Class',
state.className != null
? 'Class ${state.className}'
    : '',
),
],
),
),

const SizedBox(height: 40),

// Logout
SizedBox(
width: double.infinity,
child: ElevatedButton(
onPressed: () => ref
    .read(profileViewModelProvider.notifier)
    .logout(context),
style: ElevatedButton.styleFrom(
backgroundColor: Colors.redAccent,
padding: const EdgeInsets.symmetric(vertical: 14),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: const Text(
'Logout',
style: TextStyle(fontSize: 16, color: Colors.white),
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
style: TextStyle(
fontWeight: FontWeight.bold,
fontSize: 16,
color: Colors.grey[800],
),
),
const SizedBox(height: 4),
Text(value, style: const TextStyle(fontSize: 16)),
],
);
}
}