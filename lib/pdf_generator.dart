import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

//Pdf generating function
Future<Uint8List> generateInvoice(PdfPageFormat pageFormat) async {
  final lorem = pw.LoremText();

  final products = <Product>[
    Product('1', lorem.sentence(4), 3.99, 2),
    Product('2', lorem.sentence(6), 15, 2),
    Product('3', lorem.sentence(4), 6.95, 3),
    Product('4', lorem.sentence(3), 49.99, 4),
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
      tableColor: PdfColors.black,
      baseColor: PdfColors.yellow700,
      accentColor: PdfColors.grey200);

  return await invoice.buildPdf(pageFormat);
}

Future<Uint8List> generateInvoicehindi(PdfPageFormat pageFormat) async {
  final productsHindi = <Product>[
    const Product('1', 'ड्वेन क्लार्क', 3, 1),
    const Product('2', 'ड्वेन क्लार्क', 5, 4),
    const Product('3', 'ड्वेन क्लार्क', 6, 2),
    const Product('4', 'ड्वेन क्लार्क', 1, 14),
  ];

  final invoiceHindi = Invoice(
      invoiceNumber: '१००',
      products: productsHindi,
      customerName: 'ड्वेन क्लार्क',
      customerAddress: '२४ डमी स्ट्रीट क्षेत्र,\nस्थान, लोरेम इप्सम,\n४४२x२१०',
      paymentInfo:
          '4509 वाइसमैन स्ट्रीट\nनॉक्सविल, टेनेसी(TN), 37929\n865-372-0425',
      tax: .1,
      tableColor: Invoice._darkColor,
      baseColor: PdfColors.amber,
      accentColor: PdfColors.grey200);

  return await invoiceHindi.buildPdf(pageFormat);
}

//Procuct class for table
class Product {
  const Product(
    this.sku,
    this.productName,
    this.price,
    this.quantity,
  );

  final String sku;
  final String productName;
  final double price;
  final int quantity;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sku;
      case 1:
        return productName;
      case 2:
        return _formatCurrency(price);
      case 3:
        return quantity.toString();
      case 4:
        return _formatCurrency(total);
    }
    return '';
  }
}

String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

//invoice class
class Invoice {
  Invoice({
    required this.products,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
    required this.tableColor,
  });

  //variables
  final List<Product> products;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor tableColor;
  final PdfColor baseColor;
  final PdfColor accentColor;

  //constants
  static const _darkColor = PdfColors.black;
  static const _lightColor = PdfColors.white;

  //total sum of the table
  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  //grand total for after tax
  double get _grandTotal => _total * (1 + tax);

  //svg path / accessing the svg assets string
  String? _logo;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = pw.Document();
    var devFont =
        Font.ttf(await rootBundle.load("fonts/NotoSansDevanagari.ttf"));

    _logo = await rootBundle.loadString('assets/brand_icon.svg');

    doc.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: devFont),
        pageFormat: pageFormat.copyWith(
            marginBottom: 0, marginLeft: 0, marginRight: 0, marginTop: 0),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.Padding(
            padding: const EdgeInsets.only(left: 45, right: 45),
            child: pw.Container(
              decoration: BoxDecoration(
                border: Border.all(color: PdfColors.black),
                color: PdfColors.grey200,
              ),
              height: 60,
            ),
          ),
          pw.SizedBox(height: 20),
          _contentFooter(context),
          pw.SizedBox(height: 20),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  //Header Widget of the Pdf page
  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Spacer(flex: 1),
            pw.Padding(
                padding: const pw.EdgeInsets.only(
                  top: 40,
                ),
                child: pw.Container(
                    height: 40, width: 40, child: pw.SvgImage(svg: _logo!))),
            pw.Padding(
              padding: const pw.EdgeInsets.only(
                top: 40,
              ),
              child: pw.Container(
                height: 50,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      height: 20,
                      padding: const pw.EdgeInsets.only(left: 2),
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        'Brand Name',
                        style: pw.TextStyle(
                          color: tableColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    pw.Container(
                      padding: const pw.EdgeInsets.only(left: 2),
                      height: 2,
                      alignment: pw.Alignment.centerLeft,
                    ),
                    pw.Text(
                      'TAG NAME LIES HERE',
                      style: pw.TextStyle(
                        color: tableColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.Spacer(flex: 10),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20),
        pw.Row(children: [
          pw.Container(color: baseColor, height: 30, width: 400),
          pw.Container(
            height: 50,
            width: 140,
            alignment: const pw.Alignment(0, 0),
            child: pw.Text('INVOICE', style: const pw.TextStyle(fontSize: 32)),
          ),
          pw.Container(color: baseColor, height: 30, width: 80)
        ])
      ],
    );
  }

  //Footer Widget of the page
  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
        child: pw.Column(
      children: [
        pw.Container(
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(color: PdfColors.yellow600, height: 3, width: 390),
                pw.Container(
                    padding: const pw.EdgeInsets.only(left: 10, right: 10),
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Container(color: _darkColor, height: 1, width: 90),
                          pw.SizedBox(height: 10),
                          pw.Text('Authorized Sign',
                              style: const pw.TextStyle(
                                  color: _darkColor, fontSize: 12))
                        ])),
                pw.Container(color: PdfColors.yellow600, height: 3, width: 100)
              ]),
        ),
        pw.Container(
            height: 40,
            padding: const pw.EdgeInsets.only(left: 50, bottom: 10),
            child: pw.Row(children: [
              pw.Text('Phone #',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Spacer(flex: 1),
              pw.Text('|', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Spacer(
                flex: 1,
              ),
              pw.Text('Address',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Spacer(flex: 1),
              pw.Text('|', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Spacer(flex: 1),
              pw.Text('Website',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Spacer(flex: 30),
            ]))
      ],
    ));
  }

//Content header widget
  pw.Widget _contentHeader(pw.Context context) {
    return pw.Container(
        height: 100,
        padding: const pw.EdgeInsets.only(left: 45, right: 45),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
                height: 100,
                width: 150,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      pw.Text('Invoice to:',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text(customerName, style: pw.TextStyle(fontSize: 18)),
                      pw.Text(customerAddress),
                    ])),
            pw.Spacer(),
            pw.Container(
                height: 100,
                width: 150,
                child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Row(children: [
                        pw.Text('Invoice#',
                            style: pw.TextStyle(
                                fontSize: 13, fontWeight: pw.FontWeight.bold)),
                        pw.Spacer(),
                        pw.Text(
                          invoiceNumber,
                        ),
                      ]),
                      pw.Row(children: [
                        pw.Text('Date'),
                        pw.Spacer(),
                        pw.Text(_formatDate(DateTime.now())),
                      ])
                    ]))
          ],
        ));
  }

//Footer content after Table Widget
  pw.Widget _contentFooter(pw.Context context) {
    return pw.Container(
        height: 200,
        width: double.infinity,
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.only(left: 45),
              height: 200,
              width: 300,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Thank you for your business',
                    style: pw.TextStyle(
                      color: _darkColor,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              padding:
                                  const pw.EdgeInsets.only(top: 10, bottom: 4),
                              child: pw.Text(
                                'Terms & Conditions',
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: _darkColor,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                            pw.Text(
                              pw.LoremText().paragraph(14),
                              textAlign: pw.TextAlign.justify,
                              style: const pw.TextStyle(
                                fontSize: 6,
                                lineSpacing: 2,
                                color: _darkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.SizedBox(),
                      ),
                    ],
                  ),
                  pw.Container(
                    margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                    child: pw.Text(
                      'Payment Info:',
                      style: pw.TextStyle(
                        color: _darkColor,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Text(
                    paymentInfo,
                    style: const pw.TextStyle(
                      fontSize: 8,
                      lineSpacing: 5,
                      color: _darkColor,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 120),
            pw.Container(
              height: 150,
              width: 200,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.only(right: 45),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Sub Total:'),
                        pw.Text(_formatCurrency(_total)),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Container(
                    padding: const pw.EdgeInsets.only(right: 45),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Tax:'),
                        pw.Text('${(tax * 100).toStringAsFixed(1)}%'),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Container(
                      height: 30,
                      color: baseColor,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(right: 45),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Total:',
                            ),
                            pw.Text(
                              _formatCurrency(_grandTotal),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )
          ],
        ));
  }

//Table widget of the page
  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = ['SL.', 'Item Description', 'Price', 'Qty', 'Total'];

    return pw.Container(
        padding: const pw.EdgeInsets.only(
          left: 45,
          right: 45,
        ),
        child: pw.Table.fromTextArray(
          border: const pw.TableBorder(
              left: pw.BorderSide(width: 1), right: pw.BorderSide(width: 1)),
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: pw.BoxDecoration(
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            color: tableColor,
          ),
          headerHeight: 25,
          cellHeight: 40,
          cellAlignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.center,
            4: pw.Alignment.centerRight,
          },
          headerStyle: pw.TextStyle(
            color: _lightColor,
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
          cellStyle: const pw.TextStyle(
            color: _darkColor,
            fontSize: 10,
          ),
          rowDecoration: pw.BoxDecoration(
            color: accentColor,
            border: const pw.Border(
              bottom: pw.BorderSide(
                color: _darkColor,
                width: .5,
              ),
            ),
          ),
          headers: List<String>.generate(
            tableHeaders.length,
            (col) => tableHeaders[col],
          ),
          data: List<List<String>>.generate(
            products.length,
            (row) => List<String>.generate(
              tableHeaders.length,
              (col) => products[row].getIndex(col),
            ),
          ),
        ));
  }
}
