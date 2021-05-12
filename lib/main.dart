import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: TextTheme(
          headline4: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      home: MyHomePage(title: 'Device Status'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 3), (Timer t) => _reload());
    super.initState();
  }

  var url = "d01d6d9752b4.ngrok.io";
  String data = "";
  String newUrl = "";
  TextEditingController textEditingController = new TextEditingController();
  Future<void> _reload() async {
    print("URL= " + url);
    var response = await http.get(Uri.https(url, '/'));
    print(response.body);
    print("-----------------");
    if (response.statusCode == 200) {
      if (data != response.body.replaceAll("<br>", "\r\n"))
        setState(() {
          data = response.body.replaceAll("<br>", "\r\n");
        });
    } else {
      setState(() {
        data = response.body.replaceAll("<br>", "\r\n");
      });
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                  ),
                  child: Text(
                    "Condition based monitoring of high current in bus bar",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.normal,
                      color: Colors.indigoAccent,
                      shadows: [
                        Shadow(
                          offset: Offset.fromDirection(4),
                          color: Colors.black,
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                'Current Status:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  shadows: [
                    Shadow(color: Colors.black54, blurRadius: 1.5),
                  ],
                ),
              ),
              if (data.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      data,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                )
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud_download_outlined,
                          size: 155,
                        ),
                        Text(
                          "Fetching Data ... ",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              Container(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: TextField(
                  onChanged: (value) {
                    newUrl = value.replaceAll("https://", "");
                    newUrl = newUrl.split("/").first;
                  },
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter URL',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.upload_rounded),
                      onPressed: () {
                        setState(() {
                          url = newUrl;
                          textEditingController.clear();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
