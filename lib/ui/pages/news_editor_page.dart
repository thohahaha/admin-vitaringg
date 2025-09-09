import 'package:flutter/material.dart';
import '../admin_scaffold.dart';

class NewsEditorPage extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String? imageUrl;
  final void Function()? onPickImage;
  final void Function()? onSave;
  final bool isLoading;

  const NewsEditorPage({
    super.key,
    required this.titleController,
    required this.contentController,
    this.imageUrl,
    this.onPickImage,
    this.onSave,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Editor Berita',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul Berita'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 8,
              decoration: const InputDecoration(labelText: 'Isi Berita'),
            ),
            const SizedBox(height: 16),
            if (imageUrl != null)
              Image.network(imageUrl!, height: 120),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Upload Gambar'),
              onPressed: onPickImage,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onSave,
                child: isLoading ? const CircularProgressIndicator() : const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
