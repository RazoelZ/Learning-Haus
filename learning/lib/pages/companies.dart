import 'package:flutter/material.dart';
import 'package:learning/components/navbar.dart';
import 'package:learning/models/companyModels.dart';
import 'package:learning/repository/repositorycompanies.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  List<Company> companies = [];
  RepositoryCompanies repositoryCompanies = RepositoryCompanies();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    companies = await repositoryCompanies.getCompaniesData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Company'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: companies.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Handle the onTap event
              },
              child: ListTile(
                onTap: () {},
                title: Text(companies[index].name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {},
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
