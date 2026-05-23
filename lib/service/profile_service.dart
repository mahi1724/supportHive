import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_profile_model.dart';

class CloudinaryConfig {
  static const String cloudName = 'diyb2otzj';
  static const String uploadPreset = 'supporthive_profiles';
  static String get uploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
}

class ProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  String get _uid => _auth.currentUser?.uid ?? '';
  DocumentReference get _userDoc => _db.collection('users').doc(_uid);

  // ── CALL THIS RIGHT AFTER SIGN-IN / SIGN-UP ───────────────────────────────
  // Creates the Firestore document if it doesn't exist yet (new user),
  // or silently merges without overwriting existing data (returning user).
  // Returns the up-to-date profile model immediately — no waiting for stream.
  Future<UserProfileModel> createOrFetchProfile() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    final docSnap = await _userDoc.get();

    if (!docSnap.exists) {
      // ── NEW USER: create document from Firebase Auth data ─────────────────
      final data = <String, dynamic>{
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'phone': '',
        'photoUrl': user.photoURL ?? '',
        'bio': '',
        'sessions': 0,
        'podcastsListened': 0,
        'wellnessScore': '0%',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await _userDoc.set(data);
      return UserProfileModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        phone: '',
        photoUrl: user.photoURL ?? '',
      );
    } else {
      // ── EXISTING USER: keep email fresh ───────────────────────────────────
      final existingData = docSnap.data() as Map<String, dynamic>;
      if ((existingData['email'] as String? ?? '') != (user.email ?? '')) {
        await _userDoc.update({
          'email': user.email ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        });
        existingData['email'] = user.email ?? '';
      }
      return UserProfileModel.fromMap(user.uid, existingData);
    }
  }

  // ── Real-time profile stream ──────────────────────────────────────────────
  // Always call createOrFetchProfile() before using this stream so the doc
  // is guaranteed to exist and the stream never emits null.
  Stream<UserProfileModel?> profileStream() {
    if (_uid.isEmpty) return const Stream.empty();
    return _userDoc.snapshots().map((snap) {
      if (!snap.exists) return null;
      return UserProfileModel.fromMap(
          _uid, snap.data() as Map<String, dynamic>);
    });
  }

  // ── Pick image ────────────────────────────────────────────────────────────
  Future<File?> pickImage({bool fromCamera = false}) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );
      if (picked == null) return null;
      return File(picked.path);
    } catch (e) {
      debugPrint('pickImage error: $e');
      return null;
    }
  }

  // ── Upload photo to Cloudinary ────────────────────────────────────────────
  Future<String?> uploadProfilePhoto(File imageFile) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse(CloudinaryConfig.uploadUrl));
      request.fields['upload_preset'] = CloudinaryConfig.uploadPreset;
      request.fields['public_id'] = 'profile_photos/$_uid';
      request.fields['format'] = 'jpg';
      request.fields['quality'] = 'auto';
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final secureUrl = json['secure_url'] as String?;
        if (secureUrl != null && secureUrl.isNotEmpty) {
          await _userDoc.update({
            'photoUrl': secureUrl,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          await _auth.currentUser?.updatePhotoURL(secureUrl);
          return secureUrl;
        }
      }
      debugPrint(
          'Cloudinary upload failed: ${response.statusCode} ${response.body}');
      return null;
    } catch (e) {
      debugPrint('uploadProfilePhoto error: $e');
      return null;
    }
  }

  // ── Remove profile photo ──────────────────────────────────────────────────
  Future<void> removeProfilePhoto() async {
    try {
      await _userDoc.update({
        'photoUrl': '',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _auth.currentUser?.updatePhotoURL(null);
    } catch (e) {
      debugPrint('removeProfilePhoto error: $e');
    }
  }

  // ── Update profile fields ─────────────────────────────────────────────────
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String bio,
  }) async {
    await _userDoc.update({
      'name': name.trim(),
      'phone': phone.trim(),
      'bio': bio.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _auth.currentUser?.updateDisplayName(name.trim());
  }

  // ── Send password reset ───────────────────────────────────────────────────
  Future<void> sendPasswordReset() async {
    final email = _auth.currentUser?.email;
    if (email != null && email.isNotEmpty) {
      await _auth.sendPasswordResetEmail(email: email);
    }
  }

  // ── Sign out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async => await _auth.signOut();

  // ── Delete account ────────────────────────────────────────────────────────
  Future<void> deleteAccount() async {
    await _userDoc.delete();
    await _auth.currentUser?.delete();
  }
}