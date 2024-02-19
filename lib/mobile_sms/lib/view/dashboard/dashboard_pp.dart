import 'package:flutter/material.dart';
import 'package:flutter_scs/mobile_sms/lib/view/HistoryNomorPP_All.dart';
import 'package:flutter_scs/mobile_sms/lib/view/input-page/input-page-new.dart';
import 'package:flutter_scs/mobile_sms/lib/view/input-page/input-page-presenter-new.dart';
import 'package:get/get.dart';


class DashboardPP extends StatefulWidget {
  int? initialIndexs;

  DashboardPP({Key? key, this.initialIndexs}) : super(key: key);

  @override
  State<DashboardPP> createState() => _DashboardPPState();
}

class _DashboardPPState extends State<DashboardPP> {


  checkInitialIndexTabbar(){
    print("widget.initialIndexs :${widget.initialIndexs}");
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
    checkInitialIndexTabbar();
  }
  final tabController = Get.put(DashboardPPTabController());
  final inputPagePresenter = Get.put(InputPagePresenterNew());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Dashboard PP"),
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
                labelColor: Colors.green,
                controller: tabController.controller,
                tabs: [
                  Tab(text: "Create PP"),
                  Tab(text: "History PP"),
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
                      child: InputPageNew(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: Get.height-670),
                      child: HistoryAll(),
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

class DashboardPPTabController extends GetxController with GetSingleTickerProviderStateMixin {
  // dynamic myTab;
  int initialIndex = 0;
  DashboardPPTabController({this.initialIndex=0});

  late TabController controller;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 1),(){
      controller = TabController(vsync: this, length: 2, initialIndex: initialIndex);
    });
  }
}