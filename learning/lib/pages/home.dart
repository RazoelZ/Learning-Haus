import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:learning/components/navbar.dart';
import 'package:learning/models/jobModels.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:learning/models/companyModels.dart';
import 'package:learning/models/userModels.dart';
import 'package:learning/repository/repository.dart';
import 'package:learning/repository/repositorycompanies.dart';
import 'package:learning/repository/repositoryjobs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? nama; // Consider giving a default value if null is not intended.
  late PageController pageController;
  late SideMenuController sideMenu;

  List<User> users = [];
  List<Job> jobs = [];
  List<Company> companies = [];

  Repository repository = Repository();
  RepositoryJobs jobRepository = RepositoryJobs();
  RepositoryCompanies companyRepository = RepositoryCompanies();

  @override
  void initState() {
    super.initState();
    fetchData();
    pageController = PageController();
    sideMenu = SideMenuController();

    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });

    _loadPrefs(); // Call the _loadPrefs method in initState
  }

  // Method to retrieve data from SharedPreferences
  Future<void> _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama =
          prefs.getString('name') ?? 'Guest'; // Provide a default value if null
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    users = await repository.getUserData();
    jobs = await jobRepository.getJobsData();
    companies = await companyRepository.getCompaniesData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Navbar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to the start (left)
          children: [
            const Text(
              'Selamat datang di aplikasi Learning',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Halo, ${nama != null ? nama! : ''}',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Data karyawan aktif"),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.blue,
                          value: 40,
                          title: 'Karyawan aktif',
                        ),
                        PieChartSectionData(
                          color: Colors.red,
                          value: 30,
                          title: 'Karyawan magang',
                        ),
                        PieChartSectionData(
                          color: Colors.green,
                          value: 15,
                          title: 'Karyawan cuti',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("Data penjualan"),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 3),
                            FlSpot(1, 1),
                            FlSpot(2, 4),
                            FlSpot(3, 3),
                          ],
                          isCurved: true,
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
