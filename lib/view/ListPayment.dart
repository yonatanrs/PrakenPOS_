import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/adapters/CardListPayment.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/models/PaymentLink.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../models/ApiConstant.dart';

class ListPayment extends StatefulWidget {
  @override
  _ListPaymentState createState() => _ListPaymentState();
  final String amount;
  final String idOrder;
  ListPayment({required this.idOrder, required this.amount});
}

class _ListPaymentState extends State<ListPayment> {

  late String paymentLink;
  void initState() {
    super.initState();
    getPaymentLink(widget.idOrder);
    // getListPayment();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: () => onBackPressLines(),
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
            "List Payment Method",
            style: textHeaderView,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Total Amount',
                          style: textDescription,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(widget.amount,
                            textAlign: TextAlign.center, style: textAmount),
                      )
                    ],
                  )),
              SizedBox(height: 40),
              CardListPayment(
                paymentLink: paymentLink,
                typePayment: 1,
              ),
              CardListPayment(
                paymentLink: paymentLink,
                typePayment: 2,
              ),
              InkWell(
                onTap: () async{
                  print("idOrder : ${widget.idOrder}");
                  var url = "${ApiConstant().urlApi}api/DetailPayment?idOrder=${widget.idOrder}";
                  final response = await put(Uri.parse(url));
                  print("url cash ${url}");
                  print("status : ${response.statusCode}");
                  print("status : ${response.body}");
                  if(response.statusCode==200){
                    Get.snackbar("Success", "",backgroundColor: Colors.green);
                    Get.offAll(MainMenuView());
                  }else{
                    Get.snackbar("Error", "${response.body}",backgroundColor: Colors.red);
                  }
                },
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
                          "Cash",
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> onBackPressLines() async{
    await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return Future.value(false);
  }

  void getPaymentLink(String idOrder) async {
    PaymentLink models = await PaymentLink.getPaymentLink(idOrder);
    setState(() {
      paymentLink = models.linkPayment!;
    });
  }
}
