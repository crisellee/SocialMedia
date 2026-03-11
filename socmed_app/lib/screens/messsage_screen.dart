import 'package:flutter/material.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({super.key});

  @override
  State<MessengerScreen> createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  // Sample data para sa Notes
  final List<Map<String, String>> notes = [
    {"name": "Your Note", "note": "Share a thought...", "image": ""},
    {"name": "Juan", "note": "Kape tayo!", "image": "https://i.pravatar.cc/150?u=1"},
    {"name": "Maria", "note": "Focusing ✍️", "image": "https://i.pravatar.cc/150?u=2"},
    {"name": "Pedro", "note": "Low batt.", "image": "https://i.pravatar.cc/150?u=3"},
  ];

  // Sample data para sa Chats
  final List<Map<String, String>> chats = [
    {"name": "Juan Dela Cruz", "message": "Omsim bro!", "time": "10:20 AM"},
    {"name": "Maria Clara", "message": "Napadala mo na yung file?", "time": "9:45 AM"},
    {"name": "Pedro Penduko", "message": "G na mamaya!", "time": "Yesterday"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          // Notes Section
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: notes[index]['image'] != ""
                                ? NetworkImage(notes[index]['image']!)
                                : null,
                            child: notes[index]['image'] == "" ? const Icon(Icons.add, size: 30) : null,
                          ),
                          // Note Bubble
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                              ),
                              constraints: const BoxConstraints(maxWidth: 60),
                              child: Text(
                                notes[index]['note']!,
                                style: const TextStyle(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(notes[index]['name']!, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),

          // Chats List
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=${index + 10}"),
                  ),
                  title: Text(chats[index]['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Row(
                    children: [
                      Expanded(child: Text(chats[index]['message']!, overflow: TextOverflow.ellipsis)),
                      Text(" • ${chats[index]['time']}"),
                    ],
                  ),
                  onTap: () {
                    // Navigate to chat detail
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}