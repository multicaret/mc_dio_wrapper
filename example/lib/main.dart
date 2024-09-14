import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mc_dio_wrapper/mc_dio_wrapper.dart';

import 'app_http_controller.dart';
import 'models/user_index_response.dart';

void main() {
  McHttpWrapperInitializer.by(
    baseUrl: const String.fromEnvironment('API_ORIGIN', defaultValue: 'https://dummyjson.com'),
    httpLoggerLevel: LogDetails.full,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  final AppHttpController _controller = AppHttpController();
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _controller.fetchUsers().then((List<User> users) {
      if (kDebugMode) {
        print('Users Length => ${users.length}');
      }

      /// handle error by dialog .onError(McDioError.handlerByDialogByErrors(context));
      /// Or by toast message by .onError(McDioError.handlerByToastMsg);
    }).onError((Object? error, StackTrace stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
