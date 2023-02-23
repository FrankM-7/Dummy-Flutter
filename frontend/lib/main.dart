import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String?> getLocalIpAddress() async {
  try {
    List<NetworkInterface> interfaces = await NetworkInterface.list();
    for (NetworkInterface interface in interfaces) {
      if (!interface.name.startsWith('lo')) {
        for (InternetAddress address in interface.addresses) {
          if (address.type == InternetAddressType.IPv4) {
            return address.address;
          }
        }
      }
    }
  } catch (e) {
    print('Error getting IP address: $e');
  }
  return null;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final ipAddress = await getLocalIpAddress();
    if (ipAddress != null) {
      print(ipAddress);
    }
  } catch (e) {
    print("Error: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _userData = '';

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/alex'));

    if (response.statusCode == 200) {
      setState(() {
        _userData = response.body;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(_userData),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
