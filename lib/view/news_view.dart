import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/repository/news_repository.dart';
import 'package:news_app/service/api_service.dart';
import 'package:news_app/view%20model/news_view_model.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/news_search_delegate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:news_app/widgets/topic_selection.dart';
import 'package:news_app/widgets/headlines_carousel.dart';
import 'package:news_app/widgets/sort_filter_menu.dart';
import 'package:lottie/lottie.dart'; // Import Lottie

class NewsView extends StatelessWidget {
  final NewsViewModel controller = Get.put(
    NewsViewModel(NewsRepository(ApiService())),
  );

  NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with search and sort
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'My News',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: NewsSearchDelegate(controller),
                        );
                      },
                    ),
                    SortFilterMenu(controller: controller),
                  ],
                ),
                const SizedBox(height: 20),

                // Headlines Carousel
                Obx(() {
                  if (controller.headlines.isEmpty) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return HeadlinesCarousel(headlines: controller.headlines);
                }),
                const SizedBox(height: 24),

                // Topics section
                Text(
                  'Breaking News',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const TopicSelection(),
                const SizedBox(height: 24),

                // News articles with empty state Lottie animation
                Obx(() {
                  if (controller.isLoading.value) {
                    return _buildShimmerEffect();
                  }

                  final filteredArticles =
                      controller.articles
                          .where(
                            (article) => article.title.toLowerCase().contains(
                              controller.searchQuery.value.toLowerCase(),
                            ),
                          )
                          .toList();

                  if (filteredArticles.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredArticles.length,
                    itemBuilder: (context, index) {
                      final article = filteredArticles[index];
                      return Dismissible(
                        key: Key(article.title),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          final removedArticle = filteredArticles[index];
                          controller.articles.remove(removedArticle);

                          // Show undo option
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Article removed"),
                              action: SnackBarAction(
                                label: "Undo",
                                onPressed: () {
                                  controller.articles.add(removedArticle);
                                },
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: NewsCard(article: article, heroTag: 'news_image_${article.title}'),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DotLottieLoader.fromAsset(
            "assets/images/empty_state.lottie",
            frameBuilder: (ctx, dotlottie) {
              return dotlottie != null
                  ? Lottie.memory(dotlottie.animations.values.single)
                  : const CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 16),
          Text(
            "No articles found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
