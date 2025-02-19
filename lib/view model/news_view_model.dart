import 'dart:convert';
import 'package:get/get.dart';
import 'package:news_app/model/news_article.dart';
import 'package:news_app/repository/news_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

enum SortOption { newest, oldest, title, popularity }

class NewsViewModel extends GetxController {
  final NewsRepository newsRepository;

  NewsViewModel(this.newsRepository);

  var articles = <NewsArticle>[].obs;
  var headlines = <NewsArticle>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;

  final RxList<String> selectedTopics = <String>[].obs;
  final Rx<SortOption> currentSortOption = SortOption.newest.obs;
  final RxList<NewsArticle> bookmarkedArticles = <NewsArticle>[].obs;
  final RxBool isSearching = false.obs;

  static const String _bookmarksKey = 'bookmarked_articles';

  @override
  void onInit() {
    super.onInit();
    fetchNews();
    fetchHeadlines();
    loadBookmarks();
  }

  Future<void> fetchHeadlines() async {
    try {
      final fetchedHeadlines = await newsRepository.getHeadlines();
      headlines.value = fetchedHeadlines;
    } catch (e) {
      debugPrint('Error fetching headlines: $e');
    }
  }

  Future<void> fetchNews({String? category, String? query}) async {
    try {
      isLoading(true);
      final fetchedNews = await newsRepository.getNews(
        category: category,
        query: query,
      );
      articles.value = fetchedNews;
      _sortArticles();
    } catch (e) {
      debugPrint('Error fetching news: $e');
    } finally {
      isLoading(false);
    }
  }

  void toggleTopic(String topic) {
    if (selectedTopics.contains(topic)) {
      selectedTopics.remove(topic);
      fetchNews(); 
    } else {
      selectedTopics.clear();
      selectedTopics.add(topic);
      fetchNews(category: topic.toLowerCase()); 
    }
  }

  void searchArticles(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    fetchNews(query: query);
  }

  void setSortOption(SortOption option) {
    currentSortOption.value = option;
    _sortArticles();
  }

  void _sortArticles() {
    switch (currentSortOption.value) {
      case SortOption.newest:
        articles.sort(
          (a, b) => (b.publishedAt ?? DateTime(1900)).compareTo(
            a.publishedAt ?? DateTime(1900),
          ),
        );
        break;
      case SortOption.oldest:
        articles.sort(
          (a, b) => (a.publishedAt ?? DateTime(1900)).compareTo(
            b.publishedAt ?? DateTime(1900),
          ),
        );
        break;
      case SortOption.title:
        articles.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.popularity:
        articles.sort((a, b) => a.source.name.compareTo(b.source.name));
        break;
    }
    articles.refresh();
  }

  Future<void> saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson =
          bookmarkedArticles.map((article) {
            final json = article.toJson();
            debugPrint(
              'Saving article with image: ${json['imageUrl']}',
            ); // Debug log
            return jsonEncode(json);
          }).toList();
      await prefs.setStringList(_bookmarksKey, bookmarksJson);
    } catch (e) {
      debugPrint('Error saving bookmarks: $e');
    }
  }

  Future<void> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = prefs.getStringList(_bookmarksKey) ?? [];
      bookmarkedArticles.value =
          bookmarksJson.map((json) {
            final decoded = jsonDecode(json);
            debugPrint(
              'Loading article with image: ${decoded['imageUrl']}',
            ); // Debug log
            return NewsArticle.fromJson(decoded);
          }).toList();
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    }
  }

  void toggleBookmark(NewsArticle article) {
    if (isBookmarked(article)) {
      removeBookmark(article);
    } else {
      addBookmark(article);
    }
    saveBookmarks();
  }

  void addBookmark(NewsArticle article) {
    if (!isBookmarked(article)) {
      bookmarkedArticles.add(article);
      saveBookmarks();
      Get.snackbar(
        'Bookmarked',
        'Article added to bookmarks',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  void removeBookmark(NewsArticle article) {
    bookmarkedArticles.removeWhere((a) => a.url == article.url);
    saveBookmarks();
    Get.snackbar(
      'Removed',
      'Article removed from bookmarks',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  bool isBookmarked(NewsArticle article) {
    return bookmarkedArticles.any((a) => a.url == article.url);
  }
}
