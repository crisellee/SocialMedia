import 'package:flutter/material.dart';

class ExplorePost {
  final String id;
  final String username;
  final String userProfileImage;
  final List<String> imageUrls;
  final String caption;
  String reaction;
  int likesCount;
  final List<String> comments;

  ExplorePost({
    required this.id,
    required this.username,
    required this.userProfileImage,
    required this.imageUrls,
    required this.caption,
    this.reaction = 'None',
    this.likesCount = 0,
    List<String>? comments,
  }) : comments = comments ?? [];
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<ExplorePost> _explorePosts = List.generate(
    50,
    (index) => ExplorePost(
      id: index.toString(),
      username: 'explore_user_$index',
      userProfileImage: 'https://i.pravatar.cc/150?img=${(index % 50) + 1}',
      imageUrls: index % 3 == 0
          ? [
              'https://picsum.photos/600/800?random=$index',
              'https://picsum.photos/600/800?random=${index + 500}'
            ]
          : ['https://picsum.photos/600/800?random=$index'],
      caption: 'Discovering something new! #explore #vibe #post$index',
      likesCount: (index + 1) * 15,
    ),
  );

  @override
  Widget build(BuildContext context) {
    bool isWeb = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isWeb ? 4 : 3,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        itemCount: _explorePosts.length,
        itemBuilder: (context, index) {
          final post = _explorePosts[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExploreFeedView(
                    posts: _explorePosts,
                    initialIndex: index,
                  ),
                ),
              ).then((_) => setState(() {})); // Refresh grid on return
            },
            child: ClipRRect(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(post.imageUrls[0], fit: BoxFit.cover),
                  if (post.imageUrls.length > 1)
                    const Positioned(
                      top: 10,
                      right: 10,
                      child: Icon(Icons.collections, color: Colors.white, size: 20),
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

class ExploreFeedView extends StatefulWidget {
  final List<ExplorePost> posts;
  final int initialIndex;

  const ExploreFeedView({
    super.key,
    required this.posts,
    required this.initialIndex,
  });

  @override
  State<ExploreFeedView> createState() => _ExploreFeedViewState();
}

class _ExploreFeedViewState extends State<ExploreFeedView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          return ExploreFeedItem(post: widget.posts[index]);
        },
      ),
    );
  }
}

class ExploreFeedItem extends StatefulWidget {
  final ExplorePost post;

  const ExploreFeedItem({super.key, required this.post});

  @override
  State<ExploreFeedItem> createState() => _ExploreFeedItemState();
}

class _ExploreFeedItemState extends State<ExploreFeedItem> {
  final PageController _imagePageController = PageController();
  final GlobalKey _reactionButtonKey = GlobalKey();
  OverlayEntry? _reactionOverlay;

  final List<Map<String, String>> reactionsList = [
    {'name': 'Love', 'icon': '❤️'},
    {'name': 'Haha', 'icon': '😆'},
    {'name': 'Wow', 'icon': '😮'},
    {'name': 'Sad', 'icon': '😢'},
    {'name': 'Angry', 'icon': '😡'},
  ];

  @override
  void dispose() {
    _imagePageController.dispose();
    _hideReactionPopup();
    super.dispose();
  }

  Widget _getReactionIcon() {
    if (widget.post.reaction == 'None') {
      return const Icon(Icons.favorite_border, color: Colors.white, size: 35);
    }
    if (widget.post.reaction == 'Love') {
      return const Icon(Icons.favorite, color: Colors.red, size: 35);
    }
    final react = reactionsList.firstWhere(
      (r) => r['name'] == widget.post.reaction,
      orElse: () => reactionsList[0],
    );
    return Text(react['icon']!, style: const TextStyle(fontSize: 32));
  }

  void _showReactionPopup() {
    if (_reactionOverlay != null) return;

    final overlay = Overlay.of(context);
    final renderBox = _reactionButtonKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _reactionOverlay = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hideReactionPopup,
        child: Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).size.height - position.dy + 10,
              right: 20,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: reactionsList.map((r) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.post.reaction == 'None') {
                              widget.post.likesCount++;
                            }
                            widget.post.reaction = r['name']!;
                          });
                          _hideReactionPopup();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(r['icon']!, style: const TextStyle(fontSize: 28)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_reactionOverlay!);
  }

  void _hideReactionPopup() {
    _reactionOverlay?.remove();
    _reactionOverlay = null;
  }

  void _showMenuPopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.report, color: Colors.red), title: const Text('Report'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.link), title: const Text('Copy Link'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.share), title: const Text('Share to...'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.star_border), title: const Text('Add to Favorites'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),
            ListTile(leading: const Icon(Icons.chat_bubble_outline), title: const Text('Send to Friend'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.add_circle_outline), title: const Text('Add to Story'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.share), title: const Text('Other Share Options'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  void _showCommentSheet() {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(height: 10),
                const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.post.comments.length,
                    itemBuilder: (context, i) => ListTile(
                      leading: const CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                      title: Text(widget.post.comments[i], style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(hintText: 'Add a comment...', border: InputBorder.none),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          setState(() {
                            widget.post.comments.add(controller.text);
                          });
                          setModalState(() {});
                          controller.clear();
                        }
                      },
                      child: const Text('Post', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Content (Images)
        PageView.builder(
          controller: _imagePageController,
          itemCount: widget.post.imageUrls.length,
          itemBuilder: (context, i) => Image.network(widget.post.imageUrls[i], fit: BoxFit.cover),
        ),
        
        // Dark Gradient for text readability
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
                stops: const [0.0, 0.2, 0.8, 1.0],
              ),
            ),
          ),
        ),

        // User Info and Caption
        Positioned(
          bottom: 40,
          left: 15,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(widget.post.userProfileImage),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.post.username,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text('Follow', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                widget.post.caption,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Side Actions
        Positioned(
          bottom: 40,
          right: 15,
          child: Column(
            children: [
              GestureDetector(
                key: _reactionButtonKey,
                onLongPress: _showReactionPopup,
                onTap: () {
                  setState(() {
                    if (widget.post.reaction == 'None') {
                      widget.post.reaction = 'Love';
                      widget.post.likesCount++;
                    } else {
                      widget.post.reaction = 'None';
                      widget.post.likesCount--;
                    }
                  });
                },
                child: _getReactionIcon(),
              ),
              const SizedBox(height: 5),
              Text(
                widget.post.likesCount.toString(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _showCommentSheet,
                child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 35),
              ),
              const SizedBox(height: 5),
              Text(
                widget.post.comments.length.toString(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _showShareSheet,
                child: const Icon(Icons.send_outlined, color: Colors.white, size: 35),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _showMenuPopup,
                child: const Icon(Icons.more_vert, color: Colors.white, size: 35),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
