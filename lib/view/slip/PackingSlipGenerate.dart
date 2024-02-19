import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/models/DraftTransaction.dart';
import 'package:flutter_scs/view/pdf/PdfView.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PackingSlipGenerate {
  final pdf = pw.Document();
  // ignore: non_constant_identifier_names
  Future<bool> CreatePdf(
      BuildContext context, TransactionDraft transactionDraft, int type) async {
    writeOnPdf(transactionDraft);
    savePdf(transactionDraft);
    String documentPath = '';
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      documentPath = documentDirectory.path;
    } catch (ex) {
      print('Error get path 2 : ' + ex.toString());
    }
    String path = "$documentPath/PackingSlip${transactionDraft.idOrder}.pdf";
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PdfView(title: 'Packing Slip Digital', path: path);
    }));
    return true;
  }

  Future writeOnPdf(TransactionDraft model) async {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
              child: pw.Text("PACKING SLIP",
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold))),
          pw.Center(
              child: pw.Text("No. Order : " + model.idOrder!,
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
                  width: ScreenUtil().setWidth(15),
                  child: pw.Center(
                      child: pw.Text('Unit',
                          textAlign: pw.TextAlign.center,
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
                      child: pw.Text('Price',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)))),
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
                    width: ScreenUtil().setWidth(25),
                    child: pw.Center(
                        child: pw.Text(model.listDetailTransaction![a].unit!,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 12)))),
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
                        child: pw.Text(model.listDetailTransaction![a].price!,
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 12)))),
              ]),
          ]),
        ];
      },
    ));
  }

  Future savePdf(TransactionDraft model) async {
    String documentPath = '';
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      documentPath = documentDirectory.path;
    } catch (exception) {
      print('Error get Path : ' + exception.toString());
    }
    File file = File("$documentPath/PackingSlip${model.idOrder}.pdf");

    try {
      file.writeAsBytesSync(List.from(await pdf.save()));
    } catch (exception) {
      print('Error Save : ' + exception.toString());
    }
  }
}
