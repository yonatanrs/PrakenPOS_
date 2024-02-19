import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/view/priceDiscount/FormDiscountView.dart';
import 'package:flutter_scs/view/priceDiscount/tabs/ExistingPriceDiscountView.dart';
import 'package:flutter_scs/view/priceDiscount/tabs/NewPriceDiscountView.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/view/MainMenuView.dart';

class PriceDiscountView extends StatefulWidget {
  @override
  _PriceDiscountViewState createState() => _PriceDiscountViewState();
}

class _PriceDiscountViewState extends State<PriceDiscountView> {
  
  @override
  Widget build(BuildContext context) {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: _onBackPress,
      child: MaterialApp(
          home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: colorBlueDark,
            title: Text(
              'Price & Discount',
              style: textHeaderView,
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: colorAccent,
              onPressed: () => _onBackPress(),
            ),
            bottom: TabBar(
              indicatorPadding: EdgeInsets.all(ScreenUtil().setHeight(1)),
              labelPadding: EdgeInsets.all(ScreenUtil().setHeight(3)),
              indicatorColor: colorBlueSky,
              indicator: BubbleTabIndicator(
                indicatorHeight: ScreenUtil().setHeight(35.0),
                indicatorColor: colorBackground,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              labelStyle: textHeaderView,
              labelColor: colorAccent,
              tabs: <Widget>[
                Tab(
                  text: "Existing",
                ),
                Tab(
                  text: "New",
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              child: SvgPicture.asset(
                'lib/assets/icons/Plus.svg',
                color: colorNetral,
              ),
              onPressed: () => navigateFormPriceDisc()),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: TabBarView(
            children: <Widget>[
              ExistingPriceDiscountView(),
              NewPriceDiscountView()
            ],
          ),
        ),
      )),
    );
  }

  void navigateFormPriceDisc() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FormDiscountView();
    }));
  }

  Future<bool> _onBackPress() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return true;
  }
}
