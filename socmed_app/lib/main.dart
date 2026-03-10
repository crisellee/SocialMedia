import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'widgets/instagram_widgets.dart';

void main() {
  runApp(const InstagramClone());
}

class InstagramClone extends StatelessWidget {
  const InstagramClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        dividerTheme: const DividerThemeData(thickness: 1, color: Color(0xFFEFEFEF)),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onProfileTap: () => _navigateToProfile()), // Index 0
      const SearchScreen(),  // Index 1
      const ExploreScreen(), // Index 2
      const Center(child: Text('Reels Section')), // Index 3
      const Center(child: Text('Messages Section')), // Index 4
      const Center(child: Text('Notifications Section')), // Index 5
      const Center(child: Text('Create Post Section')), // Index 6
      const ProfileScreen(), // Index 7
    ];
  }

  void _navigateToProfile() {
    setState(() {
      _selectedIndex = MediaQuery.of(context).size.width > 800 ? 7 : 4;
    });
  }

  int _getDisplayScreenIndex() {
    bool isWeb = MediaQuery.of(context).size.width > 800;
    if (isWeb) {
      return _selectedIndex; 
    } else {
      switch (_selectedIndex) {
        case 0: return 0; // Home
        case 1: return 2; // Mobile Search Icon -> Explore Grid
        case 2: return 3; // Reels
        case 3: return 6; // Add Post
        case 4: return 7; // Profile
        default: return 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int screenIndex = _getDisplayScreenIndex();
    
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        return _buildWebLayout(screenIndex);
      } else {
        return _buildMobileLayout(screenIndex);
      }
    });
  }

  Widget _buildMobileLayout(int screenIndex) {
    return Scaffold(
      appBar: (screenIndex == 0) 
        ? AppBar(
            title: const Text('Instagram'),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
            ],
          )
        : null,
      body: IndexedStack(
        index: screenIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: [
          BottomNavigationBarItem(icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          const BottomNavigationBarItem(icon: Icon(Icons.movie_outlined), label: 'Reels'),
          const BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: 'Add'),
          const BottomNavigationBarItem(
            icon: CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildWebLayout(int screenIndex) {
    return Scaffold(
      body: Row(
        children: [
          WebSidebar(
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: screenIndex == 0 ? 630 : double.infinity,
                      child: IndexedStack(
                        index: screenIndex,
                        children: _screens,
                      ),
                    ),
                  ),
                ),
                if (screenIndex == 0 && MediaQuery.of(context).size.width > 1100)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 40, right: 20),
                    child: SizedBox(
                      width: 320, 
                      child: SuggestedSidebar(onProfileTap: () => _navigateToProfile())
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WebSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const WebSidebar({super.key, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 25),
            child: Text('Instagram', style: TextStyle(fontFamily: 'serif', fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          _SidebarItem(icon: Icons.home, label: 'Home', isSelected: selectedIndex == 0, onTap: () => onTap(0)),
          _SidebarItem(icon: Icons.search, label: 'Search', isSelected: selectedIndex == 1, onTap: () => onTap(1)),
          _SidebarItem(icon: Icons.explore_outlined, label: 'Explore', isSelected: selectedIndex == 2, onTap: () => onTap(2)),
          _SidebarItem(icon: Icons.movie_outlined, label: 'Reels', isSelected: selectedIndex == 3, onTap: () => onTap(3)),
          _SidebarItem(icon: Icons.chat_bubble_outline, label: 'Messages', isSelected: selectedIndex == 4, onTap: () => onTap(4)),
          _SidebarItem(icon: Icons.favorite_border, label: 'Notifications', isSelected: selectedIndex == 5, onTap: () => onTap(5)),
          _SidebarItem(icon: Icons.add_box_outlined, label: 'Create', isSelected: selectedIndex == 6, onTap: () => onTap(6)),
          _SidebarItem(
            iconWidget: const CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11')),
            label: 'Profile',
            isSelected: selectedIndex == 7,
            onTap: () => onTap(7),
          ),
          const Spacer(),
          _SidebarItem(icon: Icons.menu, label: 'More', isSelected: false, onTap: () {}),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({this.icon, this.iconWidget, required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              iconWidget ?? Icon(icon, size: 28, color: Colors.black),
              const SizedBox(width: 16),
              Text(label, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }
}
