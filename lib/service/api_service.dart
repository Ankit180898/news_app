import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/model/news_article.dart';

class ApiService {
  static const String _apiKey = 'e2b638bc58794be8b94b80ac8071d6d4';
  static const String _topHeadlinesUrl = 'https://newsapi.org/v2/top-headlines?country=us';
  static const String _everythingUrl = 'https://newsapi.org/v2/everything';

  Future<List<NewsArticle>> fetchNews({String? category, String? query}) async {
    String url;

    if (query != null && query.isNotEmpty) {
      url = '$_everythingUrl?q=$query&sortBy=publishedAt&apiKey=$_apiKey';
    } else if (category != null) {
      url = '$_topHeadlinesUrl&category=$category&apiKey=$_apiKey';
    } else {
      url = '$_topHeadlinesUrl&apiKey=$_apiKey';
    }

    try {
      debugPrint('Fetching news from: $url');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<NewsArticle>.from(
          data['articles'].map((article) => NewsArticle.fromJson(article)),
        );
      } else {
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  Future<List<NewsArticle>> fetchHeadlines() async {
    final url = '$_topHeadlinesUrl&pageSize=5&apiKey=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<NewsArticle>.from(
          data['articles'].map((article) => NewsArticle.fromJson(article)),
        );
      } else {
        throw Exception('Failed to fetch headlines: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching headlines: $e');
    }
  }
}
