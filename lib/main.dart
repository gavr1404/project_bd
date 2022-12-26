import 'package:flutter/material.dart';
import 'package:project_bd/database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final myName = TextEditingController();
  late final myAge = TextEditingController();

  bool markResult = false;
  List<Map<String, dynamic>> queryRow = [];
  String textBasa = 'Показати базу даних';
  List result = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text('Привіт, заповніть форму для бази даних.'),
            const SizedBox(height: 30),

            // введіть ім'я
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: myName,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Вкажить своє ім'я",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Вкажить свій вік
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: myAge,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Вкажить свій вік",
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // add database
            ElevatedButton(
              style: ButtonStyle(
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 40),
                ),
                backgroundColor: MaterialStatePropertyAll(Colors.blue[200]),
              ),
              onPressed: () async {
                if (myName.text != '' && myAge.text != '') {
                  FocusScope.of(context).requestFocus(FocusNode());
                  await DatabaseHelper.instance.insert({
                    DatabaseHelper.columnName: myName.text,
                    DatabaseHelper.columnAge: int.parse(myAge.text)
                  });
                  setState(() {
                    myAge.clear();
                    myName.clear();
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return SimpleDialog(
                        backgroundColor: Colors.blue[50],
                        children: const [
                          Center(
                            child: Text(
                              "Невірно вказана інформація. \nПовинні бути заповнені поля, \nім'я - літери, \nвік - цифри.",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Дадоти до бази даних'),
            ),
            const SizedBox(height: 10),

            // показати/сховати базу даних
            ElevatedButton(
              style: ButtonStyle(
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 40),
                ),
                backgroundColor: MaterialStatePropertyAll(Colors.blue[200]),
              ),
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                List<Map<String, dynamic>> queryRow =
                    await DatabaseHelper.instance.queryAll();
                result = queryRow;

                setState(() {
                  if (textBasa == 'Показати базу даних') {
                    markResult = true;
                    textBasa = 'Cховати базу даних';
                  } else {
                    markResult = false;
                    textBasa = 'Показати базу даних';
                  }
                });
              },
              child: Text(textBasa),
            ),

            if (markResult)
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: result.length,
                    itemBuilder: (BuildContext context, int index) {
                      var myList =
                          result[index].entries.map((e) => e.value).toList();
                      var id = myList[0];
                      var name = myList[1];
                      var age = myList[2];

                      return Card(
                        color: Colors.blue[200],
                        child: ListTile(
                          title: Text('$id)  name - $name, age - $age'),
                        ),
                      );
                    }),
              ),
          ],
        ),
      ),
    );
  }
}
