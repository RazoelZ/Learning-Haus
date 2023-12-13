import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learning/models/detailuser.dart';
import 'package:learning/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning/repository/repository.dart';

class RoleUserPage extends StatefulWidget {
  const RoleUserPage({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  State<RoleUserPage> createState() => _RoleUserPageState();
}

class _RoleUserPageState extends State<RoleUserPage> {
  List<DetailUser> detailUser = [];
  Repository repository = Repository();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    detailUser = await repository.getDetailUser(widget.id!);
    setState(() {});
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp != null) {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('dd MMMM yyyy').format(dateTime);
    } else {
      return "No timestamp available";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Add this line to hide the back button
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nama : ${detailUser[0].name}",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Email anda  : ",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              detailUser[0].email,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Pekerjaan anda adalah :",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              detailUser[0].job,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Anda masuk pada tanggal : ",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              _formatTimestamp(detailUser[0].tanggal_masuk),
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Anda bekerja di : ",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            Text(
              detailUser[0].company,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
