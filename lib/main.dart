import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notifications/notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Notifications? _notifications;
  StreamSubscription<NotificationEvent>? _subscription;
  List<NotificationEvent> _log = [];
  bool started = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void onData(NotificationEvent event) {
    setState(() {
      _log.add(event);
    });
    print(event.toString());
  }

  void example() {
    Notifications().notificationStream!.listen((event) => print(event));
  }

  void startListening() {
    _notifications = Notifications();
    try {
      _subscription = _notifications!.notificationStream!.listen(onData);
      setState(() => started = true);
    } on NotificationException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription?.cancel();
    setState(() => started = false);
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  Scaffold(
        appBar:  AppBar(
          title: const Text('Notifications Example app'),
        ),
        body:  Center(
            child:  ListView.builder(
                itemCount: _log.length,
                reverse: true,
                itemBuilder: (BuildContext context, int idx) {
                  final entry = _log[idx];
                  return ListTile(
                      leading:
                          Text(entry.timeStamp.toString().substring(0, 19)),
                      trailing:
                          Text(entry.packageName.toString().split('.').last),
                      title: Text(entry.message ?? ''),  
                        );
                })),
        floatingActionButton:  FloatingActionButton(
          onPressed: started ? stopListening : startListening,
          tooltip: 'Start/Stop sensing',
          child: started ? const Icon(Icons.stop) : const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}