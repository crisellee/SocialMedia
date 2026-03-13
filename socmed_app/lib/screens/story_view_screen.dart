import 'package:flutter/material.dart';

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
          // The Story Image
          Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Top Bar with Name and Close Button
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              children: [
                const CircleAvatar(radius: 15, backgroundColor: Colors.white),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
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