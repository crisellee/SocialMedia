import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/message_screen.dart';
import 'screens/reels_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/create_post_screen.dart';
import 'screens/threads_screen.dart';
import 'widgets/instagram_widgets.dart';
import 'models/post.dart';
import 'screens/chat_detail_screen.dart';

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
        dividerTheme: const DividerThemeData(
          thickness: 1,
          color: Color(0xFFEFEFEF),
        ),
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
    _updateScreens();
  }

  void _updateScreens() {
    _screens = [
      HomeScreen(
        onProfileTap: () => _navigateToProfile(),
        onMessagesTap: () => _navigateToMessages(),
        onNotificationsTap: () => _navigateToNotifications(),
      ),
      const SearchScreen(),
      const ThreadsScreen(),
      const ExploreScreen(),
      const ReelsScreen(),
      MessagesScreen(),
      const NotificationScreen(),
      CreatePostScreen(
        onPost: (newPost) {
          setState(() {
            posts.insert(0, newPost);
            NotificationScreen.addPostNotification(newPost);
            _selectedIndex = 0;
            _updateScreens();
          });
        },
      ),
      const ProfileScreen(),
    ];
  }

  void _navigateToProfile() {
    setState(() {
      _selectedIndex = MediaQuery.of(context).size.width > 800 ? 8 : 5;
    });
  }

  void _navigateToMessages() {
    setState(() {
      _selectedIndex = MediaQuery.of(context).size.width > 800 ? 5 : 6;
    });
  }

  void _navigateToNotifications() {
    setState(() {
      _selectedIndex = MediaQuery.of(context).size.width > 800 ? 6 : 7;
    });
  }

  int _getDisplayScreenIndex() {
    bool isWeb = MediaQuery.of(context).size.width > 800;

    if (isWeb) {
      return _selectedIndex;
    } else {
      if (_selectedIndex == 6 && _screens[5] is MessagesScreen) return 5;
      if (_selectedIndex == 7 && _screens[6] is NotificationScreen) return 6;

      switch (_selectedIndex) {
        case 0:
          return 0;
        case 1:
          return 1;
        case 2:
          return 2;
        case 3:
          return 4;
        case 4:
          return 7;
        case 5:
          return 8;
        default:
          return 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int screenIndex = _getDisplayScreenIndex();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return _buildWebLayout(screenIndex);
        } else {
          return _buildMobileLayout(screenIndex);
        }
      },
    );
  }

  Widget _buildMobileLayout(int screenIndex) {
    return Scaffold(
      body: IndexedStack(
        index: screenIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 5 ? 5 : _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1 ? Icons.search : Icons.search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 2 ? Icons.forum : Icons.forum_outlined),
            label: 'Threads',
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 3 ? Icons.movie : Icons.movie_outlined),
            label: 'Reels',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
          ),
          const BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
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
                      child: SuggestedSidebar(
                        onProfileTap: () => _navigateToProfile(),
                      ),
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

  const WebSidebar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 40,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Text(
                    'Instagram',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _SidebarItem(
                  icon: Icons.home,
                  label: 'Home',
                  isSelected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
                _SidebarItem(
                  icon: Icons.search,
                  label: 'Search',
                  isSelected: selectedIndex == 1,
                  onTap: () => onTap(1),
                ),
                _SidebarItem(
                  icon: Icons.forum_outlined,
                  label: 'Threads',
                  isSelected: selectedIndex == 2,
                  onTap: () => onTap(2),
                ),
                _SidebarItem(
                  icon: Icons.explore_outlined,
                  label: 'Explore',
                  isSelected: selectedIndex == 3,
                  onTap: () => onTap(3),
                ),
                _SidebarItem(
                  icon: Icons.movie_outlined,
                  label: 'Reels',
                  isSelected: selectedIndex == 4,
                  onTap: () => onTap(4),
                ),
                _SidebarItem(
                  icon: Icons.chat_bubble_outline,
                  label: 'Messages',
                  isSelected: selectedIndex == 5,
                  onTap: () => onTap(5),
                ),
                _SidebarItem(
                  icon: Icons.favorite_border,
                  label: 'Notifications',
                  isSelected: selectedIndex == 6,
                  onTap: () => onTap(6),
                ),
                _SidebarItem(
                  icon: Icons.add_box_outlined,
                  label: 'Create',
                  isSelected: selectedIndex == 7,
                  onTap: () => onTap(7),
                ),
                _SidebarItem(
                  iconWidget: const CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                  label: 'Profile',
                  isSelected: selectedIndex == 8,
                  onTap: () => onTap(8),
                ),
                const Spacer(),
                _SidebarItem(
                  icon: Icons.menu,
                  label: 'More',
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
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

  const _SidebarItem({
    this.icon,
    this.iconWidget,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              iconWidget ?? Icon(icon, size: 28, color: Colors.black),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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