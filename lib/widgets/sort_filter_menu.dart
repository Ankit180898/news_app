import 'package:flutter/material.dart';
import 'package:news_app/view model/news_view_model.dart';

class SortFilterMenu extends StatelessWidget {
  final NewsViewModel controller;

  const SortFilterMenu({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortOption>(
      color: Colors.white,
      icon: const Icon(Icons.sort),
      tooltip: 'Sort articles',
      onSelected: controller.setSortOption,
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: SortOption.newest,
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color:
                        controller.currentSortOption.value == SortOption.newest
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Newest First',
                    style: TextStyle(
                      color:
                          controller.currentSortOption.value ==
                                  SortOption.newest
                              ? Theme.of(context).primaryColor
                              : null,
                      fontWeight:
                          controller.currentSortOption.value ==
                                  SortOption.newest
                              ? FontWeight.bold
                              : null,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: SortOption.oldest,
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color:
                        controller.currentSortOption.value == SortOption.oldest
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Oldest First',
                    style: TextStyle(
                      color:
                          controller.currentSortOption.value ==
                                  SortOption.oldest
                              ? Theme.of(context).primaryColor
                              : null,
                      fontWeight:
                          controller.currentSortOption.value ==
                                  SortOption.oldest
                              ? FontWeight.bold
                              : null,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: SortOption.title,
              child: Row(
                children: [
                  Icon(
                    Icons.sort_by_alpha,
                    color:
                        controller.currentSortOption.value == SortOption.title
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Title A-Z',
                    style: TextStyle(
                      color:
                          controller.currentSortOption.value == SortOption.title
                              ? Theme.of(context).primaryColor
                              : null,
                      fontWeight:
                          controller.currentSortOption.value == SortOption.title
                              ? FontWeight.bold
                              : null,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: SortOption.popularity,
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    color:
                        controller.currentSortOption.value == SortOption.popularity
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Popularity',
                    style: TextStyle(
                      color:
                          controller.currentSortOption.value ==
                                  SortOption.popularity
                              ? Theme.of(context).primaryColor
                              : null,
                      fontWeight:
                          controller.currentSortOption.value ==
                                  SortOption.popularity
                              ? FontWeight.bold
                              : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
    );
  }
}
