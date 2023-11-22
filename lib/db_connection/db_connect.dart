

import 'dart:convert';
import 'package:tax_dictionary_mk/models/entry.dart';
import 'package:http/http.dart' as http;

class DBconnect {

  static const defaultDbURI = 'https://tax-dictionary-mk-default-rtdb.firebaseio.com/entries.json';

  Future<void> addEntry(Entry entry) async {
    final url = Uri.parse(defaultDbURI);
    http.post(url,
        body: json.encode({
          'name': entry.name,
          'definition': entry.definition,
        }));
  }

 Future<List<Entry>> fetchEntries() async {
    final url = Uri.parse(defaultDbURI);

    return http.get(url).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Entry> newEntries = [];

      data.forEach((key, value) {
        var newEntry = Entry(
          id: key,
          name: value['name'],
          definition: value['definition'],
        );
        newEntries.add(newEntry);
      });
      return newEntries;
    });
  }

  Future<Entry> fetchEntry(String name) async {
    final url = Uri.parse(defaultDbURI);

    return http.get(url).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;
      late Entry result;

      data.forEach((key, value) {
         if (name == value['name']) {
            result =  Entry(
          id: key,
          name: value['name'],
          definition: value['definition'],
        );
      }});

      return result;
    });
  }


}