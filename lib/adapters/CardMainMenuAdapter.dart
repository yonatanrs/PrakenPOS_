import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/dashboard_approvalpp.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/dashboard_ordersample.dart';
import 'package:flutter_scs/mobile_sms/lib/view/dashboard/dashboard_ordertaking.dart';
import 'package:flutter_scs/view/customer/AllCustomerView.dart';
import 'package:flutter_scs/view/exhibition/exhibition-page.dart';
import 'package:flutter_scs/view/priceDiscount/PriceDiscountView.dart';
import 'package:flutter_scs/view/product/AllProductView.dart';
import 'package:flutter_scs/view/reconsile-exhibition/reconsile_exhibition_view.dart';
import 'package:flutter_scs/view/reconsile/ReconsileView.dart';
import 'package:flutter_scs/view/stock/StockView.dart';
import 'package:flutter_scs/view/transaction/MainTransactionView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../view/approval-promo/approval-promo-page.dart';
import '../view/set-promo/set-promo-page.dart';

class CardMainMenu extends StatelessWidget {
  final String title;
  final String nameIcon;
  final int index;
  CardMainMenu({required this.title, required this.nameIcon, required this.index});

  @override
  Widget build(BuildContext context) {
    print("nameIcon $nameIcon");

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return InkWell(
      onTap: () => goToScreen(index),
      child: Card(
        shadowColor: colorAccent,
        elevation: 5,
        color: colorBlueDark,
        child: Center(
          child: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child:
                    nameIcon==""&&index==0?Icon(
                      Icons.create,
                      color: colorNetral,
                    ):nameIcon==""&&index==1?Icon(
                        Icons.event_available,
                        color: colorNetral,
                      ):nameIcon==""&&index==2?Icon(
                      Icons.approval,
                      color: colorNetral,
                    ):SvgPicture.asset(nameIcon, color: colorNetral,)
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textButtonMainMenu,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToScreen(int index) {
    switch (index) {
      case 0:
        Get.to(SetPromoPage());
        break;
      case 1:
        Get.to(ExhibitionPage());
        break;
      case 2:
        Get.to(ApprovalPromoPage());
        break;
      case 3:
        Get.to(AllProductView());
        break;
      case 4:
        Get.to(AllCustomerView());
        break;
      case 5:
        Get.to(PriceDiscountView());
        break;
      case 6:
        Get.to(ReconsileView());
        break;
      case 7:
        Get.to(MainTransactionView(indexTab: 0));
        break;
      case 8:
        Get.to(StockView());
        break;
      case 9:
        Get.to(ReconsileViewExhibition());
        break;
      case 10:
        Get.to(DashboardApprovalPP());
        break;
      case 11:
        Get.to(DashboardOrderTaking());
        break;
      case 12:
        Get.to(DashboardOrderSample());
        break;
      default:
      // Handle the default case, such as showing an error message or navigating to a default page
        break;
    }
  }
}
