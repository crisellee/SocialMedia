import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/instagram_widgets.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onProfileTap;

  const HomeScreen({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const StoriesSection(),
            const Divider(height: 1),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) => PostCard(
                post: posts[index],
                onProfileTap: onProfileTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
