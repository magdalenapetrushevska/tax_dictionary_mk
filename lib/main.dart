import 'package:flutter/material.dart';
import 'package:tax_dictionary_mk/db_connection/db_connect.dart';
import 'package:tax_dictionary_mk/models/entry.dart';
import 'package:tax_dictionary_mk/screens/list_all.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:tax_dictionary_mk/widgets/entry_widget.dart';


Future<void> main() async {

  var db = DBconnect();
db.addEntry(
     Entry(id:'1',name:'Агент', definition:'Финансиска институција од земјата или од странство која, во име и за сметка на Министерство за финансии, може да извршува определени работи утврдени со закон.'), );

db.addEntry(
     Entry(id:'2',name:'Аконтација', definition:'Износ на даночен долг кој обврзникот го плаќа во текот на годината во вид на месечни или тримесечни износи, до конечното намирување на даночната обврска.'), );

db.addEntry(
     Entry(id:'2',name:'Акција', definition:'Хартија од вредност (која може да ја издаваат акционерското друштво и командитното друштво со акции) во која е претставен дел од основната главнина и во која се отелотворуваат правата на акционерот кој, како сопственик на акцијата, не е доверител на друштвото, ниту сопственик на еден дел од имотот на друштвото.'), );



//var dataaa = resultEntries as List<Entry>;


// List dailyTaskList = await getDailyTask(DateTime.now());
// // Now you can iterate on this list.
// for (var task in dailyTaskList) {
//   // do something
// }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Даночен речник',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Даночен речник'),
      debugShowCheckedModeBanner: false,
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
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  final myController = TextEditingController();

  var db = DBconnect();

  late Future _entry;


  Future<Entry> getData(String name) async {
    return db.fetchEntry(name);
  }
  // Define Macedonian alphabet letters
  // List<String> macedonianAlphabet = [
  //   'а',
  //   'б',
  //   'в',
  //   'г',
  //   'д',
  //   'ѓ',
  //   'е',
  //   'ж',
  //   'з',
  //   'ѕ',
  //   'и',
  //   'ј',
  //   'к',
  //   'л',
  //   'љ',
  //   'м',
  //   'н',
  //   'њ',
  //   'о',
  //   'п',
  //   'р',
  //   'с',
  //   'т',
  //   'ќ',
  //   'у',
  //   'ф',
  //   'х',
  //   'ц',
  //   'ч',
  //   'џ',
  //   'ш'
  // ];

  // Map<int, String> macedonianAlphabetMap = {};

  // void createAlphabetMap() {
  //   // Create a dictionary with Macedonian alphabet letters and their corresponding order
  //   for (int i = 0; i < macedonianAlphabet.length; i++) {
  //     macedonianAlphabetMap[i + 1] = macedonianAlphabet[i];
  //   }
  // }

  @override
  void initState() {
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectivityResult = result;
      });
      log(result.name);
    });
    //createAlphabetMap();
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  // void searchEntry() async {
  //   var firstLetter = myController.text[0].toLowerCase();
  //   var found = false;
  //   var correspondingNumber = macedonianAlphabetMap.keys.firstWhere(
  //       (k) => macedonianAlphabetMap[k] == firstLetter,
  //       orElse: () => 0);
  //   if (correspondingNumber != 0) {
  //     final response = await http.Client().get(Uri.parse(
  //         'http://www.ujp.gov.mk/mk/recnik/poim/$correspondingNumber'));

  //     if (response.statusCode == 200) {
  //       BeautifulSoup bsMain = BeautifulSoup(response.body);

  //       var retreivedData = bsMain
  //           .findAll('div', attrs: {'class': 'dict_term dict_parno'}).toList();

  //       for (var element in retreivedData) {
  //         if (element.innerHtml.toLowerCase() ==
  //             myController.text.toLowerCase()) {
  //           found = true;

  //           var definitionElement =
  //               element.nextElement?.nextElement?.innerHtml.trim();

  //           showDialog(
  //             context: context,
  //             builder: (context) {
  //               return AlertDialog(
  //                 content: EntryWidget(
  //                   id: '0',
  //                   name: element.innerHtml,
  //                   definition: definitionElement,
  //                 ),
  //               );
  //             },
  //           );
  //           // reset the value for user input
  //           myController.text = '';
  //           return;
  //         }
  //       }
  //     }
  //   }
  //   if (!found) {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           content: Text('Терминот кој го баравте не е пронајден.'),
  //         );
  //       },
  //     );
  //     // reset the value for user input
  //     myController.text = '';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (connectivityResult == ConnectivityResult.none)
            const Center(child: Text('Нема достапна конекција')),
          if (connectivityResult != ConnectivityResult.none) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: myController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Внесете термин за пребарување',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  getData(myController.text);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 15.0),
                  primary: Colors.pink[400],
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Пребарај",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AllEntriesScreen()));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 15.0),
                primary: Colors.pink[400],
                shape: const StadiumBorder(),
              ),
              child: const Text(
                "Сите термини",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
