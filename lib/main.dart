import 'package:flutter/material.dart';
import 'package:pdf_generator/pdf_generator.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(backgroundColor: Colors.black),
          body: PdfPreview(
            maxPageWidth: 700,
            build: ((format) => generateInvoice(format)),
          )),
    );
  }
}
