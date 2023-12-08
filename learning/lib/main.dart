import 'package:flutter/material.dart';
import 'package:learning/models/book_models.dart';
import 'package:learning/repository/repository_book.dart';
import 'package:learning/pages/addcars.dart';
import 'package:learning/pages/updatecars.dart';
import 'package:cool_alert/cool_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      routes: {
        '/home': (context) =>
            const MyHomePage(title: 'Integrating API with Flutter'),
        'addCars': (context) => const AddCars(title: 'Add Books'),
      },
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Integrating API with Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Books> books = [];
  RepositoryBooks repository = RepositoryBooks();

  Future<void> fetchData() async {
    books = await repository.getData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              fetchData(); // Refresh data when the refresh button is pressed
            },
            icon: const Icon(Icons.update),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => updatecars(
                      title: 'Update Cars',
                      id: books[index].id,
                      author: books[index].author,
                      titlebook: books[index].title,
                      publisher: books[index].publisher,
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(books[index].title),
                subtitle: Text(books[index].publisher),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        bool response =
                            await repository.deleteData(books[index].id);
                        if (response == true) {
                          // Remove the item from the list after successful deletion
                          setState(() {
                            books.removeAt(index);
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
                      icon: Icon(Icons.delete),
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
          Navigator.pushNamed(context, 'addCars');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
