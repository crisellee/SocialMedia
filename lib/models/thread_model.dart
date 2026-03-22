import 'dart:typed_data';

class ThreadComment {
  final String username;
  final String text;
  final String time;

  ThreadComment({
    required this.username,
    required this.text,
    required this.time,
  });
}

class ThreadModel {
  final String username;
  final String time;
  final String content;
  final bool isVerified;
  final int replies;
  final int likes;
  final String avatarUrl;
  final String? imageUrl;
  final Uint8List? imageBytes;
  final List<ThreadComment> comments;
  final bool isLiked;
  final bool isRepost;

  ThreadModel({
    required this.username,
    required this.time,
    required this.content,
    this.isVerified = false,
    this.replies = 0,
    this.likes = 0,
    required this.avatarUrl,
    this.imageUrl,
    this.imageBytes,
    this.comments = const [],
    this.isLiked = false,
    this.isRepost = false,
  });

  ThreadModel copyWith({
    String? username,
    String? time,
    String? content,
    bool? isVerified,
    int? replies,
    int? likes,
    String? avatarUrl,
    String? imageUrl,
    Uint8List? imageBytes,
    List<ThreadComment>? comments,
    bool? isLiked,
    bool? isRepost,
  }) {
    return ThreadModel(
      username: username ?? this.username,
      time: time ?? this.time,
      content: content ?? this.content,
      isVerified: isVerified ?? this.isVerified,
      replies: replies ?? this.replies,
      likes: likes ?? this.likes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      imageBytes: imageBytes ?? this.imageBytes,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      isRepost: isRepost ?? this.isRepost,
    );
  }
}