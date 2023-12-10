import 'package:flutter/material.dart';
import 'package:learning/components/navbar.dart';
import 'package:learning/models/jobModels.dart';
import 'package:learning/repository/repositoryjobs.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  List<Job> jobs = [];
  RepositoryJobs repositoryJobs = RepositoryJobs();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    jobs = await repositoryJobs.getJobsData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Navbar(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Jobs'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Handle the onTap event
                },
                child: ListTile(
                  onTap: () {},
                  title: Text(jobs[index].position),
                  subtitle: Text(jobs[index].description),
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
        ));
  }
}
