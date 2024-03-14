import 'package:flutter/material.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_history_page2.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_page2.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_approval_page.dart';
import 'package:flutter_scs/mobile_sms/lib/view/transaction/transaction_approved_page.dart';
import 'package:get/get.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: DashboardOrderSample(),
    );
  }
}

class DashboardOrderSample extends StatefulWidget {
  final int? initialIndexs;

  DashboardOrderSample({Key? key, this.initialIndexs}) : super(key: key);

  @override
  _DashboardOrderSampleState createState() => _DashboardOrderSampleState();
}

class _DashboardOrderSampleState extends State<DashboardOrderSample> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialIndexs ?? 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get device width and height for setting the container size dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Sample Order'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Enable tab scrolling
          tabs: [
            Tab(text: "Create Order Sample"),
            Tab(text: "History Order Sample"),
            Tab(text: "Approval Order Sample"),
            Tab(text: "Approved Order Sample"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Replace these with your actual widgets/pages
          TransactionPage2(),
          TransactionHistoryPage2(),
          TransactionApprovalPage(),
          TransactionApprovedPage(),// Duplicate for demonstration; replace with your actual page
        ],
      ),
    );
  }
}