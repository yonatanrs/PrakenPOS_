import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCodeView extends StatefulWidget {
  @override
  _GenerateQrCodeViewState createState() => _GenerateQrCodeViewState();
  final String? paymentLink;
  GenerateQrCodeView({this.paymentLink});
}

class _GenerateQrCodeViewState extends State<GenerateQrCodeView> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorBlueDark,
          title: Text(
            'Scan QR Code',
            style: textHeaderView,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: colorAccent,
            onPressed: () => _onBackPress(),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: QrImage(
              data: widget.paymentLink!,
              size: 320,
              gapless: false,
              errorStateBuilder: (cxt, err) {
                return Container(
                  child: Center(
                    child: Text(
                      "Sorry, happen problem",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPress() async{
    await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return Future.value(false);
  }
}
