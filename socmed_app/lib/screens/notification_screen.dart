import 'package:flutter/material.dart';
import '../models/post.dart';


class NotificationData {
  final String id;
  final String type; // 'follow_request', 'group_like', 'like', 'follow', 'facebook'
  final List<String>? usernames;
  final int? othersCount;
  final String? action;
  final String time;
  final List<String> profileImages;
  final String? postImage;
  bool isFollowedBack;
  final String section; // 'New', 'This week', 'This month'


  NotificationData({
    required this.id,
    required this.type,
    this.usernames,
    this.othersCount,
    this.action,
    required this.time,
    required this.profileImages,
    this.postImage,
    this.isFollowedBack = false,
    required this.section,
  });
}


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});


  static List<NotificationData> notificationList = [
    NotificationData(
      id: '1',
      type: 'follow_request',
      usernames: ['justjeypiii'],
      time: '8h',
      profileImages: ['https://i.pravatar.cc/150?img=12'],
      section: 'New',
    ),
    NotificationData(
      id: '2',
      type: 'group_like',
      usernames: ['msgenna_rs', 'fanboi_ryu'],
      othersCount: 2,
      time: '3d',
      profileImages: ['https://i.pravatar.cc/150?img=13', 'https://i.pravatar.cc/150?img=14'],
      postImage: 'https://picsum.photos/100/100?random=1',
      section: 'This week',
    ),
    NotificationData(
      id: '3',
      type: 'group_like',
      usernames: ['msgenna_rs', 'johnrey_ming'],
      time: '3d',
      profileImages: ['https://i.pravatar.cc/150?img=13', 'https://i.pravatar.cc/150?img=15'],
      postImage: 'https://picsum.photos/100/100?random=2',
      section: 'This week',
    ),
    NotificationData(
      id: '4',
      type: 'like',
      usernames: ['fanboi_ryu'],
      action: 'liked your story.',
      time: 'Mar 04',
      profileImages: ['https://i.pravatar.cc/150?img=14'],
      postImage: 'https://picsum.photos/100/100?random=3',
      section: 'This month',
    ),
    NotificationData(
      id: '5',
      type: 'follow',
      usernames: ['ja9_sweetghurlll'],
      time: 'Mar 03',
      profileImages: ['https://i.pravatar.cc/150?img=16'],
      section: 'This month',
    ),
    NotificationData(
      id: '6',
      type: 'facebook',
      time: 'Feb 21',
      profileImages: [],
      action: 'Your story has 11 reactions on Facebook.',
      postImage: 'https://picsum.photos/100/100?random=10',
      section: 'This month',
    ),
    NotificationData(
      id: '7',
      type: 'group_like',
      usernames: ['johnrey_ming', 'fanboi_ryu'],
      time: 'Feb 21',
      profileImages: ['https://i.pravatar.cc/150?img=15', 'https://i.pravatar.cc/150?img=14'],
      postImage: 'https://picsum.photos/100/100?random=6',
      section: 'This month',
    ),
  ];


  static void addPostNotification(PostData post) {
    notificationList.insert(0, NotificationData(
      id: DateTime.now().toString(),
      type: 'like',
      usernames: ['You'],
      action: 'successfully posted: ${post.caption}',
      time: 'Just now',
      profileImages: ['https://i.pravatar.cc/150?img=11'],
      postImage: post.postImage,
      section: 'New',
    ));
  }


  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}


class _NotificationScreenState extends State<NotificationScreen> {
  void _removeNotification(String id) {
    setState(() {
      NotificationScreen.notificationList.removeWhere((n) => n.id == id);
    });
  }


  void _toggleFollow(String id) {
    setState(() {
      final index = NotificationScreen.notificationList.indexWhere((n) => n.id == id);
      if (index != -1) {
        NotificationScreen.notificationList[index].isFollowedBack =
        !NotificationScreen.notificationList[index].isFollowedBack;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final sections = ['New', 'This week', 'This month'];


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, size: 28),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildFollowRequestsHeader(),
          const Divider(height: 1, indent: 70),
          ...sections.map((section) {
            final items = NotificationScreen.notificationList.where((n) => n.section == section).toList();
            if (items.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(section),
                ...items.map((n) => _buildNotificationItem(n)).toList(),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }


  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }


  Widget _buildFollowRequestsHeader() {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: SizedBox(
        width: 44,
        height: 44,
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0,
              child: CircleAvatar(
                radius: 14,
                backgroundImage: const NetworkImage("https://i.pravatar.cc/150?img=12"),
                backgroundColor: Colors.grey[200],
              ),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
      title: const Text("Follow requests", style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: const Text("justjeypiii + 2 others", style: TextStyle(color: Colors.grey)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }


  Widget _buildNotificationItem(NotificationData n) {
    if (n.type == 'follow_request') return _buildFollowRequestItem(n);
    if (n.type == 'group_like') return _buildGroupLikeItem(n);
    if (n.type == 'follow') return _buildFollowBackItem(n);
    if (n.type == 'facebook') return _buildFacebookNotification(n);
    return _buildSimpleItem(n);
  }


  Widget _buildFollowRequestItem(NotificationData n) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(radius: 22, backgroundImage: NetworkImage(n.profileImages[0])),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: n.usernames![0], style: const TextStyle(fontWeight: FontWeight.bold)),
            const TextSpan(text: " requested to follow you. "),
            TextSpan(text: n.time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => _removeNotification(n.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, foregroundColor: Colors.white,
              elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(0, 32),
            ),
            child: const Text("Confirm", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _removeNotification(n.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200], foregroundColor: Colors.black,
              elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(0, 32),
            ),
            child: const Text("Delete", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }


  Widget _buildGroupLikeItem(NotificationData n) {
    String text = n.usernames!.join(", ");
    if (n.othersCount != null && n.othersCount! > 0) text += " and others";
    text += " liked your story. ";


    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: SizedBox(
        width: 44, height: 44,
        child: Stack(
          children: [
            Positioned(top: 0, left: 0, child: CircleAvatar(radius: 14, backgroundImage: NetworkImage(n.profileImages[0]))),
            Positioned(bottom: 0, right: 0, child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              child: CircleAvatar(radius: 14, backgroundImage: NetworkImage(n.profileImages[1])),
            )),
          ],
        ),
      ),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: text, style: const TextStyle(fontWeight: FontWeight.normal)),
            TextSpan(text: n.time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      trailing: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(image: NetworkImage(n.postImage!), fit: BoxFit.cover),
        ),
      ),
    );
  }


  Widget _buildSimpleItem(NotificationData n) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(radius: 22, backgroundImage: NetworkImage(n.profileImages[0])),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: n.usernames![0], style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: " ${n.action} "),
            TextSpan(text: n.time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      trailing: n.postImage != null ? Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(image: NetworkImage(n.postImage!), fit: BoxFit.cover),
        ),
      ) : null,
    );
  }


  Widget _buildFollowBackItem(NotificationData n) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(radius: 22, backgroundImage: NetworkImage(n.profileImages[0])),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: n.usernames![0], style: const TextStyle(fontWeight: FontWeight.bold)),
            const TextSpan(text: " started following you. "),
            TextSpan(text: n.time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () => _toggleFollow(n.id),
        style: ElevatedButton.styleFrom(
          backgroundColor: n.isFollowedBack ? Colors.grey[200] : Colors.blue,
          foregroundColor: n.isFollowedBack ? Colors.black : Colors.white,
          elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(0, 32),
        ),
        child: Text(n.isFollowedBack ? "Following" : "Follow Back", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }


  Widget _buildFacebookNotification(NotificationData n) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const CircleAvatar(
        radius: 22, backgroundColor: Colors.white,
        child: Icon(Icons.facebook, color: Colors.blue, size: 44),
      ),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: "${n.action} "),
            TextSpan(text: n.time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      trailing: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(image: NetworkImage(n.postImage!), fit: BoxFit.cover),
        ),
      ),
    );
  }
}


