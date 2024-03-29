import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_scs/view/transaction/MainTransactionView.dart';

class WebViewPayment extends StatefulWidget {
  @override
  _PaymentViewState createState() => _PaymentViewState();
  final String urlPayment;

  WebViewPayment({required this.urlPayment});
}

class _PaymentViewState extends State<WebViewPayment> {
  late String urlWebsite;

  late InAppWebViewController _webViewController;
  String url = "";
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Payment Link", style: textHeaderView),
            backgroundColor: colorBlueDark,
            leading: IconButton(
              icon: Icon(
                Icons.home,
                color: colorAccent,
              ),
              onPressed: _backHomePress,
            ),
            elevation: 1),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container()),
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(widget.urlPayment,),
                  ),
                  onLoadError: (controller, url, code, message) =>
                      setState(() {
                    _webViewController = controller;
                    this.url = message;
                    print('Message Error : ' +
                        message +
                        "| code :" +
                        code.toString());
                  }),
                  onLoadHttpError:
                      (controller, url, statusCode, description) =>
                          setState(() {
                    this.url = description;
                  }),
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                  )),
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                  },
                  onLoadStart:
                      (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      _webViewController = controller;
                    });
                  },
                  onLoadStop:
                      (controller, url) async {
                    setState(() {
                      this.url = url.toString();
                      _webViewController = controller;
                    });
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future<bool> _backHomePress() async {
    await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return MainTransactionView(indexTab: 0);
    }));
    return Future.value(false);
  }

  Future<bool> _onBackPress() async {
    await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return MainTransactionView(indexTab: 0);
    }));
      return true;
  }
}
