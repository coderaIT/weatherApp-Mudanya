/// SQLite notes tablosundaki bir satırı temsil eder.
class NoteModel {
  final int? id;
  final String content;
  final DateTime createdAt;

  NoteModel({
    this.id,
    required this.content,
    required this.createdAt,
  });

  /// Veritabanından okunan Map'i modele çevirir.
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  /// Veritabanına yazmak için Map oluşturur.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
