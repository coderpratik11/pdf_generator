import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf_generator/invoice/product.dart';

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
  static const lightColor = PdfColors.white;

  //total sum of the table
  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  //grand total for after tax
  double get _grandTotal => _total * (1 + tax);

  //svg path / accessing the svg assets string
  String? _logo;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = pw.Document();
    var hindi = Font.ttf(await rootBundle.load("fonts/NotoSansDevanagari.ttf"));

    _logo = await rootBundle.loadString('assets/brand_icon.svg');

    doc.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: hindi),
        pageFormat: pageFormat.copyWith(
            marginBottom: 0, marginLeft: 0, marginRight: 0, marginTop: 0),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          _tableend(context),
          pw.SizedBox(height: 10),
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
                      padding: const pw.EdgeInsets.only(left: 4),
                      height: 2,
                      alignment: pw.Alignment.centerLeft,
                    ),
                    pw.Text(
                      'TAG NAME LIES HERE',
                      style: pw.TextStyle(
                        color: tableColor,
                        fontWeight: pw.FontWeight.normal,
                        fontSize: 9,
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
          pw.Container(color: baseColor, height: 32, width: 400),
          pw.Container(
            height: 50,
            width: 140,
            alignment: const pw.Alignment(0, 0),
            child: pw.Text('INVOICE', style: const TextStyle(fontSize: 32)),
          ),
          pw.Container(color: baseColor, height: 32, width: 80)
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
        padding: const pw.EdgeInsets.only(left: 45, right: 45, top: 10),
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
                      pw.Text(customerName,
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal)),
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
                        pw.Text('Date',
                            style: pw.TextStyle(fontWeight: FontWeight.bold)),
                        pw.Spacer(),
                        pw.Text(
                          _formatDate(DateTime.now()),
                        ),
                      ])
                    ]))
          ],
        ));
  }

//Footer content after Table Widget
  pw.Widget _contentFooter(pw.Context context) {
    return pw.Container(
        margin: const pw.EdgeInsets.only(top: 10),
        height: 180,
        width: double.infinity,
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.only(
                left: 45,
              ),
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
            pw.SizedBox(width: 100),
            pw.Container(
              height: 150,
              width: 200,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.only(right: 45, left: 20),
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
                    padding: const pw.EdgeInsets.only(right: 45, left: 20),
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
                        padding: const pw.EdgeInsets.only(right: 45, left: 20),
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

//Table widget
  pw.Widget _contentTable(Context context) {
    const tableHeaders = ['SL.', 'Item Description', 'Price', 'Qty', 'Total'];
    final List<dynamic> sl = products.map((e) => e.sku).toList();
    final List<dynamic> productname =
        products.map((e) => e.productName).toList();
    final List<dynamic> price = products.map((e) => e.price).toList();
    final List<dynamic> qty = products.map((e) => e.quantity).toList();
    final List<dynamic> total = products.map((e) => e.total).toList();

    return pw.Container(
        padding: const pw.EdgeInsets.only(
          top: 20,
          left: 45,
          right: 45,
        ),
        child: pw.Table(children: [
          pw.TableRow(children: [
            pw.Container(
              width: 20,
              height: 30,
              decoration: BoxDecoration(
                  color: tableColor,
                  border:
                      Border(left: BorderSide(width: 1, color: tableColor))),
              padding: const EdgeInsets.only(left: 20, top: 8),
              child: pw.Text(tableHeaders[0],
                  style: TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.normal)),
            ),
            pw.Container(
              width: 100,
              height: 30,
              color: tableColor,
              padding: const EdgeInsets.only(left: 20, top: 8),
              child: pw.Text(tableHeaders[1],
                  style: TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.normal)),
            ),
            pw.Container(
              width: 20,
              height: 30,
              color: tableColor,
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: pw.Text(tableHeaders[2],
                  style: TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.normal)),
            ),
            pw.Container(
              width: 20,
              height: 30,
              color: tableColor,
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: pw.Text(tableHeaders[3],
                  style: TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.normal)),
            ),
            pw.Container(
              width: 35,
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: tableColor, width: 10),
                ),
                color: tableColor,
              ),
              padding: const EdgeInsets.only(
                left: 50,
                top: 8,
              ),
              child: pw.Text(tableHeaders[4],
                  style: TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold)),
            ),
          ]),
          for (int i = 0; i < products.length; i++)
            pw.TableRow(children: [
              pw.Container(
                width: 20,
                height: 45,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: tableColor, width: 1.5),
                  ),
                  color: i % 2 == 0 ? PdfColors.white : accentColor,
                ),
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: pw.Text(sl[i],
                    style: const TextStyle(
                      color: PdfColors.black,
                      fontSize: 10,
                    )),
              ),
              pw.Container(
                width: 100,
                height: 45,
                decoration: BoxDecoration(
                  color: i % 2 == 0 ? PdfColors.white : accentColor,
                ),
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: pw.Text(productname[i],
                    style: const TextStyle(
                      color: PdfColors.black,
                      fontSize: 10,
                    )),
              ),
              pw.Container(
                width: 20,
                height: 45,
                decoration: BoxDecoration(
                  color: i % 2 == 0 ? PdfColors.white : accentColor,
                ),
                padding: const EdgeInsets.only(left: 15, top: 15),
                child: pw.Text(price[i].toString(),
                    style: const TextStyle(
                      color: PdfColors.black,
                      fontSize: 10,
                    )),
              ),
              pw.Container(
                width: 20,
                height: 45,
                decoration: BoxDecoration(
                  color: i % 2 == 0 ? PdfColors.white : accentColor,
                ),
                padding: const EdgeInsets.only(left: 22, top: 15),
                child: pw.Text(qty[i].toString(),
                    style: const TextStyle(
                      color: PdfColors.black,
                      fontSize: 10,
                    )),
              ),
              pw.Container(
                width: 35,
                height: 45,
                decoration: BoxDecoration(
                  border: const Border(
                    right: BorderSide(color: PdfColors.black),
                  ),
                  color: i % 2 == 0 ? PdfColors.white : accentColor,
                ),
                padding: const EdgeInsets.only(left: 50, top: 15),
                child: pw.Text(total[i].toString(),
                    style: const TextStyle(
                      color: PdfColors.black,
                      fontSize: 10,
                    )),
              ),
            ]),
        ]));
  }

  pw.Widget _tableend(Context context) {
    return pw.Container(
        decoration: BoxDecoration(
            color: PdfColors.white,
            border: Border(
                left: BorderSide(color: tableColor),
                right: BorderSide(color: tableColor),
                bottom: BorderSide(
                  color: tableColor,
                ))),
        height: 70,
        margin: const pw.EdgeInsets.only(left: 45.5, right: 45.5));
  }
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMd('en_US');
  return format.format(date);
}

String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}
