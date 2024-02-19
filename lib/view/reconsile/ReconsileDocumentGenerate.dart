import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/models/Reconsile.dart';
import 'package:flutter_scs/view/pdf/PdfView.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class ReconsileGenerate {
  final pdf = pw.Document();
  // ignore: non_constant_identifier_names
  Future<bool> CreatePdf(
      BuildContext context, Reconsile reconsile) async {
    writeOnPdf(reconsile);
    savePdf(reconsile);
    String documentPath = '';
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      documentPath = documentDirectory.path;
    } catch (ex) {
      print('Error get path 2 : ' + ex.toString());
    }
    
    var dateReconsile = formatDate(reconsile.reconsileDate!);
    String path = "$documentPath/Reconsile$dateReconsile.pdf";
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PdfView(title: 'Reconsile Digital', path: path);
    }));
    return true;
  }

  Future writeOnPdf(Reconsile model) async {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
              child: pw.Text("RECONSILE",
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold))),
          pw.Center(
              child: pw.Text("Tanggal :  ${formatDate(model.reconsileDate!)}",
                  style: pw.TextStyle(fontSize: 10))),
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
                      child: pw.Text('System',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)))),
              pw.Container(
                  margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                  width: ScreenUtil().setWidth(10),
                  child: pw.Center(
                      child: pw.Text('Fisik',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)))),
              pw.Container(
                  margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                  width: ScreenUtil().setWidth(15),
                  child: pw.Center(
                      child: pw.Text('Selisih',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)))),
            ]),
            for (int a = 0; a < model.listRecapStock!.length; a++)
              pw.TableRow(children: [
                pw.Container(
                    width: ScreenUtil().setWidth(70),
                    margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                    child: pw.Text(model.listRecapStock![a].nameProduct!,
                        style: pw.TextStyle(fontSize: 12))),
                pw.Container(
                    margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(25),
                    child: pw.Center(
                        child: pw.Text(model.listRecapStock![a].qtySystem.toString(),
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 12)))),
                pw.Container(
                    margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(10),
                    child: pw.Center(
                        child: pw.Text(model.listRecapStock![a].qtyFisik.toString(),
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 12)))),
                pw.Container(
                    margin: pw.EdgeInsets.all(ScreenUtil().setHeight(5)),
                    width: ScreenUtil().setWidth(15),
                    child: pw.Center(
                        child: pw.Text(model.listRecapStock![a].different.toString(),
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(fontSize: 12)))),
              ]),
          ]),
        ];
      },
    ));
  }

  Future savePdf(Reconsile model) async {
    String documentPath = '';
    try {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      documentPath = documentDirectory.path;
    } catch (exception) {
      print('Error get Path : ' + exception.toString());
    }
    var dateReconsile = formatDate(model.reconsileDate!);
    File file = File("$documentPath/Reconsile$dateReconsile.pdf");

    try {
      file.writeAsBytesSync(List.from(await pdf.save()));
    } catch (exception) {
      print('Error Save : ' + exception.toString());
    }
  }

  String formatDate(String date) {
    var result = DateFormat('dd/MMMM/yyyy hh:mm:ss').parse(date);
    var output = DateFormat('dd MMM yyyy');
    return output.format(result);
  }
}
