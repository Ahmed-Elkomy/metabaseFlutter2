import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_mbientlab/componants/bluetooth_off.dart';
import 'package:flutter_mbientlab/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'Flutter BLE Demo';

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return HomeScreen(
                title: title,
              );
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}
