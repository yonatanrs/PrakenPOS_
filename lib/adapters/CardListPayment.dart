import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/view/paymentMethod/BottomQrCode.dart';
import 'package:flutter_scs/view/paymentMethod/WebViewPayment.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardListPayment extends StatelessWidget {
  // final Data models;
  // final BuildContext context;
  // final String idOrder;
  // final String amount;
  final String paymentLink;
  final int typePayment;
  CardListPayment({required this.paymentLink, required this.typePayment});
  // CardListPayment({this.models, this.context, this.idOrder, this.amount});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return InkWell(
      onTap: () => nextStep(paymentLink, typePayment, context),
      // nextStep(idOrder, models.bankCode, models.productCode, amount),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: colorBlueSky,
              blurRadius: 4.0,
            ),
          ],
          color: Colors.white,
        ),
        margin: EdgeInsets.all(ScreenUtil().setWidth(15)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                typePayment == 1 ? 'Payment Method (WebView)' : 'Generate QR Code',
                style: textHeaderCard,
                textAlign: TextAlign.left,
              ),
              SvgPicture.asset(
                'lib/assets/icons/Chevron_right.svg',
                color: colorBlueDark,
              )
            ],
          ),
        ),
      ),
    );
  }

  void nextStep(String paymentLink, int typePayment, BuildContext context) {
    if (typePayment == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return WebViewPayment(
          urlPayment: paymentLink,
        );
      }));
    } else {
      bottomDialogQRCode(context, paymentLink);
    }
  }

  void bottomDialogQRCode(BuildContext context, String url) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return BottomQRCode(
            paymentLink: url,
          );
        });
  }
  // Future<bool> nextStep(
  //     String idOrder, String codeBank, String codeProduct, String amount) {
  //   return Navigator.pushReplacement(context,
  //       MaterialPageRoute(builder: (context) {
  //     return PaymentView(
  //       idOrder: idOrder,
  //       codeBank: codeBank,
  //       codeProduct: codeProduct,
  //       amount: amount,
  //     );
  //   }));
  // }
}
