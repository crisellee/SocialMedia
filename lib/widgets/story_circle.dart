import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {
  final String name;
  final bool isMe;
  final bool isViewed;

  const StoryCircle({
    super.key,
    required this.name,
    this.isMe = false,
    this.isViewed = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(3), // Space for the border
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isViewed
                      ? null
                      : const LinearGradient(
                    colors: [Colors.orange, Colors.pink, Colors.purple],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                  color: isViewed ? Colors.grey[300] : null,
                ),
                child: Container(
                  padding: const EdgeInsets.all(2), // White gap
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFE1BEE7), // Light purple from your screenshot
                  ),
                ),
              ),
              if (isMe)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            isMe ? "Your Story" : name,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}