import 'package:flutter/material.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BottomQRCode extends StatelessWidget {
  final String? paymentLink;
  BottomQRCode({this.paymentLink});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF737373),
      child: Form(
        child: Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: colorNetral,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Scan Qr Code',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close_rounded))
                  ],
                ),
                SizedBox(height: 20),
                QrImage(
                  data: paymentLink!,
                  version: QrVersions.auto,
                  size: 320,
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
                Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () => onBackPressLines(context),
                      child: Text(
                        'Done',
                        style: textButton,
                      ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onBackPressLines(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
  }
}
