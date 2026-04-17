



// import 'dart:io';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:media_store_plus/media_store_plus.dart';

// class ReceiptService {
//   /// 1️⃣ Generate PDF (app storage – safe)
//   static Future<File> generateReceipt(Map booking) async {
//     final pdf = pw.Document();
//     final total =
//         (booking['price'] ?? 0) + (booking['extraCharges'] ?? 0);

//     pdf.addPage(
//       pw.Page(
//         build: (_) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               'Payment Receipt',
//               style: pw.TextStyle(
//                 fontSize: 22,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//             pw.Divider(),
//             pw.Text('Payment ID : ${booking['paymentId']}'),
//             pw.Text('Amount Paid : ₹${total.toStringAsFixed(2)}'),
//             pw.Text('Extra Charges : ${booking['extraCharges'].toStringAsFixed(2)??'0'}'),
//             pw.Text('Payment Method : ${booking['paymentMethod']??'UPI'}'),
//             pw.Text('Payment Date : ${booking['paidAt']}'),
//             pw.Text('Payment Status : ${booking['paymentStatus']}'),
//           ],
//         ),
//       ),
//     );

//     final dir = await getExternalStorageDirectory();
//     final file =
//         File('${dir!.path}/receipt_${booking['paymentId']}.pdf');

//     await file.writeAsBytes(await pdf.save());
//     return file;
//   }

//   /// 2️⃣ Copy to Downloads (user visible)
//   static Future<void> saveToDownloads(File file) async {
//     final mediaStore = MediaStore();

//     await mediaStore.saveFile(
//       tempFilePath: file.path,
//       dirType: DirType.download,
//       dirName: DirName.download,
//     );
//   }
// }









import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:flutter/services.dart' show rootBundle;

class ReceiptService {
  /// 1️⃣ Generate PDF (app storage – safe)
  static Future<File> generateReceipt(Map booking) async {
    final pdf = pw.Document();
    final total = (booking['price'] ?? 0) + (booking['extraCharges'] ?? 0);

    // Load logo from assets (add your logo to assets/images/logo.png)
    pw.ImageProvider? logo;
    try {
      final imageData = await rootBundle.load('assets/location_access/location_access.png');
      logo = pw.MemoryImage(imageData.buffer.asUint8List());
    } catch (e) {
      // Logo loading failed, continue without it
    }

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with Logo and App Name
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (logo != null)
                        pw.Container(
                          width: 60,
                          height: 60,
                          child: pw.Image(logo),
                          margin: const pw.EdgeInsets.only(bottom: 8),
                        ),
                      pw.Text(
                        'GoServe',  // ← Change this to your app name
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue900,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Payment Receipt',
                        style: pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: pw.BoxDecoration(
                      color: _getStatusColor(booking['paymentStatus']),
                      borderRadius: pw.BorderRadius.circular(20),
                    ),
                    child: pw.Text(
                      '${booking['paymentStatus']}'.toUpperCase(),
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              
              pw.SizedBox(height: 32),
              
              // Payment ID Section
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Payment ID',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      '${booking['paymentId']}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 24),
              
              // Amount Details
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    _buildDetailRow('Base Amount', '₹${(booking['price'] ?? 0).toStringAsFixed(2)}'),
                    pw.SizedBox(height: 12),
                    _buildDetailRow('Extra Charges', '₹${(booking['extraCharges'] ?? 0).toStringAsFixed(2)}'),
                    pw.SizedBox(height: 16),
                    pw.Divider(color: PdfColors.grey400),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total Amount Paid',
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          '₹${total.toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 24),
              
              // Payment Information
              pw.Text(
                'Payment Information',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.SizedBox(height: 12),
              _buildInfoRow('Payment Method', '${booking['paymentMethod'] ?? 'UPI'}'),
              pw.SizedBox(height: 8),
              _buildInfoRow('Payment Date', '${booking['paidAt']}'),
              
              pw.Spacer(),
              
              // Footer
              pw.Container(
                padding: const pw.EdgeInsets.only(top: 16),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(color: PdfColors.grey300),
                  ),
                ),
                child: pw.Center(
                  child: pw.Text(
                    'Thank you for your payment!',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey600,
                      fontStyle: pw.FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/receipt_${booking['paymentId']}.pdf');

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Helper: Build detail row for amounts
  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey700,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Helper: Build info row
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 120,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 11,
              color: PdfColors.grey600,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Helper: Get status badge color
  static PdfColor _getStatusColor(dynamic status) {
    final statusStr = status?.toString().toLowerCase() ?? '';
    if (statusStr.contains('success') || statusStr.contains('paid')) {
      return PdfColors.green600;
    } else if (statusStr.contains('pending')) {
      return PdfColors.orange600;
    } else if (statusStr.contains('failed')) {
      return PdfColors.red600;
    }
    return PdfColors.blue600;
  }

  /// 2️⃣ Copy to Downloads (user visible)
  static Future<void> saveToDownloads(File file) async {
    final mediaStore = MediaStore();

    await mediaStore.saveFile(
      tempFilePath: file.path,
      dirType: DirType.download,
      dirName: DirName.download,
    );
  }
}