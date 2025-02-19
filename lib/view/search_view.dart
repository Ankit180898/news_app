import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/view model/news_view_model.dart';
import 'package:news_app/widgets/news_card.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsViewModel>();
    final searchController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: searchController,
                onChanged: controller.searchArticles,
                onSubmitted: (query) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Obx(
                    () =>
                        controller.searchQuery.value.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                controller.searchArticles('');
                              },
                            )
                            : const SizedBox(),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.searchQuery.value.isEmpty) {
                    // Show search history when not searching
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
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
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  // Show search results
                  final filteredArticles =
                      controller.articles.where((article) {
                        final searchable = [
                          article.title.toLowerCase(),
                          article.description.toLowerCase(),
                          article.content?.toLowerCase() ?? '',
                          article.source.name.toLowerCase(),
                        ].join(' ');
                        return searchable.contains(
                          controller.searchQuery.value.toLowerCase(),
                        );
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
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      final article = filteredArticles[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: NewsCard(article: article,heroTag: 'news_image_${article.source}',),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
