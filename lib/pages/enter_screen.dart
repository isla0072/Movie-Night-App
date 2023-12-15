import 'package:finalflutter/helpers/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:finalflutter/helpers/preferences_helper.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;
  final HttpHelper _httpHelper = HttpHelper();

  Future<void> _joinSession(String code) async {
    if (code.length != 4) {
      setState(() {
        _errorMessage = "Your code must be 4 digits. Please try again.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      String? deviceId = await PreferencesHelper.getDeviceId();
      if (deviceId == null) {
        throw Exception('The device Id is null.');
      }

      final data = await _httpHelper.joinSession(deviceId, int.parse(code));
      final sessionId = data['data']['session_id'];
      if (kDebugMode) {
        print('You joined the session with Id number: $sessionId');
      }
      await PreferencesHelper.saveSessionId(sessionId);
      _navigateToSelectionScreen();
    } catch (e) {
      setState(() {
        _errorMessage = 'There was an error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToSelectionScreen() {
    Navigator.pushNamed(context, '/movieSelection');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter the Code')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  hintText: 'Enter the code from your friend',
                  errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                ),
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _joinSession(_codeController.text),
                      child: const Text('Join Session'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
