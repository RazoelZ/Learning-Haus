class Books {
  final int id;
  final String author;
  final String title;
  final String publisher;

  Books({
    required this.id,
    required this.author,
    required this.title,
    required this.publisher,
  });

  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
      id: json['id'],
      author: json['author'],
      title: json['title'],
      publisher: json['publisher'],
    );
  }
}
