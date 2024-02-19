import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_scs/assets/style.dart';
import 'package:flutter_scs/view/MainMenuView.dart';
import 'package:flutter_scs/view/transaction/tabs/TransactionDraftView.dart';
import 'package:flutter_scs/view/transaction/tabs/TransactionView.dart';

class MainTransactionView extends StatefulWidget {
  @override
  _MainTransactionViewState createState() => _MainTransactionViewState();
  final int indexTab;
  MainTransactionView({required this.indexTab});
}

class _MainTransactionViewState extends State<MainTransactionView> {
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
          initialIndex: widget.indexTab,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: colorBlueDark,
              title: Text(
                'Transaction',
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
                    text: "All",
                  ),
                  Tab(
                    text: "Draft",
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[TransactionView(), TransactionDraftView()],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPress() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainMenuView();
    }));
    return true;
  }
}
