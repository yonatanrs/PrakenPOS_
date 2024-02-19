import 'package:flutter/material.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_history_page2.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_page.dart';
import 'package:get/get.dart';
import '../../../../assets/style.dart';
import '../HistoryNomorPP_All.dart';
import '../input-page/input-page-new.dart';

class DashboardOrderSample extends StatefulWidget {
  int? initialIndexs;

  DashboardOrderSample({Key? key, this.initialIndexs}) : super(key: key);

  @override
  State<DashboardOrderSample> createState() => _DashboardOrderSampleState();
}

class _DashboardOrderSampleState extends State<DashboardOrderSample> {

  checkInitialIndexTabbar(){
    if(widget.initialIndexs==null||widget.initialIndexs==0){
      tabController.initialIndex = 0;
    }else if(widget.initialIndexs==1){
      tabController.initialIndex = 1;
      Future.delayed(Duration(seconds: 1),(){
        tabController.controller.animateTo(tabController.initialIndex!);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late final tabController = Get.put(DashboadOrderSampleTabController());

  @override
  Widget build(BuildContext context) {
    checkInitialIndexTabbar();
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: colorBlueDark,
        foregroundColor: Colors.white,
        title: Text("Dashboard Order Sample",),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: DefaultTabController(
            initialIndex: tabController.initialIndex!,
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  unselectedLabelColor: Colors.black,
                  labelColor: colorBlueDark,
                  controller: tabController.controller,
                  tabs: [
                    Tab(text: "Create Order Sample"),
                    Tab(text: "History Order Sample"),
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
                        child: TransactionHistoryPage2(),
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

class DashboadOrderSampleTabController extends GetxController with GetSingleTickerProviderStateMixin {
  int initialIndex = 0;
  late TabController controller;

  DashboadOrderSampleTabController({this.initialIndex=0});

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
