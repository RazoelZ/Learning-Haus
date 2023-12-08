import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:learning/repository/repository_book.dart';

class AddCars extends StatefulWidget {
  const AddCars({super.key, required this.title});

  final String title;

  @override
  State<AddCars> createState() => _AddCarsState();
}

class _AddCarsState extends State<AddCars> {
  RepositoryBooks repository = RepositoryBooks();
  TextEditingController authorController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController publisherController = TextEditingController();

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
              decoration: const InputDecoration(
                labelText: 'Author',
              ),
              onChanged: (value) => setState(() {}),
              controller: authorController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              onChanged: (value) => setState(() {}),
              controller: titleController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Publisher',
              ),
              onChanged: (value) => setState(() {}),
              controller: publisherController,
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                onPressed: () async {
                  bool response = await repository.postData(
                    authorController.text,
                    titleController.text,
                    publisherController.text,
                  );
                  if (response == true) {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      title: 'Success',
                      text: 'Car added successfully',
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      title: 'Error',
                      text: 'Failed to add car',
                    );
                  }
                },
                child: const Text('Add Car'),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
