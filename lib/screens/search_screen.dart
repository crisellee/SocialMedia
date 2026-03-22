import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> searchHistory = [];

  // Save current search to history
  void saveSearch() {
    final query = searchController.text.trim();
    if (query.isNotEmpty && !searchHistory.contains(query)) {
      setState(() {
        searchHistory.insert(0, query);
        searchController.clear();
      });
    }
  }

  // Remove individual history item
  void removeHistoryItem(String item) {
    setState(() {
      searchHistory.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // SEARCH BAR WITH X BUTTON
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Type a name',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 9),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: saveSearch, // Save input to history
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // SEARCH HISTORY
              if (searchHistory.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: searchHistory.map((item) {
                      return Chip(
                        label: Text(item),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => removeHistoryItem(item),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}