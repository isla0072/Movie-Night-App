import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:finalflutter/helpers/preferences_helper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _initDeviceId();
  }

  Future<void> _initDeviceId() async {
    final deviceId = await PlatformDeviceId.getDeviceId ?? 'Unknown';
    await PreferencesHelper.saveDeviceId(deviceId);
    if (kDebugMode) {
      print('Device ID: $deviceId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Night'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_fill),
                label: const Text('Start Session'),
                onPressed: () {
                  Navigator.pushNamed(context, '/shareCode');
                },
                style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Choose an option to begin',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.group),
                label: const Text('Join Session'),
                onPressed: () {
                  Navigator.pushNamed(context, '/enterCode');
                },
                style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
