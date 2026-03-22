import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/chat_model.dart';
import 'chat_detail_screen.dart';
import 'archived_chats_screen.dart';

class ChatUser {
  final String name;
  final String imageUrl;
  bool isSelected;
  bool hasStory;
  ChatUser({required this.name, required this.imageUrl, this.isSelected = false, this.hasStory = false});
}

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  String _searchQuery = "";

  final List<ChatUser> storyUsers = [
    ChatUser(name: "alice", imageUrl: "https://i.pravatar.cc/150?img=1", hasStory: true),
    ChatUser(name: "bob", imageUrl: "https://i.pravatar.cc/150?img=2", hasStory: true),
    ChatUser(name: "Charlie", imageUrl: "https://i.pravatar.cc/150?img=3", hasStory: true),
    ChatUser(name: "David", imageUrl: "https://i.pravatar.cc/150?img=4", hasStory: true),
    ChatUser(name: "Eve", imageUrl: "https://i.pravatar.cc/150?img=5", hasStory: true),
  ];

  final List<ChatConversation> conversations = [
    ChatConversation(
      id: '1',
      username: 'alice',
      userProfileImage: 'https://i.pravatar.cc/150?img=1',
      messages: [],
      lastMessage: 'That photo is amazing! 😍',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      isUnread: true,
    ),
    ChatConversation(
      id: '2',
      username: 'bob',
      userProfileImage: 'https://i.pravatar.cc/150?img=2',
      messages: [],
      lastMessage: 'See you tomorrow at the gym!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      isUnread: false,
    ),
  ];

  final List<ChatUser> availableUsers = [
    ChatUser(name: "Charlie", imageUrl: "https://i.pravatar.cc/150?img=3"),
    ChatUser(name: "David", imageUrl: "https://i.pravatar.cc/150?img=4"),
    ChatUser(name: "Eve", imageUrl: "https://i.pravatar.cc/150?img=5"),
  ];

  void _showUserSelection() {
    _groupNameController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 20),
              const Text("New Group Chat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(
                controller: _groupNameController,
                decoration: InputDecoration(
                    hintText: "Group Name",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: availableUsers.length,
                  itemBuilder: (context, index) {
                    final user = availableUsers[index];
                    return CheckboxListTile(
                      secondary: CircleAvatar(backgroundImage: NetworkImage(user.imageUrl)),
                      title: Text(user.name),
                      value: user.isSelected,
                      onChanged: (val) => setModalState(() => user.isSelected = val!),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final selected = availableUsers.where((u) => u.isSelected).toList();
                  if (selected.isEmpty) return;
                  setState(() {
                    conversations.insert(0, ChatConversation(
                      id: DateTime.now().toString(),
                      username: _groupNameController.text.isEmpty
                          ? selected.map((u) => u.name).join(", ")
                          : _groupNameController.text,
                      userProfileImage: 'https://cdn-icons-png.flaticon.com/512/3211/3211463.png',
                      messages: [],
                      lastMessage: 'Group created',
                      lastMessageTime: DateTime.now(),
                    ));
                    for (var u in availableUsers) { u.isSelected = false; }
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 50)),
                child: const Text("Create Group", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStorySection() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: storyUsers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return _storyItem("Your Story", "https://i.pravatar.cc/150?u=me", false, isMe: true);
          final user = storyUsers[index - 1];
          return _storyItem(user.name, user.imageUrl, user.hasStory);
        },
      ),
    );
  }

  Widget _storyItem(String name, String imageUrl, bool hasStory, {bool isMe = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryViewer(username: name, imageUrl: imageUrl),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasStory
                    ? const LinearGradient(colors: [Colors.yellow, Colors.orange, Colors.pink, Colors.purple])
                    : null,
                color: hasStory ? null : Colors.grey[300],
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                    if (isMe)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(name, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = conversations.where((c) => !c.isArchived && c.username.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Direct', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined, color: Colors.black, size: 28),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArchivedChatsScreen(
              archivedConversations: conversations.where((c) => c.isArchived).toList(),
              onUnarchive: (chat) => setState(() => chat.isArchived = false),
            ))),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUserSelection,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: const InputDecoration(hintText: 'Search', prefixIcon: Icon(Icons.search), border: InputBorder.none),
              ),
            ),
          ),
          _buildStorySection(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: visible.length,
              itemBuilder: (context, index) {
                final chat = visible[index];
                return Slidable(
                  key: Key(chat.id),
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    extentRatio: 0.3,
                    children: [
                      CustomSlidableAction(onPressed: (_) => setState(() => chat.isMuted = !chat.isMuted), backgroundColor: Colors.transparent, child: Icon(chat.isMuted ? Icons.notifications_off : Icons.notifications_none, color: Colors.purple, size: 22)),
                      CustomSlidableAction(onPressed: (_) => setState(() => chat.isArchived = true), backgroundColor: Colors.transparent, child: const Icon(Icons.archive_outlined, color: Colors.black, size: 22)),
                      CustomSlidableAction(onPressed: (_) => setState(() => conversations.remove(chat)), backgroundColor: Colors.transparent, child: const Icon(Icons.delete_outline, color: Colors.red, size: 22)),
                    ],
                  ),
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailScreen(conversation: chat))),
                    leading: CircleAvatar(backgroundImage: NetworkImage(chat.userProfileImage)),
                    title: Text(chat.username, style: TextStyle(fontWeight: chat.isUnread ? FontWeight.bold : FontWeight.normal)),
                    subtitle: Text(chat.lastMessage),
                    trailing: chat.isUnread ? const Icon(Icons.circle, size: 10, color: Colors.blue) : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoryViewer extends StatelessWidget {
  final String username;
  final String imageUrl;
  const StoryViewer({super.key, required this.username, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
          children: [
            Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image, color: Colors.white54, size: 80),
                          const SizedBox(height: 20),
                          Text(
                            "Image blocked by CORS",
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Use --web-renderer html to fix",
                            style: TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                )
            ),
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(imageUrl),
                        backgroundColor: Colors.grey[800],
                      ),
                      const SizedBox(width: 10),
                      Text(
                          username,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                  const Icon(Icons.close, color: Colors.white, size: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}