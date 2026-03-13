import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart'; // Para sa recording
import 'package:audioplayers/audioplayers.dart'; // Para sa playback
import '../models/chat_model.dart';

class ChatDetailScreen extends StatefulWidget {
  final ChatConversation conversation;
  const ChatDetailScreen({super.key, required this.conversation});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  Color _bubbleColor = Colors.blue;
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;

  // ✅ 1. POPUP MENU FUNCTIONS
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Bubble Color"),
        content: Wrap(
          spacing: 10,
          children: [Colors.blue, Colors.purple, Colors.pink, Colors.green, Colors.orange].map((color) {
            return GestureDetector(
              onTap: () {
                setState(() => _bubbleColor = color);
                Navigator.pop(context);
              },
              child: CircleAvatar(backgroundColor: color, radius: 20),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _clearConversation() {
    setState(() => widget.conversation.messages.clear());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chat cleared")));
  }

  // ✅ 2. IMAGE PICKER FUNCTION
  Future<void> _handleImagePick() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        widget.conversation.messages.add(
          ChatMessage(
            senderId: "currentUser",
            text: "IMG:${image.path}",
            timestamp: DateTime.now(),
          ),
        );
      });
    }
  }

  // ✅ 3. VOICE RECORDING FUNCTION
  Future<void> _handleVoiceRecord() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        if (!_isRecording) {
          const config = RecordConfig();
          await _audioRecorder.start(config, path: '');
          setState(() => _isRecording = true);
        } else {
          final path = await _audioRecorder.stop();
          setState(() {
            _isRecording = false;
            if (path != null) {
              widget.conversation.messages.add(
                ChatMessage(
                  senderId: "currentUser",
                  text: "AUDIO_MSG:$path",
                  timestamp: DateTime.now(),
                ),
              );
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Mic Error: $e");
    }
  }

  Future<void> _playAudio(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
  }

  // ✅ 4. MEDIA CONTENT BUILDER
  Widget _buildMessageContent(ChatMessage msg, bool isMe) {
    if (msg.text.startsWith("IMG:")) {
      String imagePath = msg.text.replaceFirst("IMG:", "");
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imagePath,
          width: 250,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
        ),
      );
    } else if (msg.text.startsWith("AUDIO_MSG:")) {
      return _buildAudioMessage(msg.text.replaceFirst("AUDIO_MSG:", ""), isMe);
    }
    return Text(msg.text, style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 15));
  }

  Widget _buildAudioMessage(String path, bool isMe) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.play_circle_fill, color: isMe ? Colors.white : Colors.blue, size: 32),
          onPressed: () => _playAudio(path),
        ),
        const SizedBox(width: 4),
        Stack(
          children: [
            Container(width: 100, height: 4, decoration: BoxDecoration(color: isMe ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(2))),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: isMe ? Colors.white : Colors.blue, borderRadius: BorderRadius.circular(2))),
          ],
        ),
        const SizedBox(width: 8),
        Text("0:05", style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 12)),
      ],
    );
  }

  void _handleSendMessage() {
    final String text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        widget.conversation.messages.add(
          ChatMessage(senderId: "currentUser", text: text, timestamp: DateTime.now()),
        );
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(widget.conversation.username, style: const TextStyle(color: Colors.black)),
        // ✅ 3 DOTS MENU DITO
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'color') _showColorPicker();
              if (value == 'clear') _clearConversation();
              if (value == 'share') ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link Shared!")));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'color', child: ListTile(leading: Icon(Icons.palette), title: Text('Bubble Color'))),
              const PopupMenuItem(value: 'clear', child: ListTile(leading: Icon(Icons.delete_sweep), title: Text('Clear Convo'))),
              const PopupMenuItem(value: 'share', child: ListTile(leading: Icon(Icons.share), title: Text('Share'))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.conversation.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.conversation.messages[index];
                final isMe = msg.senderId == "currentUser";
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe ? _bubbleColor : Colors.grey[200],
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: _buildMessageContent(msg, isMe),
                  ),
                );
              },
            ),
          ),

          // ✅ INPUT BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey[200]!))),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic_none, color: _isRecording ? Colors.red : Colors.black),
                    onPressed: _handleVoiceRecord
                ),
                IconButton(
                    icon: const Icon(Icons.image_outlined),
                    onPressed: _handleImagePick
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: "Message...", border: InputBorder.none),
                    onSubmitted: (_) => _handleSendMessage(),
                  ),
                ),
                TextButton(
                  onPressed: _handleSendMessage,
                  child: const Text("Send", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}