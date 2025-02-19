import 'package:news_app/model/news_article.dart';
import 'package:news_app/service/api_service.dart';

class NewsRepository {
  final ApiService apiService;

  NewsRepository(this.apiService);
  
  Future<List<NewsArticle>> getNews({String? category, String? query}) {
    return apiService.fetchNews(category: category, query: query);
  }

  Future<List<NewsArticle>> getHeadlines() {
    return apiService.fetchHeadlines();
  }
}
