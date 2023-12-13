import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:learning/pages/roleuser.dart';
import 'package:learning/repository/repository.dart';
import 'package:learning/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visible = false;
  Repository repository = Repository();

  void _toggleVisibility() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController..text = "Jonny1@gmail.com",
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Username'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              controller: _passwordController..text = "password",
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                repository.Login(
                        _emailController.text, _passwordController.text)
                    .then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt("id", value.id);
                  prefs.setString("name", value.name);
                  prefs.setString("email", value.email);
                  if (value.role == 1) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  } else if (value.role == 2) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RoleUserPage(
                                  id: value.id,
                                )));
                  }
                }).catchError((e) {
                  CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      title: 'Error',
                      text: e.toString());
                });
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    ));
  }
}
