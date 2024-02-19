import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scs/view/FormNewCustomerView.dart';
import 'package:flutter_scs/view/customer/ExistingCustomerView.dart';
import 'package:flutter_scs/view/customer/NewCustomerView.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllCustomerView extends StatefulWidget {
  @override
  _AllCustomerViewState createState() => _AllCustomerViewState();
}

class _AllCustomerViewState extends State<AllCustomerView> {
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
                  'Daftar Customer',
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
                  onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FormNewCustomerView();
                      })),
                  backgroundColor: colorBlueDark,
                  child: SvgPicture.asset(
                    'lib/assets/icons/Plus.svg',
                    color: colorNetral,
                  )),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              body: TabBarView(
                children: <Widget>[ExistingCustomerView(), NewCustomerView()],
              ),
            ),
          ),
        ));
  }

  Future<bool> _onBackPress() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return true;
  }
}
