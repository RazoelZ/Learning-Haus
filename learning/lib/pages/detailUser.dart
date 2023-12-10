import 'package:flutter/material.dart';
import 'package:learning/components/navbar.dart';

class DetailUser extends StatefulWidget {
  const DetailUser({super.key, this.id});

  final int? id;

  @override
  State<DetailUser> createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Detail User'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Nama'),
            const Text('Email'),
            const Text('Password'),
            const Text('Role'),
          ],
        ),
      ),
    );
  }
}
