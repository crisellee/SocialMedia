import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../models/thread_model.dart';

class ThreadsScreen extends StatefulWidget {
  const ThreadsScreen({super.key});

  @override
  State<ThreadsScreen> createState() => _ThreadsScreenState();
}

class _ThreadsScreenState extends State<ThreadsScreen> {
  final ImagePicker _picker = ImagePicker();

  late List<ThreadModel> _threads;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _threads = [
      ThreadModel(
        username: 'zuck',
        time: '2m',
        content:
        'Welcome to Threads. Sharing ideas, photos, and random thoughts here.',
        isVerified: true,
        replies: 124,
        likes: 932,
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
        imageUrl:
        'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=1200',
        comments: [
          ThreadComment(
            username: 'socmed_user',
            text: 'Ang linis ng UI nito.',
            time: '1m',
          ),
          ThreadComment(
            username: 'jane_doe',
            text: 'Ganda ng post image.',
            time: 'just now',
          ),
        ],
      ),
      ThreadModel(
        username: 'socmed_user',
        time: '15m',
        content: 'Ginawa ko na finally yung Threads tab sa IG clone ko 😎',
        replies: 17,
        likes: 84,
        avatarUrl: 'https://i.pravatar.cc/150?img=11',
      ),
      ThreadModel(
        username: 'jane_doe',
        time: '31m',
        content:
        'Mas gusto ko talaga yung simple at clean na UI kapag social app.',
        replies: 8,
        likes: 51,
        avatarUrl: 'https://i.pravatar.cc/150?img=32',
        imageUrl:
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=1200',
      ),
      ThreadModel(
        username: 'flutter.dev',
        time: '1h',
        content: 'Hot reload is life. Build fast, test fast, fix fast.',
        isVerified: true,
        replies: 22,
        likes: 140,
        avatarUrl: 'https://i.pravatar.cc/150?img=20',
      ),
    ];
  }

  Color get _bg => _isDarkMode ? const Color(0xFF0F0F10) : const Color(0xFFF6F6F7);
  Color get _card => _isDarkMode ? const Color(0xFF1A1A1C) : Colors.white;
  Color get _border => _isDarkMode ? const Color(0xFF2A2A2D) : const Color(0xFFEDEDEF);
  Color get _primaryText => _isDarkMode ? Colors.white : Colors.black;
  Color get _secondaryText => _isDarkMode ? const Color(0xFFA1A1AA) : Colors.grey.shade600;
  Color get _softFill => _isDarkMode ? const Color(0xFF222224) : const Color(0xFFF5F5F7);
  Color get _sheet => _isDarkMode ? const Color(0xFF18181B) : Colors.white;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _toggleLike(int index) {
    final thread = _threads[index];
    final updated = thread.copyWith(
      isLiked: !thread.isLiked,
      likes: thread.isLiked ? thread.likes - 1 : thread.likes + 1,
    );

    setState(() {
      _threads[index] = updated;
    });
  }

  void _shareThread(ThreadModel thread) {
    Share.share(
      '${thread.username}\n\n${thread.content}',
      subject: 'Shared from Threads Clone',
    );
  }

  void _repostThread(int index) {
    final oldThread = _threads[index];

    final repostedThread = ThreadModel(
      username: 'socmed_user',
      time: 'now',
      content: oldThread.content,
      isVerified: false,
      replies: oldThread.replies,
      likes: oldThread.likes,
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      imageUrl: oldThread.imageUrl,
      imageBytes: oldThread.imageBytes,
      comments: List<ThreadComment>.from(oldThread.comments),
      isRepost: true,
    );

    setState(() {
      _threads.insert(0, repostedThread);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thread reposted.')),
    );
  }

  void _deleteThread(int index) {
    setState(() {
      _threads.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post deleted.')),
    );
  }

  Future<void> _editThread(int index) async {
    final oldThread = _threads[index];
    final textController = TextEditingController(text: oldThread.content);
    Uint8List? selectedImageBytes = oldThread.imageBytes;
    String? selectedImageUrl = oldThread.imageUrl;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickImage() async {
              final XFile? file = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 85,
              );

              if (file != null) {
                final bytes = await file.readAsBytes();
                setModalState(() {
                  selectedImageBytes = bytes;
                  selectedImageUrl = null;
                });
              }
            }

            void saveEdit() {
              final updatedText = textController.text.trim();

              setState(() {
                _threads[index] = oldThread.copyWith(
                  content: updatedText,
                  imageBytes: selectedImageBytes,
                  imageUrl: selectedImageUrl,
                );
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post updated.')),
              );
            }

            return _ModernSheet(
              isDarkMode: _isDarkMode,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sheetHandle(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage:
                        NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Edit thread',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textController,
                    maxLines: 5,
                    style: TextStyle(color: _primaryText),
                    decoration: InputDecoration(
                      hintText: 'Edit your post...',
                      hintStyle: TextStyle(color: _secondaryText),
                      filled: true,
                      fillColor: _softFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (selectedImageBytes != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        selectedImageBytes!,
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (selectedImageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        selectedImageUrl!,
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (selectedImageBytes != null || selectedImageUrl != null)
                    const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.image_outlined),
                        label: const Text('Change picture'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryText,
                          side: BorderSide(color: _border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: saveEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isDarkMode ? Colors.white : Colors.black,
                          foregroundColor: _isDarkMode ? Colors.black : Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showThreadOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _ModernSheet(
          isDarkMode: _isDarkMode,
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.edit_outlined, color: _primaryText),
                title: Text('Edit post', style: TextStyle(color: _primaryText)),
                onTap: () {
                  Navigator.pop(context);
                  _editThread(index);
                },
              ),
              ListTile(
                leading: Icon(Icons.repeat, color: _primaryText),
                title: Text('Repost', style: TextStyle(color: _primaryText)),
                onTap: () {
                  Navigator.pop(context);
                  _repostThread(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Delete post',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteThread(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCreatePostSheet() async {
    final textController = TextEditingController();
    Uint8List? selectedImageBytes;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickImage() async {
              final XFile? file = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 85,
              );

              if (file != null) {
                final bytes = await file.readAsBytes();
                setModalState(() {
                  selectedImageBytes = bytes;
                });
              }
            }

            void submitPost() {
              final text = textController.text.trim();

              if (text.isEmpty && selectedImageBytes == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Maglagay ka ng post o picture.')),
                );
                return;
              }

              final newThread = ThreadModel(
                username: 'socmed_user',
                time: 'now',
                content: text,
                isVerified: false,
                replies: 0,
                likes: 0,
                avatarUrl: 'https://i.pravatar.cc/150?img=11',
                imageBytes: selectedImageBytes,
                comments: [],
              );

              setState(() {
                _threads.insert(0, newThread);
              });

              Navigator.pop(context);
            }

            return _ModernSheet(
              isDarkMode: _isDarkMode,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _sheetHandle(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage:
                        NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Create thread',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textController,
                    maxLines: 5,
                    style: TextStyle(color: _primaryText),
                    decoration: InputDecoration(
                      hintText: 'What’s new?',
                      hintStyle: TextStyle(color: _secondaryText),
                      filled: true,
                      fillColor: _softFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (selectedImageBytes != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        selectedImageBytes!,
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (selectedImageBytes != null) const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: pickImage,
                        icon: const Icon(Icons.image_outlined),
                        label: const Text('Add picture'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryText,
                          side: BorderSide(color: _border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: submitPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isDarkMode ? Colors.white : Colors.black,
                          foregroundColor: _isDarkMode ? Colors.black : Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text('Post'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openCommentsSheet(int threadIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _CommentsSheet(
          isDarkMode: _isDarkMode,
          thread: _threads[threadIndex],
          onAddComment: (commentText) {
            final oldThread = _threads[threadIndex];
            final updatedComments = List<ThreadComment>.from(oldThread.comments)
              ..add(
                ThreadComment(
                  username: 'socmed_user',
                  text: commentText,
                  time: 'now',
                ),
              );

            setState(() {
              _threads[threadIndex] = oldThread.copyWith(
                comments: updatedComments,
                replies: updatedComments.length,
              );
            });
          },
        );
      },
    );
  }

  Widget _sheetHandle() {
    return Container(
      width: 46,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 250),
      data: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: _bg,
        appBarTheme: AppBarTheme(
          backgroundColor: _bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Threads',
            style: TextStyle(
              color: _primaryText,
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: -0.3,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _toggleTheme,
              icon: Icon(
                _isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color: _primaryText,
              ),
            ),
          ],
        ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          color: _bg,
          child: Column(
            children: [
              _ComposerCard(
                onTap: _openCreatePostSheet,
                isDarkMode: _isDarkMode,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: ListView.separated(
                    key: ValueKey(_isDarkMode),
                    padding: const EdgeInsets.only(top: 2, bottom: 18),
                    itemCount: _threads.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.96, end: 1),
                        duration: Duration(milliseconds: 220 + (index * 30)),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.scale(
                              scale: value,
                              child: child,
                            ),
                          );
                        },
                        child: _ThreadCard(
                          isDarkMode: _isDarkMode,
                          thread: _threads[index],
                          onLike: () => _toggleLike(index),
                          onComment: () => _openCommentsSheet(index),
                          onShare: () => _shareThread(_threads[index]),
                          onRepost: () => _repostThread(index),
                          onMore: () => _showThreadOptions(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComposerCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDarkMode;

  const _ComposerCard({
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final card = isDarkMode ? const Color(0xFF1A1A1C) : Colors.white;
    final border = isDarkMode ? const Color(0xFF2A2A2D) : const Color(0xFFECECEF);
    final primaryText = isDarkMode ? Colors.white : Colors.black;
    final secondaryText = isDarkMode ? const Color(0xFFA1A1AA) : Colors.grey.shade600;
    final softFill = isDarkMode ? const Color(0xFF222224) : const Color(0xFFF5F5F7);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black45 : const Color(0x0A000000),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 23,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start a thread',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Share something with your followers...',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _miniIcon(Icons.image_outlined, softFill, primaryText),
                        const SizedBox(width: 12),
                        _miniIcon(Icons.gif_box_outlined, softFill, primaryText),
                        const SizedBox(width: 12),
                        _miniIcon(Icons.mic_none_outlined, softFill, primaryText),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white : Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Post',
                style: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniIcon(IconData icon, Color bg, Color text) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 18, color: text),
    );
  }
}

class _ThreadCard extends StatelessWidget {
  final ThreadModel thread;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onRepost;
  final VoidCallback onMore;
  final bool isDarkMode;

  const _ThreadCard({
    required this.thread,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onRepost,
    required this.onMore,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final card = isDarkMode ? const Color(0xFF1A1A1C) : Colors.white;
    final border = isDarkMode ? const Color(0xFF2A2A2D) : const Color(0xFFEDEDEF);
    final primaryText = isDarkMode ? Colors.white : Colors.black;
    final secondaryText = isDarkMode ? const Color(0xFFA1A1AA) : Colors.grey.shade600;
    final softFill = isDarkMode ? const Color(0xFF222224) : const Color(0xFFF5F5F7);
    final line = isDarkMode ? const Color(0xFF2D2D31) : const Color(0xFFE9E9EC);

    return Hero(
      tag: 'thread_${thread.username}_${thread.time}_${thread.content.hashCode}',
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black45 : const Color(0x08000000),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(thread.avatarUrl),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 2,
                    height: thread.imageUrl != null || thread.imageBytes != null ? 120 : 58,
                    decoration: BoxDecoration(
                      color: line,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 44,
                    height: 18,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: const [
                        Positioned(
                          left: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=5'),
                          ),
                        ),
                        Positioned(
                          left: 12,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=7'),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=9'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(primaryText, secondaryText),
                    if (thread.isRepost) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: softFill,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'Reposted by you',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    if (thread.content.isNotEmpty)
                      Text(
                        thread.content,
                        style: TextStyle(
                          fontSize: 15,
                          color: primaryText,
                          height: 1.5,
                        ),
                      ),
                    if (thread.content.isNotEmpty) const SizedBox(height: 12),
                    if (thread.imageBytes != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.memory(
                          thread.imageBytes!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ] else if (thread.imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: AspectRatio(
                          aspectRatio: 16 / 11,
                          child: Image.network(
                            thread.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: softFill,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 34,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        _actionIcon(
                          thread.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: thread.isLiked ? Colors.red : primaryText,
                          onTap: onLike,
                          bg: softFill,
                        ),
                        const SizedBox(width: 12),
                        _actionIcon(
                          Icons.mode_comment_outlined,
                          onTap: onComment,
                          color: primaryText,
                          bg: softFill,
                        ),
                        const SizedBox(width: 12),
                        _actionIcon(
                          Icons.repeat,
                          onTap: onRepost,
                          color: primaryText,
                          bg: softFill,
                        ),
                        const SizedBox(width: 12),
                        _actionIcon(
                          Icons.send_outlined,
                          onTap: onShare,
                          color: primaryText,
                          bg: softFill,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: onComment,
                      child: Text(
                        '${thread.replies} replies · ${thread.likes} likes',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (thread.comments.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: '${thread.comments.last.username} ',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: primaryText,
                              ),
                            ),
                            TextSpan(text: thread.comments.last.text),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: onMore,
                splashRadius: 20,
                icon: Icon(Icons.more_horiz, color: primaryText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryText, Color secondaryText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  thread.username,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: primaryText,
                  ),
                ),
              ),
              if (thread.isVerified) ...[
                const SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4DA3FF).withOpacity(0.25),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    size: 17,
                    color: Color(0xFF4DA3FF),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          thread.time,
          style: TextStyle(
            color: secondaryText,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _actionIcon(
      IconData icon, {
        required Color color,
        required VoidCallback onTap,
        required Color bg,
      }) {
    final bool isLiked = color == Colors.red;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: AnimatedScale(
            scale: isLiked ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 180),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

class _CommentsSheet extends StatefulWidget {
  final ThreadModel thread;
  final Function(String) onAddComment;
  final bool isDarkMode;

  const _CommentsSheet({
    required this.thread,
    required this.onAddComment,
    required this.isDarkMode,
  });

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  late List<ThreadComment> _comments;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _comments = List<ThreadComment>.from(widget.thread.comments);
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newComment = ThreadComment(
      username: 'socmed_user',
      text: text,
      time: 'now',
    );

    setState(() {
      _comments.add(newComment);
    });

    widget.onAddComment(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final primaryText = widget.isDarkMode ? Colors.white : Colors.black;
    final secondaryText =
    widget.isDarkMode ? const Color(0xFFA1A1AA) : Colors.grey;
    final fill =
    widget.isDarkMode ? const Color(0xFF222224) : const Color(0xFFF5F5F7);

    return _ModernSheet(
      isDarkMode: widget.isDarkMode,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          children: [
            Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Comments',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _comments.isEmpty
                  ? Center(
                child: Text(
                  'No comments yet.',
                  style: TextStyle(color: secondaryText),
                ),
              )
                  : ListView.separated(
                itemCount: _comments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/100?img=${(index % 10) + 1}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    comment.username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: primaryText,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    comment.time,
                                    style: TextStyle(
                                      color: secondaryText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment.text,
                                style: TextStyle(color: primaryText),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage:
                  NetworkImage('https://i.pravatar.cc/150?img=11'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: primaryText),
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: TextStyle(color: secondaryText),
                      filled: true,
                      fillColor: fill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isDarkMode ? Colors.white : Colors.black,
                    foregroundColor: widget.isDarkMode ? Colors.black : Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernSheet extends StatelessWidget {
  final Widget child;
  final bool isDarkMode;

  const _ModernSheet({
    required this.child,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF18181B) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black54 : const Color(0x14000000),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}