import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/view/transaction/MainTransactionView.dart';
import 'package:share_extend/share_extend.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PackingSlipView extends StatefulWidget {
  @override
  _PackingSlipViewState createState() => _PackingSlipViewState();
  final String path;
  PackingSlipView({required this.path});
}

class _PackingSlipViewState extends State<PackingSlipView> {
  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Future<bool> onBackPressLines() async{
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
        return MainTransactionView(indexTab: 1);
      }));
      return Future.value(false);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorBlueDark,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: colorAccent,
            ),
            onPressed: onBackPressLines,
          ),
          title: Text(
            "Packing Slip",
            style: textHeaderView,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.share,
          ),
          onPressed: () {
            ShareExtend.share(widget.path, "file");
          },
        ),
        body: SfPdfViewer.asset(
          widget.path,
        ));
  }
}
