import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:share_extend/share_extend.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  @override
  _PdfViewState createState() => _PdfViewState();
  final String? title;
  final String? path;
  PdfView({this.title, this.path});
}

class _PdfViewState extends State<PdfView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPress(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title!, style: TextStyle(color: colorBlueDark)),
              backgroundColor: colorNetral,
              leading: BackButton(color: colorBackground,),
              bottom: PreferredSize(
                  child: Container(
                    height: 5,
                    color: colorBackground,
                  ),
                  preferredSize: Size.fromHeight(0.0)),
              actions: [
                GestureDetector(
                  onTap: () {
                    ShareExtend.share(widget.path!, widget.title!);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'Share',
                        style: TextStyle(color: colorBlueDark),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SfPdfViewer.asset(widget.path!),
          ),
    );
  }
  Future<bool> _onBackPress() async {
    Navigator.pop(context);
    return true;
  }
}
