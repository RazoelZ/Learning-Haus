import 'package:flutter/material.dart';
import 'package:learning/pages/User.dart';
import 'package:learning/pages/jobs.dart';
import 'package:learning/pages/home.dart';
import 'package:learning/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning/pages/companies.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String? nama;
  String? email;

  Future<void> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('name') ?? 'Guest';

      email = prefs.getString('email') ?? 'Guest';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('$nama',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                )),
            accountEmail: Text('$email'),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                image:
                    AssetImage('assets/1.jpeg'), // Adjust the path accordingly
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Karyawan'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.work),
            title: const Text('Pekerjaan'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const JobsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.corporate_fare),
            title: const Text('Company'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CompanyPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ],
      ),
    );
  }
}
