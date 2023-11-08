import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _prefs = SharedPreferences.getInstance();

  // Variables to store
  String? _name;
  String? _age;
  bool _isEmail = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _retrieveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shared Preferences Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isEmail = !_isEmail;
                  });
                },
                icon: Icon(
                  _isEmail ? Icons.toggle_on : Icons.toggle_off,
                  color: _isEmail ? Colors.blue : Colors.grey,
                ),
                label: const Text('Email'),
              ),
              ElevatedButton(
                onPressed: _saveUserData,
                child: const Text('Save User Data'),
              ),
              Text('Name: $_name'),
              Text('Age: $_age'),
              Text('Student: $_isEmail'),
            ],
          ),
        ),
      ),
    );
  }

  // Save variables to SharedPreferences
  void _saveUserData() async {
    final prefs = await _prefs;

    _name = _nameController.text;
    _age = _ageController.text;
    _isEmail = _isEmail;

    // Convert variables to JSON string
    String jsonString =
        jsonEncode({'name': _name, 'age': _age, 'isEmail': _isEmail});

    // Store JSON string under a key
    prefs.setString('userData', jsonString);

    setState(() {});
  }

  void _retrieveUserData() async {
    final prefs = await _prefs;

    // Retrieve JSON string
    String jsonString = prefs.getString('userData') ?? '';

    // Decode JSON string to map
    if (jsonString.isNotEmpty) {
      Map<String, dynamic> userData = jsonDecode(jsonString);

      // Access variables from the map and set them
      setState(() {
        _name = userData['name'];
        _age = userData['age'];
        _isEmail = userData['isEmail'];
      });
    }
  }
}
