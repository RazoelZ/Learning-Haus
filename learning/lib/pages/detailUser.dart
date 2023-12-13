import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:learning/components/navbar.dart';
import 'package:learning/models/detailuser.dart';
import 'package:learning/models/jobModels.dart';
import 'package:learning/models/companyModels.dart';
import 'package:learning/pages/User.dart';
import 'package:learning/repository/repository.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:learning/repository/repositorycompanies.dart';
import 'package:learning/repository/repositoryjobs.dart';

class DetailUserPage extends StatefulWidget {
  const DetailUserPage({Key? key, this.id}) : super(key: key);

  final int? id;

  @override
  State<DetailUserPage> createState() => _DetailUserPageState();
}

class _DetailUserPageState extends State<DetailUserPage> {
  List<DetailUser> detailUser = [];
  List<Job> job = [];
  List<Company> company = [];
  Repository repository = Repository();
  RepositoryJobs jobRepository = RepositoryJobs();
  RepositoryCompanies companyRepository = RepositoryCompanies();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchJobData();
    fetchCompanyData();
  }

  Future<void> fetchData() async {
    detailUser = await repository.getDetailUser(widget.id!);
    setState(() {});
  }

  Future<void> fetchJobData() async {
    job = await jobRepository.getJobsData();
    setState(() {});
  }

  Future<void> fetchCompanyData() async {
    company = await companyRepository.getCompaniesData();
    setState(() {});
  }

  Future<void> showChangeJobDialog(BuildContext context) async {
    String? selectedJob;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Job'),
          content: DropdownSearch<String>(
            asyncItems: (String filter) async {
              return job.map((e) => e.position).toList();
            },
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration:
                  InputDecoration(labelText: "Ganti pekerjaan"),
            ),
            selectedItem: job[0].position,
            onChanged: (String? value) {
              selectedJob = value;
            },
            popupProps: const PopupProps.menu(
              showSelectedItems: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Job selectedJobObject = job.firstWhere(
                  (element) => element.position == selectedJob,
                );

                bool changejob = await jobRepository.changeJob(
                    detailUser[0].id, selectedJobObject.job_id);
                if (changejob) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: "Berhasil mengubah pekerjaan",
                    onConfirmBtnTap: () {
                      fetchData();
                      Navigator.pop(context);
                    },
                  );
                } else {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: "Gagal mengubah pekerjaan",
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showChangeCompanyDialog(BuildContext context) async {
    String? selectedcompany;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Company'),
          content: DropdownSearch<String>(
            asyncItems: (String filter) async {
              return company.map((e) => e.name).toList();
            },
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration:
                  InputDecoration(labelText: "Ganti perusahaan"),
            ),
            selectedItem: company[0].name,
            onChanged: (String? value) {
              selectedcompany = value;
            },
            popupProps: const PopupProps.menu(
              showSelectedItems: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Company selectedCompanyObject = company.firstWhere(
                  (element) => element.name == selectedcompany,
                );

                bool changejob = await companyRepository.changeCompany(
                    detailUser[0].id, selectedCompanyObject.company_id);
                if (changejob) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: "Berhasil mengubah pekerjaan",
                    onConfirmBtnTap: () {
                      fetchData();
                      Navigator.pop(context);
                    },
                  );
                } else {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: "Gagal mengubah pekerjaan",
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Detail User'),
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
        child: detailUser.isNotEmpty
            ? ListView.builder(
                itemCount: 1, // Since you are showing details of a single user
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "Name: ${detailUser[0].name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${detailUser[0].email}"),
                        Text(
                          "Tanggal Masuk: ${_formatDate(detailUser[0].tanggal_masuk)}",
                        ),
                        Text("Job: ${detailUser[0].job}"),
                        Text("Salary: Rp.${detailUser[0].salary}"),
                        Text("Company: ${detailUser[0].company}"),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                showChangeJobDialog(context);
                              },
                              child: const Text('Change Job'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showChangeCompanyDialog(context);
                              },
                              child: const Text('Change Company'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Text('Loading...'),
      ),
    );
  }

  String _formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }
}
