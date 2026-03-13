class PostData {
  final String name;
  final String profile;
  final String postImage;
  final String caption;
  final String location;
  int likes;
  String reaction; // New field for reaction
  bool isSaved;
  final List<String> comments; // New field for comments


  PostData({
    required this.name,
    required this.profile,
    required this.postImage,
    required this.caption,
    this.location = 'California, USA',
    this.likes = 0,
    this.reaction = 'None',
    this.isSaved = false,
    List<String>? comments,
  }) : comments = comments ?? [];


  bool get isLiked => reaction != 'None';
}


final List<Map<String, String>> stories = [
  {'name': 'Your Story', 'image': 'https://i.pravatar.cc/150?img=11'},
  {'name': 'alice', 'image': 'https://i.pravatar.cc/150?img=1'},
  {'name': 'bob', 'image': 'https://i.pravatar.cc/150?img=2'},
  {'name': 'charlie', 'image': 'https://i.pravatar.cc/150?img=3'},
  {'name': 'diana', 'image': 'https://i.pravatar.cc/150?img=4'},
  {'name': 'eva', 'image': 'https://i.pravatar.cc/150?img=5'},
];


final List<PostData> posts = [
  PostData(
      name: 'itsmemarcomasa',
      profile: 'https://i.pravatar.cc/150?img=12',
      postImage: 'https://picsum.photos/600/600?random=10',
      caption: 'that\'s it for the PBB Celeb Collab 2.0 ✌️ ... more',
      likes: 729000,
      comments: ['Great shot!', 'Nice vibe']),
  PostData(
      name: 'raincelmar_',
      profile: 'https://i.pravatar.cc/150?img=13',
      postImage: 'https://picsum.photos/600/800?random=11',
      caption: 'BE A THOMASIAN ANGELICAN',
      likes: 12400),
  PostData(
      name: 'alice',
      profile: 'https://i.pravatar.cc/150?img=1',
      postImage: 'https://picsum.photos/600/600?random=1',
      caption: 'Golden hour at the beach! 🌅',
      likes: 124),
];


