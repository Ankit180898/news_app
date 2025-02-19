import 'package:flutter/material.dart';
import 'package:news_app/view model/news_view_model.dart';
import 'package:news_app/widgets/news_card.dart';

class NewsSearchDelegate extends SearchDelegate {
  final NewsViewModel controller;

  NewsSearchDelegate(this.controller);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Search for news',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    final filteredArticles = controller.articles.where((article) {
      final searchable = [
        article.title.toLowerCase(),
        article.description.toLowerCase(),
        article.content?.toLowerCase() ?? '',
        article.source.name.toLowerCase(),
      ].join(' ');
      return searchable.contains(query.toLowerCase());
    }).toList();

    if (filteredArticles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredArticles.length,
      itemBuilder: (context, index) {
        final article = filteredArticles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: NewsCard(article: article,heroTag: 'news_image_${article.imageUrl}',),
        );
      },
    );
  }
} 