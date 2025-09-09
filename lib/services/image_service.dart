import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class ImageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload gambar ke Firebase Storage
  static Future<String?> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    required String folder,
  }) async {
    try {
      print('🔄 Uploading image: $fileName to folder: $folder');
      
      // Buat reference ke Firebase Storage
      final ref = _storage.ref().child('$folder/$fileName');
      
      // Upload file
      final uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploaded_by': 'admin_panel',
            'uploaded_at': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Tunggu upload selesai
      final snapshot = await uploadTask;
      
      // Dapatkan download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      print('✅ Image uploaded successfully: $downloadUrl');
      return downloadUrl;
      
    } catch (e) {
      print('❌ Error uploading image: $e');
      return null;
    }
  }

  /// Pilih gambar dari file system
  static Future<Map<String, dynamic>?> pickImage() async {
    try {
      print('🔍 Opening file picker for images...');
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        if (file.bytes != null) {
          print('✅ Image selected: ${file.name} (${file.size} bytes)');
          
          return {
            'name': file.name,
            'bytes': file.bytes!,
            'size': file.size,
            'extension': file.extension,
          };
        }
      }
      
      print('❌ No image selected');
      return null;
      
    } catch (e) {
      print('❌ Error picking image: $e');
      return null;
    }
  }

  /// Upload gambar berita
  static Future<String?> uploadNewsImage(Uint8List imageBytes, String originalName) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = originalName.split('.').last;
    final fileName = 'news_${timestamp}.$extension';
    
    return await uploadImage(
      imageBytes: imageBytes,
      fileName: fileName,
      folder: 'news_images',
    );
  }

  /// Hapus gambar dari Firebase Storage
  static Future<bool> deleteImage(String downloadUrl) async {
    try {
      print('🗑️ Deleting image: $downloadUrl');
      
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      
      print('✅ Image deleted successfully');
      return true;
      
    } catch (e) {
      print('❌ Error deleting image: $e');
      return false;
    }
  }

  /// Validasi ukuran file gambar (maksimal 5MB)
  static bool isValidImageSize(int sizeInBytes) {
    const maxSizeInBytes = 5 * 1024 * 1024; // 5MB
    return sizeInBytes <= maxSizeInBytes;
  }

  /// Validasi format file gambar
  static bool isValidImageFormat(String? extension) {
    if (extension == null) return false;
    
    const validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    return validExtensions.contains(extension.toLowerCase());
  }
}
