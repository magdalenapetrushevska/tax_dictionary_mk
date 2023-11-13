import 'package:flutter/material.dart';

class EntryWidget extends StatelessWidget {
  const EntryWidget({
    Key? key,
    required this.id,
    required this.name,
    required this.definition,
  }) : super(key: key);

  final String id;
  final String name;
  final String? definition;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(children: [
        const Text(
          'Entry: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          name,
        ),
        const Text(
          'Definition: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          definition!,
        ),
      ]),
    );
  }
}
