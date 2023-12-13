import 'package:flutter/material.dart';
import 'package:learning/components/navbar.dart';
import 'package:learning/models/userModels.dart';
import 'package:learning/repository/repository.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:learning/pages/detailUser.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> users = [];
  Repository repository = Repository();

  String? nama; // Consider giving a default value if null is not intended.

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    users = await repository.getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Karyawan'),
        actions: [
          IconButton(
            onPressed: () {
              fetchData();
            },
            icon: const Icon(Icons.update),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Handle the onTap event
              },
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailUserPage(
                                id: users[index].id,
                              )));
                },
                title: Text(users[index].name),
                subtitle: Text(users[index].email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        bool response =
                            await repository.DeleteUser(users[index].id);
                        if (response == true) {
                          setState(() {
                            users.removeAt(index);
                          });
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            text: 'Data deleted successfully!',
                          );
                        } else {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            text: 'Failed to delete data!',
                          );
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
