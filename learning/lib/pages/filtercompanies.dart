import 'package:flutter/material.dart';
import 'package:learning/components/navbar.dart';
import 'package:learning/models/userModels.dart';
import 'package:intl/intl.dart';
import 'package:learning/repository/repositoryjobs.dart';

class FilterCompanies extends StatefulWidget {
  const FilterCompanies({Key? key, this.id, this.name});

  final int? id;
  final String? name;

  @override
  State<FilterCompanies> createState() => _FilterCompaniesState();
}

class _FilterCompaniesState extends State<FilterCompanies> {
  List<User> users = [];
  RepositoryJobs repository = RepositoryJobs();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    users = await repository.getFilteredEmployee(widget.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${widget.name}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  String timestamp = users[index].created_at ?? "no data";
                  DateTime dateTime = DateTime.parse(timestamp);

                  return GestureDetector(
                    child: ListTile(
                      onTap: () {},
                      title: Text(users[index].name),
                      subtitle: Text(users[index].email),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Masuk Tanggal'),
                          Text(DateFormat('dd MMMM yyyy').format(dateTime)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
