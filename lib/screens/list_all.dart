import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tax_dictionary_mk/db_connection/db_connect.dart';
import 'package:tax_dictionary_mk/models/entry.dart';
import 'package:tax_dictionary_mk/widgets/entry_widget.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class AllEntriesScreen extends StatefulWidget {
  const AllEntriesScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AllEntriesScreenState createState() => _AllEntriesScreenState();
}

class _AllEntriesScreenState extends State<AllEntriesScreen> {
  _AllEntriesScreenState();

   var db = DBconnect();

  late Future _entries;


Future<List<Entry>> getData() async {
    return db.fetchEntries();
  }


  // Future<List<Entry>> extractData() async {
  //   final response = await http.Client()
  //       .get(Uri.parse('http://www.ujp.gov.mk/mk/recnik/poimi'));

  //   List<Entry> newEntries = [];

  //   if (response.statusCode == 200) {
  //     BeautifulSoup bsMain = BeautifulSoup(response.body);
  //     var startString = 'http://www.ujp.gov.mk';

  //     var retreivedData =
  //         bsMain.findAll('div', attrs: {'class': 'tbrow'}).toList();

  //     int id = 0;

  //     for (var element in retreivedData) {
  //       var finalLink = '';
  //       var pp = element.children;
  //       var dol = element.children.length;
  //       var baraj = '';
  //       if (dol == 2) {
  //         var startIndex = pp[1].outerHtml.indexOf('"');
  //         var endIndex = pp[1].outerHtml.lastIndexOf('"');
  //         var tailString = pp[1].outerHtml.substring(startIndex + 1, endIndex);
  //         finalLink = startString + tailString;
  //         var hashTagIndex = tailString.indexOf('#');
  //         baraj = tailString.substring(hashTagIndex + 1);
  //       } else {
  //         var startIndex = pp[0].outerHtml.indexOf('"');
  //         var endIndex = pp[0].outerHtml.lastIndexOf('"');
  //         var tailString = pp[0].outerHtml.substring(startIndex + 1, endIndex);
  //         finalLink = startString + tailString;
  //         var hashTagIndex = tailString.indexOf('#');
  //         baraj = tailString.substring(hashTagIndex + 1);
  //       }

  //       final responseForDefinition =
  //           await http.Client().get(Uri.parse(finalLink));

  //       BeautifulSoup bs = BeautifulSoup(responseForDefinition.body);

  //       var definitionElement = bs
  //           .find('a', attrs: {'name': baraj})!
  //           .nextElement
  //           ?.nextElement
  //           ?.text;

  //       var newEntry = Entry(
  //         id: id.toString(),
  //         name: element.text.trim(),
  //         definition: definitionElement,
  //       );
  //       newEntries.add(newEntry);
  //       id++;
  //     }
  //   }
  //   return newEntries;
  // }

  @override
  void initState() {
    _entries = getData();
    super.initState();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _entries as Future<List<Entry>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Entry>;
            if (extractedData.isNotEmpty) {
              return Scaffold(
                  body: NestedScrollView(
                      floatHeaderSlivers: true,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            title: const Text('Сите термини'),
                            backgroundColor: Colors.pink[400],
                            floating: true,
                            expandedHeight: 70.0,
                            forceElevated: innerBoxIsScrolled,
                          ),
                        ];
                      },
                      body: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: extractedData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                InkWell(
                                  child: Text(extractedData[index].name),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: EntryWidget(
                                            id: extractedData[index].id,
                                            name: extractedData[index].name,
                                            definition:
                                                extractedData[index].definition,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                const Divider(
                                  color: Colors.black,
                                  height: 25,
                                  thickness: 2,
                                  indent: 25,
                                  endIndent: 25,
                                ),
                              ],
                            );
                          })));
            }
            else{
              return const Center(
            child: Text('Податоците моментално не се достапни. Ве молиме обидете се подоцна.'),
          );
            }
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return const Center(
          child: Text('No data'),
        );
      },
    );
  }
}
