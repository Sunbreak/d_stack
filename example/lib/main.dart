import 'package:d_stack/d_stack.dart';
import 'package:flutter/material.dart';

void main() {
  DStack.init(routeMap);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => DStackApp();
}

final routeMap = <String, TRouteBuilder>{
  'flutterPage1': (DNode node) {
    return page1Builder;
  },
  'flutterPage2': (DNode node) {
    return page2Builder;
  }
};

final WidgetBuilder page1Builder = (BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('FlutterPage1'),
    ),
    body: Center(
      child: Column(
        children: [
          ElevatedButton(
            child: Text('push(nativePage1)'),
            onPressed: () {
              // DStack.push('nativePage1');
            },
          ),
          ElevatedButton(
            child: Text('push(nativePage2)'),
            onPressed: () {
              // DStack.push('nativePage2');
            },
          ),
          ElevatedButton(
            child: Text('push(flutterPage1)'),
            onPressed: () {
              // DStack.push('flutterPage1');
            },
          ),
          ElevatedButton(
            child: Text('push(flutterPage2)'),
            onPressed: () {
              // DStack.push('flutterPage2');
            },
          ),
        ],
      ),
    ),
  );
};

final WidgetBuilder page2Builder = (BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('FlutterPage2'),
    ),
    body: Center(
      child: Column(
        children: [
          ElevatedButton(
            child: Text('push(nativePage1)'),
            onPressed: () {
              // DStack.push('nativePage1');
            },
          ),
          ElevatedButton(
            child: Text('push(nativePage2)'),
            onPressed: () {
              // DStack.push('nativePage2');
            },
          ),
          ElevatedButton(
            child: Text('push(flutterPage1)'),
            onPressed: () {
              // DStack.push('flutterPage1');
            },
          ),
          ElevatedButton(
            child: Text('push(flutterPage2)'),
            onPressed: () {
              // DStack.push('flutterPage2');
            },
          ),
        ],
      ),
    ),
  );
};
