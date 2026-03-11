import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/instagram_widgets.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onMessagesTap;
  final VoidCallback onNotificationsTap;

  const HomeScreen({
    super.key, 
    required this.onProfileTap,
    required this.onMessagesTap,
    required this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram'),
        actions: [
          IconButton(
            onPressed: onNotificationsTap, 
            icon: const Icon(Icons.favorite_border)
          ),
          IconButton(
            onPressed: onMessagesTap, 
            icon: const Icon(Icons.chat_bubble_outline)
          ),
        ],
      ),
      body: RefreshIndicator(
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
      ),
    );
  }
}
