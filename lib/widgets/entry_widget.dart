//MyActivityWidget
//import 'package:flutter/material.dart';

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
  final String ?definition;


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(children: [
                            //Text(id),
                            Text('Entry: $name'),
                            Text('Definition: $definition'),
                        
                          ]),
    );
  }
}