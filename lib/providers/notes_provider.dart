import 'package:flutter/foundation.dart';
import '../models/note_model.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

/// Not listesi ve SQLite işlemlerini yönetir.
class NotesProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Veritabanından tüm notları yükler.
  Future<void> loadNotes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notes = await _databaseService.getNotes();
    } catch (e) {
      _errorMessage = AppConstants.errorGeneral;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Yeni not ekler ve listeyi günceller.
  Future<bool> addNote(String content) async {
    if (content.trim().isEmpty) {
      _errorMessage = AppConstants.errorEmptyNote;
      notifyListeners();
      return false;
    }

    try {
      final note = NoteModel(
        content: content.trim(),
        createdAt: DateTime.now(),
      );
      await _databaseService.insertNote(note);
      await loadNotes();
      return true;
    } catch (e) {
      _errorMessage = AppConstants.errorGeneral;
      notifyListeners();
      return false;
    }
  }

  /// Notu siler ve listeyi günceller.
  Future<void> deleteNote(int id) async {
    try {
      await _databaseService.deleteNote(id);
      await loadNotes();
    } catch (e) {
      _errorMessage = AppConstants.errorGeneral;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
