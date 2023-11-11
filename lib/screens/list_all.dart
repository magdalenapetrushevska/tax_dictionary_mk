import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

//fetchArticles
class AllWordsScreen extends StatefulWidget {
  const AllWordsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AllWordsScreenState createState() => _AllWordsScreenState();
}

class _AllWordsScreenState extends State<AllWordsScreen> {
  _AllWordsScreenState();

  late Future _completedActivities;

  Future<List<String>> extractData() async {
    // Getting the response from the targeted url
    final response = await http.Client()
        .get(Uri.parse('http://www.ujp.gov.mk/mk/recnik/poimi'));

    // Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {
      // Getting the html document from the response
      var document = parser.parse(response.body);
      try {
        List<String> newCompltedActivities = [];

        var retreivedData = document.getElementsByClassName('tbrow').toList();
        for (var element in retreivedData) {
          newCompltedActivities.add(element.text.trim());
        }

        return newCompltedActivities;
      } catch (e) {
        return ['', '', 'ERROR!'];
      }
    } else {
      return ['', '', 'ERROR: ${response.statusCode}.'];
    }
  }

  @override
  void initState() {
    _completedActivities = extractData();
    super.initState();
  }

  void _getDescription(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Vrednosta na kliknation index e: $index'),
        );
      },
    );
  }


  int index = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _completedActivities as Future<List<String>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<String>;
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
                                child: Text(extractedData[index]),
                                onTap: () {
                                  _getDescription(index);
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
