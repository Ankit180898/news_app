import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_app/view/news_view.dart';
import 'package:news_app/view/bookmarks_view.dart';

class HomeScreen extends StatelessWidget {
  final RxInt _currentIndex = 0.obs;
  final List<Widget> _screens = [NewsView(), const BookmarksView()];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: _currentIndex.value, children: _screens),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.newspaper_rounded,
                    activeIcon: Icons.newspaper,
                    label: 'News',
                    context: context,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.bookmark_outline_rounded,
                    activeIcon: Icons.bookmark_rounded,
                    label: 'Bookmarks',
                    context: context,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      extendBody: true,
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required BuildContext context,
  }) {
    final isSelected = _currentIndex.value == index;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          HapticFeedback.lightImpact();
          _currentIndex.value = index;
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 1.0 + (0.2 * value),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    color: Color.lerp(Colors.grey, primaryColor, value),
                    size: 24,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
