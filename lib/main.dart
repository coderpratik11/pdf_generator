import 'package:flutter/material.dart';
import 'package:pdf_generator/pdf_generator.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Invoice',
              style: TextStyle(fontSize: 24),
            ),
            backgroundColor: Colors.black,
            actions: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'ENG',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Switch(
                // This bool value toggles the switch.
                value: light,
                activeColor: Colors.yellow[700],
                inactiveTrackColor: Colors.white60,
                onChanged: (bool value) {
                  // This is called when the user toggles the switch.
                  setState(() {
                    light = value;
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'हिंदी',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          body: PdfPreview(
            maxPageWidth: 700,
            build: ((format) =>
                light ? generateInvoicehindi(format) : generateInvoice(format)),
          ),
        ));
  }
}
