import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_mbientlab/componants/scan_result_tile.dart';

import 'device_screen.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({this.title});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//This screen will show all the available devices after clicking on start scanning button below
class _HomeScreenState extends State<HomeScreen> {
  BluetoothDevice device;
  FlutterBlue flutterBlue;
  bool scanningRunning = false;

  @override
  void initState() {
    super.initState();
    //Initialize object from FlutterBlue
    try {
      flutterBlue = FlutterBlue.instance;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //The below stream is to update the status of start/stop scanning button. Also, to update the scanningRunning variable based on the scanning status.
              StreamBuilder<bool>(
                stream: flutterBlue.isScanning,
                initialData: false,
                builder: (c, snapshot) {
                  scanningRunning = snapshot.data;
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          child: Text("Start Scanning"),
                          onPressed: scanningRunning ? null : _startScanning,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RaisedButton(
                          child: Text("Stop Scanning"),
                          onPressed: scanningRunning ? _stopScanning : null,
                        ),
                      )
                    ],
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                //This stream is built to list all the available devices in a Column, and each device will be presented in a ScanResultTile widget
                child: StreamBuilder<List<ScanResult>>(
                  stream: flutterBlue.scanResults,
                  initialData: [],
                  builder: (c, snapshot) => Column(
                    children: snapshot.data
                        .map(
                          (scanResult) => ScanResultTile(
                            result: scanResult,
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              scanResult.device.connect();
                              return DeviceScreen(
                                  title: widget.title,
                                  device: scanResult.device);
                            })),
                          ),
                        )
                        .toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _startScanning() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));
  }

  void _stopScanning() {
    flutterBlue.stopScan();
  }
}
