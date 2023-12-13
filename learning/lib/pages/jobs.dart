import 'package:flutter/material.dart';
import 'package:learning/components/navbar.dart';
import 'package:learning/models/jobModels.dart';
import 'package:learning/repository/repositoryjobs.dart';
import 'package:learning/pages/filterjobs.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({Key? key}) : super(key: key);

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
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterJobs(
                      id: jobs[index].job_id,
                      position: jobs[index].position,
                    ),
                  ),
                );
              },
              title: Text(jobs[index].position),
              subtitle: Text(jobs[index].description),
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
