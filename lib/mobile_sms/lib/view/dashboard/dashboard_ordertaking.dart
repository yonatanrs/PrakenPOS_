import 'package:flutter/material.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_history_page.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_page.dart';
import 'package:get/get.dart';
import '../../../../assets/style.dart';

class DashboardOrderTaking extends StatefulWidget {
  int? initialIndexs;

  DashboardOrderTaking({Key? key, this.initialIndexs}) : super(key: key);

  @override
  State<DashboardOrderTaking> createState() => _DashboardOrderTakingState();
}

class _DashboardOrderTakingState extends State<DashboardOrderTaking> {

  checkInitialIndexTabbar(){
    if(widget.initialIndexs==null||widget.initialIndexs==0){
      tabController.initialIndex = 0;
    }else if(widget.initialIndexs==1){
      tabController.initialIndex = 1;
      Future.delayed(Duration(seconds: 1),(){
        tabController.controller.animateTo(tabController.initialIndex);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late final tabController = Get.put(DashboadOrderTakingTabController());

  @override
  Widget build(BuildContext context) {
    checkInitialIndexTabbar();
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: colorBlueDark,
        foregroundColor: Colors.white,
        title: Text("Dashboard Order Taking",),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: DefaultTabController(
            initialIndex: tabController.initialIndex,
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: colorBlueDark,
                  controller: tabController.controller,
                  tabs: [
                    Tab(text: "Create Order Taking"),
                    Tab(text: "History Order Taking"),
                  ],
                ),
                Container(
                  width: Get.width,
                  height: Get.height,
                  child: TabBarView(
                    controller: tabController.controller,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: Get.height-670),
                        child: TransactionPage(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: Get.height-670),
                        child: TransactionHistoryPage(),
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}

class DashboadOrderTakingTabController extends GetxController with GetSingleTickerProviderStateMixin {
  int initialIndex = 0;
  late TabController controller;

  DashboadOrderTakingTabController({this.initialIndex=0});

  @override
  void onInit() {
    super.onInit();
    // Initialize the controller without delay
    controller = TabController(vsync: this, length: 2, initialIndex: initialIndex);
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
