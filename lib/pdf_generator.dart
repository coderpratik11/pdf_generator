import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'invoice/product.dart';
import 'invoice/invoice.dart';

//Pdf generating function in English
Future<Uint8List> generateInvoice(PdfPageFormat pageFormat) async {
  final lorem = pw.LoremText();

  final products = <Product>[
    Product('1', lorem.sentence(4), 1, 2),
    Product('2', lorem.sentence(6), 1, 2),
    Product('3', lorem.sentence(4), 1, 3),
    Product('4', lorem.sentence(3), 1, 4),
  ];

//instance of invoice
  final invoice = Invoice(
      invoiceNumber: '32168',
      products: products,
      customerName: 'Dwyane Clark',
      customerAddress:
          '24 dummy Street Area,\nLocation, Lorem ipsum,\n570xx59x',
      paymentInfo:
          '4509 Wiseman Street\nKnoxville, Tennessee(TN), 37929\n865-372-0425',
      tax: .15,
      tableColor: PdfColors.blueGrey900,
      baseColor: PdfColors.amber,
      accentColor: PdfColors.grey200);

  return await invoice.buildPdf(pageFormat);
}

// Pdf generator in Hindi
Future<Uint8List> generateInvoicehindi(PdfPageFormat pageFormat) async {
  final productsHindi = <Product>[
    const Product('१', 'ड्वेन क्लार्क', 3, 1),
    const Product('२', 'वाइसमैन क्लार्क', 5, 4),
    const Product('3', ' लोरेम इप्सम', 6, 2),
    const Product('४', 'ड्वेन क्लार्क', 1, 14),
  ];

  final invoiceHindi = Invoice(
      invoiceNumber: '१००',
      products: productsHindi,
      customerName: 'ड्वेन क्लार्क',
      customerAddress: '२४ डमी स्ट्रीट क्षेत्र,\nस्थान, लोरेम इप्सम,\n४४२x२१०',
      paymentInfo:
          '4509 वाइसमैन स्ट्रीट\t \nनॉक्सविल, टेनेसी(TN), 37929\n865-372-0425',
      tax: .1,
      tableColor: PdfColors.blueGrey900,
      baseColor: PdfColors.amber,
      accentColor: PdfColors.grey200);

  return await invoiceHindi.buildPdf(pageFormat);
}
