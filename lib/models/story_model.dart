class Story {
  final String userName;
  final String imageUrl;
  final bool isViewed;

  Story({
    required this.userName,
    required this.imageUrl,
    this.isViewed = false,
  });
}