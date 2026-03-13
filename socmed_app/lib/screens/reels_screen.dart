import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';


class Reel {
  final String id;
  final String username;
  final String userProfileImage;
  final String mediaUrl;
  final bool isVideo;
  final String caption;
  String reaction;
  int likesCount;
  final List<String> comments;
  bool isFollowing;


  Reel({
    required this.id,
    required this.username,
    required this.userProfileImage,
    required this.mediaUrl,
    required this.caption,
    this.isVideo = false,
    this.reaction = 'None',
    this.likesCount = 0,
    List<String>? comments,
    this.isFollowing = false,
  }) : comments = comments ?? [];
}


class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});


  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}


class _ReelsScreenState extends State<ReelsScreen> {


  final List<String> reelsVideos = [
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",


    // 5 additional reels
    "https://samplelib.com/lib/preview/mp4/sample-5s.mp4",
    "https://samplelib.com/lib/preview/mp4/sample-10s.mp4",
    "https://samplelib.com/lib/preview/mp4/sample-15s.mp4",
    "https://samplelib.com/lib/preview/mp4/sample-20s.mp4",
    "https://samplelib.com/lib/preview/mp4/sample-30s.mp4",
  ];


  late final List<Reel> _reels = List.generate(
    15,
        (index) => Reel(
      id: index.toString(),
      username: 'user_$index',
      userProfileImage: 'https://i.pravatar.cc/150?img=${index + 20}',
      mediaUrl: index % 2 == 0
          ? 'https://picsum.photos/400/800?random=${index + 200}'
          : reelsVideos[index % reelsVideos.length],
      isVideo: index % 2 != 0,
      caption: 'Amazing view #$index! #reels #viral #nature',
      likesCount: (index + 1) * 100,
    ),
  );


  void _handleReact(int index, String reaction) {
    setState(() {
      if (_reels[index].reaction == 'None' && reaction != 'None') {
        _reels[index].likesCount++;
      } else if (_reels[index].reaction != 'None' && reaction == 'None') {
        _reels[index].likesCount--;
      }
      _reels[index].reaction = reaction;
    });
  }


  void _handleComment(int index, String comment) {
    setState(() {
      _reels[index].comments.add(comment);
    });
  }


  void _handleFollow(int index) {
    setState(() {
      _reels[index].isFollowing = !_reels[index].isFollowing;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _reels.length,
        itemBuilder: (context, index) {
          return ReelItem(
            reel: _reels[index],
            onReact: (react) => _handleReact(index, react),
            onComment: (comment) => _handleComment(index, comment),
            onFollow: () => _handleFollow(index),
          );
        },
      ),
    );
  }
}


class ReelItem extends StatefulWidget {
  final Reel reel;
  final Function(String) onReact;
  final Function(String) onComment;
  final VoidCallback onFollow;


  const ReelItem({
    super.key,
    required this.reel,
    required this.onReact,
    required this.onComment,
    required this.onFollow,
  });


  @override
  State<ReelItem> createState() => _ReelItemState();
}


class _ReelItemState extends State<ReelItem> {
  OverlayEntry? _reactionOverlay;
  final GlobalKey _reactionButtonKey = GlobalKey();
  VideoPlayerController? _videoController;


  final List<Map<String, String>> reactions = [
    {'name': 'Love', 'icon': '❤️'},
    {'name': 'Haha', 'icon': '😆'},
    {'name': 'Wow', 'icon': '😮'},
    {'name': 'Sad', 'icon': '😢'},
    {'name': 'Angry', 'icon': '😡'},
  ];


  @override
  void initState() {
    super.initState();
    if (widget.reel.isVideo) {
      _videoController = VideoPlayerController.network(widget.reel.mediaUrl)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
          _videoController!.setLooping(true);
        });
    }
  }


  @override
  void dispose() {
    _hideReactionPopup();
    _videoController?.dispose();
    super.dispose();
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
              top: position.dy - 60,
              right: 20,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: reactions.map((r) {
                      return GestureDetector(
                        onTap: () {
                          widget.onReact(r['name']!);
                          _hideReactionPopup();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(r['icon']!, style: const TextStyle(fontSize: 24)),
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


  Widget _getReactionIcon() {
    if (widget.reel.reaction == 'None') {
      return const Icon(Icons.favorite_border, color: Colors.white, size: 30);
    }
    if (widget.reel.reaction == 'Love' || widget.reel.reaction == 'Like') {
      return const Icon(Icons.favorite, color: Colors.red, size: 30);
    }


    final react = reactions.firstWhere(
            (r) => r['name'] == widget.reel.reaction,
        orElse: () => reactions[0]);


    return Text(react['icon']!, style: const TextStyle(fontSize: 30));
  }


  void _showCommentSheet() {
    final TextEditingController controller = TextEditingController();


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Comments',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.reel.comments.length,
                    itemBuilder: (context, i) => ListTile(
                      leading: const CircleAvatar(
                          radius: 15,
                          backgroundImage:
                          NetworkImage('https://i.pravatar.cc/150?img=11')),
                      title: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          children: [
                            const TextSpan(
                              text: 'itsmekriselz ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: widget.reel.comments[i]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                            hintText: 'Add a comment...',
                            border: InputBorder.none),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          widget.onComment(controller.text);
                          setModalState(() {});
                          controller.clear();
                        }
                      },
                      child: const Text('Post',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold)),
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


  void _showShareOptions() {
    Share.share("${widget.reel.caption}\n${widget.reel.mediaUrl}");
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [


        if (widget.reel.isVideo)
          _videoController!.value.isInitialized
              ? VideoPlayer(_videoController!)
              : const Center(child: CircularProgressIndicator())
        else
          Image.network(widget.reel.mediaUrl, fit: BoxFit.cover),


        Positioned(
          bottom: 20,
          left: 15,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      radius: 15,
                      backgroundImage:
                      NetworkImage(widget.reel.userProfileImage)),
                  const SizedBox(width: 10),
                  Text(widget.reel.username,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: widget.onFollow,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        color: widget.reel.isFollowing ? Colors.transparent : Colors.transparent,
                      ),
                      child: Text(
                        widget.reel.isFollowing ? 'Following' : 'Follow',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.reel.caption,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),


        Positioned(
          bottom: 20,
          right: 15,
          child: Column(
            children: [


              GestureDetector(
                key: _reactionButtonKey,
                onLongPress: _showReactionPopup,
                onTap: () {
                  if (widget.reel.reaction == 'None') {
                    widget.onReact('Love');
                  } else {
                    widget.onReact('None');
                  }
                },
                child: _getReactionIcon(),
              ),


              Text(widget.reel.likesCount.toString(),
                  style: const TextStyle(color: Colors.white)),


              const SizedBox(height: 20),


              IconButton(
                icon: const Icon(Icons.chat_bubble_outline,
                    color: Colors.white, size: 30),
                onPressed: _showCommentSheet,
              ),


              Text(widget.reel.comments.length.toString(),
                  style: const TextStyle(color: Colors.white)),


              const SizedBox(height: 20),


              IconButton(
                icon: const Icon(Icons.send_outlined,
                    color: Colors.white, size: 30),
                onPressed: _showShareOptions,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


