import 'package:finalflutter/helpers/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:finalflutter/helpers/preferences_helper.dart';
import 'package:platform_device_id/platform_device_id.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  String _sessionId = '';
  String _shareCode = '';
  String _deviceId = '';
  bool _isLoading = false;
  final HttpHelper _httpHelper = HttpHelper();

  @override
  void initState() {
    super.initState();
    _initDeviceId();
  }

  Future<void> _initDeviceId() async {
    String? deviceId = await PreferencesHelper.getDeviceId();
    if (deviceId == null) {
      deviceId = await PlatformDeviceId.getDeviceId ?? 'Unknown';
      await PreferencesHelper.saveDeviceId(deviceId);
    }
    _deviceId = deviceId;
    _startSession();
  }

  Future<void> _startSession() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _httpHelper.startSession(_deviceId);
      setState(() {
        _sessionId = data['data']['session_id'];
        _shareCode = data['data']['code'];
      });
      await PreferencesHelper.saveSessionId(_sessionId);
    } catch (e) {
      if (kDebugMode) {
        print('There was an error when starting the session: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Code')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_sessionId.isNotEmpty && _shareCode.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          _shareCode,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Share code with your friend',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/movieSelection',
                          arguments: {
                            'sessionId': _sessionId,
                            'deviceId': _deviceId
                          });
                    },
                    child: const Text('Begin'),
                  ),
                ],
              ),
            ),
    );
  }
}
