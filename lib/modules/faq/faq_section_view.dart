import 'package:flutter/material.dart';

class FaqSection extends StatelessWidget {
  FaqSection({super.key});

  final questions = [
    'is potsoft free to use',
    'how to get business account',
    'how to upload potholes',
  ];

  final answers = [
    'yes, potsoft is completely free to use. you can upload any no of potholes without charging anything.',
    'In the drawer section, you can click on "Request for Business Acc?" and place a request, and further your request will be approved by the admin team and will be updated soon',
    '- click on "Add new" button on the right lower side in home section\n- allow locations if not allowed\n- capture the photo of pothole\n- kindly enter the suitable description\n\n- finally tap on "Upload" button to upload the pothole.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ\'s')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: questions
              .map(
                (ech) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ExpansionTile(
                    title: Text(ech),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(answers[questions.indexOf(ech)]),
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
