import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/book_models.dart';
import 'package:learning/repository/repository.dart';
import 'package:learning/models/car_models.dart';
import 'package:learning/repository/repository_book.dart';

class updatecars extends StatefulWidget {
  const updatecars({
    super.key,
    required this.title,
    required this.id,
    required this.author,
    required this.titlebook,
    required this.publisher,
  });

  final String title;
  final int id;
  final String author;
  final String titlebook;
  final String publisher;

  @override
  State<updatecars> createState() => _updatecarsState();
}

class _updatecarsState extends State<updatecars> {
  RepositoryBooks repository = RepositoryBooks();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _publisherController = TextEditingController();

  List<Books> books = [];

  getData() async {
    books = await repository.getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authorController.text = widget.author;
    _titleController.text = widget.titlebook;
    _publisherController.text = widget.publisher;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Car Name',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Car Version',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _publisherController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Car Model',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool response = await repository.putData(
                  widget.id,
                  _authorController.text,
                  _titleController.text,
                  _publisherController.text,
                );
                if (response) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: 'Car updated successfully!',
                    onConfirmBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: 'Failed to update car!',
                  );
                }
              },
              child: const Text('Update Car'),
            ),
          ],
        ),
      ),
    );
  }
}
