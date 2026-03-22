import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post.dart';

class CreatePostScreen extends StatefulWidget {
  final Function(PostData newPost) onPost;

  const CreatePostScreen({super.key, required this.onPost});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  File? _image;
  final ImagePicker picker = ImagePicker();
  final TextEditingController captionController = TextEditingController();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void postImage() {
    String caption = captionController.text;

    if (_image == null && caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add caption or image")),
      );
      return;
    }

    // Gawa ng bagong PostData object
    final newPost = PostData(
      name: "John Rey", // Default name for now
      profile: "https://i.pravatar.cc/300",
      postImage: _image?.path ?? 'https://picsum.photos/600/600?random=99', 
      caption: caption,
      likes: 0,
    );

    widget.onPost(newPost);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post Uploaded")),
    );
    
    // I-reset ang state pagkatapos mag-post
    setState(() {
      _image = null;
      captionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        actions: [
          TextButton(
            onPressed: postImage,
            child: const Text(
              "POST",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            ListTile(
              leading: const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/300"),
              ),
              title: const Text(
                "John Rey",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Public"),
            ),

            // Caption Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: captionController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 10),

            // Image Preview
            if (_image != null)
              Stack(
                children: [
                  Image.file(
                    _image!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),

                  Positioned(
                    right: 10,
                    top: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),

            const Divider(),

            // Post Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: pickImage,
                  icon: const Icon(Icons.photo, color: Colors.green),
                  label: const Text("Photo"),
                ),

                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.videocam, color: Colors.red),
                  label: const Text("Video"),
                ),

                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.tag_faces, color: Colors.orange),
                  label: const Text("Feeling"),
                ),
              ],
            ),

            const Divider(),
          ],
        ),
      ),
    );
  }
}
