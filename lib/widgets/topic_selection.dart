import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/view%20model/news_view_model.dart';
import 'package:news_app/model/category_model.dart';

class TopicSelection extends StatelessWidget {
  const TopicSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsViewModel controller = Get.find<NewsViewModel>();

    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ActionChip(
                label: Text(
                  'All',
                  style: TextStyle(
                    color:
                        controller.selectedTopics.isEmpty
                            ? Colors.white
                            : Colors.black87,
                    fontWeight:
                        controller.selectedTopics.isEmpty
                            ? FontWeight.w600
                            : FontWeight.normal,
                  ),
                ),

                backgroundColor:
                    controller.selectedTopics.isEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.grey[200],
                onPressed: () {
                  controller.selectedTopics.clear();
                  controller.fetchNews();
                },
                elevation: 0,
                pressElevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            ...getCategories().map((category) {
              final isSelected = controller.selectedTopics.contains(
                category.name,
              );

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ActionChip(
                  label: Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  avatar: Icon(
                    _getCategoryIcon(category.name),
                    size: 18,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                  backgroundColor:
                      isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                  onPressed: () => controller.toggleTopic(category.name),
                  elevation: 0,
                  pressElevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Icons.sports;
      case 'politics':
        return Icons.policy;
      case 'technology':
        return Icons.computer;
      case 'entertainment':
        return Icons.movie;
      case 'business':
        return Icons.business;
      case 'health':
        return Icons.health_and_safety;
      default:
        return Icons.category;
    }
  }

  List<CategoryModel> getCategories() {
    return [
      CategoryModel(name: 'Sports', searchTerm: 'sports'),
      CategoryModel(name: 'Politics', searchTerm: 'politics'),
      CategoryModel(name: 'Technology', searchTerm: 'technology'),
      CategoryModel(name: 'Entertainment', searchTerm: 'entertainment'),
      CategoryModel(name: 'Business', searchTerm: 'business'),
      CategoryModel(name: 'Health', searchTerm: 'health'),
    ];
  }
}
