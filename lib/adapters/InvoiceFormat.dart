import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/models/Invoice.dart';
import 'package:flutter_scs/view/pdf/PdfView.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceFormat {
  final pdf = pw.Document();
  void createPdf(String id, BuildContext context, int type) async {
    Invoice invoiceModel = new Invoice();

    Invoice.getTransactionInvoice(id).then((value) async {
      invoiceModel = value;
      writeOnPdf(invoiceModel);
      savePdf(invoiceModel);
      String? documentPath;
      try {
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        documentPath = documentDirectory.path;
      } catch (ex) {
        print('Error get path 2 : ' + ex.toString());
      }
      String path =
          "$documentPath/Invoice" + invoiceModel.orderId.toString() + ".pdf";
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PdfView(
          title: 'Invoice Digital',
          path: path,
        );
      }));
    });
  }
// /data/user/0/com.example.flutter_scs/app_flutter/InvoicePRBs00115062021182824.pdf
  Future writeOnPdf(Invoice model) async {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
              child: pw.Text("INVOICE",
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold))),
          pw.Center(
              child: pw.Text("No. Order : " + model.orderId!,
                  style: pw.TextStyle(fontSize: 10))),
          pw.SizedBox(height: ScreenUtil().setHeight(15)),
          pw.Text('Name Customer : ' + model.nameCustomer!,
              style: pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: ScreenUtil().setHeight(15)),
          pw.Table(border: pw.TableBorder(), children: [
            pw.TableRow(children: [
              pw.Container(
                  width: ScreenUtil().setWidth(70),
                  margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                  child: pw.Center(
                      child: pw.Text('Nama Produk',
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)))),
              pw.Container(
                  margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                  width: ScreenUtil().setWidth(10),
                  child: pw.Center(
                      child: pw.Text('Qty',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)))),
              pw.Container(
                  margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                  width: ScreenUtil().setWidth(15),
                  child: pw.Center(
                      child: pw.Text('Discount',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)))),
              pw.Container(
                  margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                  width: ScreenUtil().setWidth(25),
                  child: pw.Center(
                      child: pw.Text('Total',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold))))
            ]),
            for (int a = 0; a < model.listDetailTransaction!.length; a++)
              pw.TableRow(children: [
                pw.Container(
                    width: ScreenUtil().setWidth(70),
                    margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                    child: pw.Text(model.listDetailTransaction![a].nameProduct!,
                        style: pw.TextStyle(fontSize: 12))),
                pw.Container(
                    margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(10),
                    child: pw.Center(
                        child: pw.Text(model.listDetailTransaction![a].qty!,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 12)))),
                pw.Container(
                    margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(15),
                    child: pw.Center(
                        child: pw.Text(model.listDetailTransaction![a].discount!,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 12)))),
                pw.Container(
                    margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(25),
                    child: pw.Center(
                        child: pw.Text(
                            model.listDetailTransaction![a].totalAmount!,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 12))))
              ]),
          ]),
          pw.SizedBox(height: ScreenUtil().setHeight(15)),
          pw.Text('Total transaksi Anda sebesar ' + model.amount!,
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
        ];
      },
    ));
  }

  Future savePdf(Invoice model) async {
    String? documentPath;
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      documentPath = documentDirectory.path;
    } catch (exception) {
      print('Error get Path : ' + exception.toString());
    }
    File file =
        File("$documentPath/Invoice" + model.orderId.toString() + ".pdf");

    try {
      file.writeAsBytesSync(List.from(await pdf.save()));
    } catch (exception) {
      print('Error Save : ' + exception.toString());
    }
  }
}
