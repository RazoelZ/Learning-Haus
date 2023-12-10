import 'package:flutter/material.dart';
import 'package:learning/components/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? nama; // Consider giving a default value if null is not intended.
  late PageController pageController;
  late SideMenuController sideMenu;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    sideMenu = SideMenuController();

    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });

    _loadPrefs(); // Call the _loadPrefs method in initState
  }

  // Method to retrieve data from SharedPreferences
  Future<void> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama =
          prefs.getString('name') ?? 'Guest'; // Provide a default value if null
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to the start (left)
          children: [
            Text(
              'Selamat datang di aplikasi Learning',
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              '${nama != null ? nama! : ''}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
