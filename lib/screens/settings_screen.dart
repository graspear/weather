import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  final bool isCelsius;

  const SettingsScreen({super.key, required this.isCelsius});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isCelsius;

  @override
  void initState() {
    super.initState();
    _isCelsius = widget.isCelsius;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor:Colors.purple,
        title: Text("Settings"),
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          color:Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Temperature Unit",
                style: GoogleFonts.lato(
                  fontSize:20,
                  color:Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                ),
                Switch(
                  value: _isCelsius,
                  onChanged: (value) {
                    setState(() {
                      _isCelsius = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _isCelsius);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}