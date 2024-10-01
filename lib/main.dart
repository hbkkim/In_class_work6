import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    // Provide the model to all widgets within the app. We're using
    // ChangeNotifierProvider because that's a simple way to rebuild
    // widgets when a model changes. We could also just use
    // Provider, but then we would have to listen to Counter ourselves.
    //
    // Read Provider's docs to learn about all the available providers.
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own Counter's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  String get ageMilestoneMessage {
    if (_count >= 0 && _count <= 12) {
      return 'You are in your Childhood!';
    } else if (_count >= 13 && _count <= 19) {
      return 'You are in your Teenage years!';
    } else if (_count >= 20 && _count <= 30) {
      return 'You are a Young Adult!';
    } else if (_count >= 31 && _count <= 50) {
      return 'You are an Adult!';
    } else if (_count >= 51) {
      return 'You are a Senior!';
    } else {
      return 'Age is just a number!';
    }
  }

  Color get ageMilestoneColor {
    if (_count >= 0 && _count <= 12) {
      return Colors.lightBlueAccent;
    } else if (_count >= 13 && _count <= 19) {
      return Colors.lightGreen;
    } else if (_count >= 20 && _count <= 30) {
      return Colors.orange;
    } else if (_count >= 31 && _count <= 50) {
      return Colors.yellow;
    } else if (_count >= 51) {
      return Colors.grey;
    } else {
      return Colors.white;
    }
  }

}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child: MaterialApp(
        title: 'Flutter Counter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final counterProvider = Provider.of<Counter>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Age App'),
      ),
      body: 
      AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: counterProvider.ageMilestoneColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Age:'),
            // Consumer looks for an ancestor Provider widget
            // and retrieves its model (Counter, in this case).
            // Then it uses that model to build widgets, and will trigger
            // rebuilds if the model is updated.
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                '${counter._count}',
                style: Theme.of(context).textTheme.headlineMedium,
               ),
            ),
            const SizedBox(height: 20),
            Text(
                counterProvider.ageMilestoneMessage,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton(
            onPressed: counterProvider.decrement,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          FloatingActionButton(
            onPressed: counterProvider.increment,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
