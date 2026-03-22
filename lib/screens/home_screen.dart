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

  void _onStoryTap(BuildContext context, String name, String img) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewScreen(
          name: name,
          imageUrl: img,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Instagram',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              StoriesSection(
                onTap: (name, img) => _onStoryTap(context, name, img),
              ),
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

class StoriesSection extends StatelessWidget {
  final Function(String name, String img) onTap;

  const StoriesSection({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // ✅ Switched to Unsplash URLs to avoid CORS/Corrupt image issues on Web
    final List<Map<String, String>> stories = [
      {'name': 'Your Story', 'img': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=800'},
      {'name': 'alice', 'img': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800'},
      {'name': 'bob', 'img': 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=800'},
      {'name': 'charlie', 'img': 'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=800'},
      {'name': 'diana', 'img': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=800'},
      {'name': 'eva', 'img': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800'},
    ];

    return Container(
      height: 115,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          bool isMe = index == 0;

          return GestureDetector(
            onTap: () => onTap(story['name']!, story['img']!),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isMe
                              ? null
                              : const LinearGradient(
                            colors: [Colors.yellow, Colors.orange, Colors.red, Colors.purple],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          border: isMe ? Border.all(color: Colors.grey[300]!) : null,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: NetworkImage(story['img']!),
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      if (isMe)
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.add, size: 16, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    story['name']!,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StoryViewScreen extends StatelessWidget {
  final String name;
  final String imageUrl;

  const StoryViewScreen({super.key, required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full Screen Image with error and loading handling
          Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              // ✅ Fixes the "Corrupt/Corrs" issue by showing a placeholder if it fails
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[900],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.white, size: 50),
                      SizedBox(height: 10),
                      Text("Image failed to load", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              },
              // ✅ Shows a loading spinner so the user knows it's working
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
            ),
          ),
          // Header Overlay
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(width: 12),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}