import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Theme with HTTP Request',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Dark Theme with HTTP Request'),
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
  String? _responseData;

  Future<void> _fetchData(String url) async {
    setState(() {
      _responseData = null;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _responseData = response.body;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      setState(() {
        _responseData = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_responseData == null)
              Text(
                'Press a button to make an HTTP call:',
              ),
            if (_responseData != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _responseData!,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _fetchData('http://192.168.10.244:8000/motor_run'),
                  child: Text('Start Motor'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () => _fetchData('http://192.168.10.244:8000/motor_stop'),
                  child: Text('Stop motor'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _fetchData('https://jsonplaceholder.typicode.com/todos/3'),
              child: Text('Fetch Data 3'),
            ),
          ],
        ),
      ),
    );
  }
}
