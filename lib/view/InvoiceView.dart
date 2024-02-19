import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/view/transaction/MainTransactionView.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/Invoice.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class InvoiceView extends StatefulWidget {
  @override
  _InvoiceViewState createState() => _InvoiceViewState();
  final String? path;
  InvoiceView({this.path});
}

class _InvoiceViewState extends State<InvoiceView> {
  Invoice? modelInvoice;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return SafeArea(
      child: WillPopScope(
        onWillPop: onBackPressLines,
        child: Scaffold(
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
                "Invoice",
                style: textHeaderView,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.share,
              ),
              onPressed: () {
                ShareExtend.share(widget.path!, "file");
              },
            ),
            body: SfPdfViewer.asset(
              widget.path!,
            )),
      ),
    );
  }

  Future<bool> onBackPressLines() async {
    await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return MainTransactionView(indexTab: 1);
    }));
    return Future.value(false);
  }
}
