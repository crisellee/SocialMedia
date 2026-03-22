import 'package:flutter/material.dart';
import '../models/post.dart';


class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: index == 0
                        ? null
                        : const LinearGradient(
                      colors: [Colors.purple, Colors.orange, Colors.yellow],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    border: index == 0 ? Border.all(color: Colors.grey.shade300) : null,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: CircleAvatar(radius: 28, backgroundImage: NetworkImage(story['image']!)),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: 70,
                  child: Text(story['name']!, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class PostCard extends StatefulWidget {
  final PostData post;
  final VoidCallback? onProfileTap; // Callback for profile navigation


  const PostCard({super.key, required this.post, this.onProfileTap});


  @override
  State<PostCard> createState() => _PostCardState();
}


class _PostCardState extends State<PostCard> {
  final GlobalKey _reactionButtonKey = GlobalKey();
  final TextEditingController _commentController = TextEditingController();
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
    _hideReactionPopup();
    _commentController.dispose();
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
              left: position.dx,
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
                              widget.post.likes++;
                            }
                            widget.post.reaction = r['name']!;
                          });
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
    if (widget.post.reaction == 'None') {
      return const Icon(Icons.favorite_border, color: Colors.black, size: 28);
    }
    if (widget.post.reaction == 'Love') {
      return const Icon(Icons.favorite, color: Colors.red, size: 28);
    }
    final react = reactionsList.firstWhere(
          (r) => r['name'] == widget.post.reaction,
      orElse: () => reactionsList[0],
    );
    return Text(react['icon']!, style: const TextStyle(fontSize: 24));
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


  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        widget.post.comments.add(_commentController.text);
        _commentController.clear();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: GestureDetector(
            onTap: widget.onProfileTap,
            child: CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.post.profile)),
          ),
          title: GestureDetector(
            onTap: widget.onProfileTap,
            child: Row(
              children: [
                Text(widget.post.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(width: 5),
                const Icon(Icons.verified, color: Colors.blue, size: 14),
                const SizedBox(width: 5),
                const Text('• 1w', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
          trailing: IconButton(icon: const Icon(Icons.more_horiz), onPressed: _showMenuPopup),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(widget.post.postImage, width: double.infinity, fit: BoxFit.cover),
        ),
        Row(
          children: [
            GestureDetector(
              key: _reactionButtonKey,
              onLongPress: _showReactionPopup,
              onTap: () {
                setState(() {
                  if (widget.post.reaction == 'None') {
                    widget.post.reaction = 'Love';
                    widget.post.likes++;
                  } else {
                    widget.post.reaction = 'None';
                    widget.post.likes--;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _getReactionIcon(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.black, size: 28),
              onPressed: _showCommentSheet,
            ),
            IconButton(
              icon: const Icon(Icons.send_outlined, color: Colors.black, size: 28),
              onPressed: _showShareSheet,
            ),
            const Spacer(),
            IconButton(
              icon: Icon(widget.post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: widget.post.isSaved ? Colors.yellow[700] : Colors.black, size: 28),
              onPressed: () => setState(() => widget.post.isSaved = !widget.post.isSaved),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '${widget.post.likes.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")} likes',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(text: '${widget.post.name} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: widget.post.caption),
              ],
            ),
          ),
        ),
        if (widget.post.comments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showCommentSheet,
                  child: Text(
                    'View all ${widget.post.comments.length} comments',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      const TextSpan(text: 'kriselz_ ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: widget.post.comments.last),
                    ],
                  ),
                ),
              ],
            ),
          ),
        // Inline Comment Input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _commentController,
                  onSubmitted: (_) => _addComment(),
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _addComment,
                child: const Text('Post', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}


class SuggestedSidebar extends StatelessWidget {
  final VoidCallback? onProfileTap;
  const SuggestedSidebar({super.key, this.onProfileTap});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: GestureDetector(
            onTap: onProfileTap,
            child: const CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
          ),
          title: GestureDetector(
            onTap: onProfileTap,
            child: const Text('itsmekriselz', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          subtitle: const Text('Itsmekrisel', style: TextStyle(color: Colors.grey, fontSize: 14)),
          trailing: TextButton(onPressed: () {}, child: const Text('Switch', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12))),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Suggested for you', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
            TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))),
          ],
        ),
        ...List.generate(5, (index) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=15')),
          title: Text('user_suggestion_$index', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: const Text('Followed by common_friend', style: TextStyle(color: Colors.grey, fontSize: 12)),
          trailing: TextButton(onPressed: () {}, child: const Text('Follow', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12))),
        )),
        const SizedBox(height: 20),
        const Text(
          'About • Help • Press • API • Jobs • Privacy • Terms • Locations • Language • Meta Verified',
          style: TextStyle(color: Color(0xFFC7C7C7), fontSize: 12),
        ),
        const SizedBox(height: 20),
        const Text('© 2024 INSTAGRAM FROM META', style: TextStyle(color: Color(0xFFC7C7C7), fontSize: 12)),
      ],
    );
  }
}


