import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/error_widget.dart';
import '../widgets/gradient_background.dart';
import '../widgets/loading_widget.dart';

/// Notlar — hava ile ilgili kişisel notları SQLite'da saklar.
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _noteController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR');

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    final provider = context.read<NotesProvider>();
    final success = await provider.addNote(_noteController.text);
    if (success && mounted) {
      _noteController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not başarıyla eklendi.'),
          backgroundColor: Color(0xFF3949AB),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Consumer<NotesProvider>(
          builder: (context, provider, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Text(
                    'Notlar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 3,
                    style: const TextStyle(color: Color(0xFF1A237E)),
                    decoration: InputDecoration(
                      hintText:
                          'Örn: Bugün koşu yapmak için uygun bir hava var.',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.95),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    text: 'Not Ekle',
                    icon: Icons.note_add,
                    isLoading: provider.isLoading,
                    onPressed: _addNote,
                  ),
                ),
                if (provider.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  ErrorDisplayWidget(
                    message: provider.errorMessage!,
                    onRetry: () {
                      provider.clearError();
                      provider.loadNotes();
                    },
                  ),
                ],
                const SizedBox(height: 16),
                Expanded(
                  child: provider.isLoading && provider.notes.isEmpty
                      ? const LoadingWidget(message: 'Notlar yükleniyor...')
                      : provider.notes.isEmpty
                          ? const Center(
                              child: Text(
                                'Henüz not yok.\nYukarıdan yeni not ekleyebilirsiniz.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              itemCount: provider.notes.length,
                              itemBuilder: (context, index) {
                                final note = provider.notes[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  color: Colors.white.withValues(alpha: 0.92),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    title: Text(
                                      note.content,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF1A237E),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        _dateFormat.format(note.createdAt),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red.shade400,
                                      ),
                                      onPressed: () {
                                        if (note.id != null) {
                                          provider.deleteNote(note.id!);
                                        }
                                      },
                                      tooltip: 'Notu sil',
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
