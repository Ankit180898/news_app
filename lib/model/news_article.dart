class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String? author;
  final String? content;
  final DateTime? publishedAt;
  final NewsSource source;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.source,
    this.author,
    this.content,
    this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? json['imageUrl'] ?? '',
      author: json['author'],
      content: json['content'],
      publishedAt: json['publishedAt'] != null 
          ? DateTime.parse(json['publishedAt'])
          : null,
      source: NewsSource.fromJson(json['source'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': imageUrl, 
      'imageUrl': imageUrl,   
      'author': author,
      'content': content,
      'publishedAt': publishedAt?.toIso8601String(),
      'source': source.toJson(), 
    };
  }
}

class NewsSource {
  final String? id;
  final String name;

  NewsSource({this.id, required this.name});

  factory NewsSource.fromJson(Map<String, dynamic> json) {
    return NewsSource(id: json['id'], name: json['name'] ?? 'Unknown Source');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}