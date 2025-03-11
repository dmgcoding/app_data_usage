import 'package:app_data_usage/app_data_usage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? _permissionGranted;
  String? _errorMsg;
  int rxTotalBytes = 0;
  int txTotalBytes = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPermission();
    });
    super.initState();
  }

  Future<void> checkPermission() async {
    try {
      final granted = await AppDataUsage.instance.checkPermission();
      setState(() {
        _permissionGranted = granted;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
      });
    }
  }

  Future<bool?> requestPermission() async {
    await checkPermission();
    if (_permissionGranted == true) return null;
    return await AppDataUsage.instance.requestPermission();
  }

  Future<void> checkDailyDataUsage() async {
    if (_permissionGranted == false) return;
    final details = await AppDataUsage.instance.getDailyDataUsageForApp();
    print('details: ${details.toJson()}');
    if (!details.isSuccess) return; //check details.error for error message
    setState(() {
      rxTotalBytes = details.rxBytes;
      txTotalBytes = details.txBytes;
    });
  }

  //do a api request to use data
  Future<void> doAFakeApiRequest() async {
    try {
      final uri = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      await get(uri);
      print('api called ------');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          if (_permissionGranted != true)
            Center(
              child: Column(
                children: [
                  if (_errorMsg != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _errorMsg ?? '',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('permission not granted'),
                  ),
                  ElevatedButton(
                      onPressed: requestPermission,
                      child: Text('Request permission'))
                ],
              ),
            )
          else
            Center(
              child: Column(
                spacing: 1,
                children: [
                  ElevatedButton(
                    onPressed: doAFakeApiRequest,
                    child: Text('Call api'),
                  ),
                  Text('Data used: - ${rxTotalBytes + txTotalBytes}'),
                  ElevatedButton(
                    onPressed: checkDailyDataUsage,
                    child: Text('Check data usage'),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
