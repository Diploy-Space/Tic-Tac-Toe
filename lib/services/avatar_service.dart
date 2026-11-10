import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_repository.dart';

class AvatarService {
  AvatarService._();

  static const bucket = 'avatars';
  static const maxBytes = 2 * 1024 * 1024;

  static SupabaseClient get _client => Supabase.instance.client;
  static final _picker = ImagePicker();

  static String _objectPath(String uid) => '$uid/profile.jpg';

  /// Opens gallery; returns JPEG/PNG/WebP bytes or null if cancelled.
  static Future<Uint8List?> pickImageBytes({
    ImageSource source = ImageSource.gallery,
  }) async {
    final file = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    if (bytes.length > maxBytes) {
      throw Exception('Image must be under 2 MB');
    }
    return bytes;
  }

  static String _contentType(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'image/jpeg';
    }
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'image/png';
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46) {
      return 'image/webp';
    }
    return 'image/jpeg';
  }

  /// Upload/replace avatar at `avatars/{uid}/profile.jpg` and update profile row.
  static Future<String> uploadAndSet(Uint8List bytes) async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not signed in');
    if (bytes.length > maxBytes) {
      throw Exception('Image must be under 2 MB');
    }

    final path = _objectPath(uid);
    final contentType = _contentType(bytes);

    await _client.storage.from(bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: contentType,
            cacheControl: '3600',
          ),
        );

    final publicUrl = _client.storage.from(bucket).getPublicUrl(path);
    // Bust CDN/cache after replace.
    final busted = '$publicUrl?v=${DateTime.now().millisecondsSinceEpoch}';
    await ProfileRepository.updateAvatarUrl(busted);
    return busted;
  }

  static Future<void> deleteAvatar() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) throw Exception('Not signed in');
    final path = _objectPath(uid);
    try {
      await _client.storage.from(bucket).remove([path]);
    } catch (_) {
      // Object may already be gone; still clear DB.
    }
    await ProfileRepository.updateAvatarUrl(null);
  }
}
