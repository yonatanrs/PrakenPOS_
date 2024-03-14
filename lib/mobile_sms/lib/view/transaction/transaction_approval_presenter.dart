import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_scs/mobile_sms/lib/models/Approval.dart'; // Sesuaikan path
import 'package:flutter_scs/mobile_sms/lib/models/ApprovalDetail.dart'; // Sesuaikan path

class TransactionApprovalPresenter extends GetxController {
  var approvalList = <Approval>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchApprovals();
  }


  Future<void> fetchApprovals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");
    final int idEmp = int.tryParse(prefs.getString("getIdEmp") ?? '0') ?? 0;
    final Uri url = Uri.parse('http://api-scs.prb.co.id/api/SampleApproval/$idEmp');

    try {
      final response = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body) as List;
        approvalList.value = jsonResponse
            .map((data) => Approval.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        approvalList.clear();
      }
    } catch (e) {
      approvalList.clear();
      print('Exception occurred: $e');
    }
  }


  void showApprovalDetail(BuildContext context, int id) async {
    final url = 'http://api-scs.prb.co.id/api/SampleApproval/$id?detail=true';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final details = (jsonResponse['Lines'] as List)
            .map((detailJson) => ApprovalDetail.fromJson(detailJson))
            .toList();

        Get.bottomSheet(
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Wrap(
              children: [
                ...details.map((detail) => ListTile(
                  title: Text(detail.product),
                  subtitle: Text('Qty: ${detail.qty}, Unit: ${detail.unit}'),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => sendApproval(id, true), // Approve
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Approve'),
                    ),
                    ElevatedButton(
                      onPressed: () => sendApproval(id, false), // Reject
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Reject'),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: Text('Close'),
                    ),
                  ],
                )
              ],
            ),
          ),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black54,
        );
      } else {
        Get.snackbar('Error', 'Failed to fetch detail: ${response.statusCode}', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }


  void sendApproval(int id, bool isApproved) async {
    final prefs = await SharedPreferences.getInstance();
    final int idEmp = int.tryParse(prefs.getString("getIdEmp") ?? '0') ?? 0;
    final int status = isApproved ? 1 : 2; // Misal, 1 untuk Approved, 2 untuk Rejected
    final Uri url = Uri.parse('http://api-scs.prb.co.id/api/SampleApproval/$idEmp?approved=true');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "id": id,
          "idEmp": idEmp,
          "status": status,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', isApproved ? 'Approval status updated to Approved.' : 'Approval status updated to Rejected.', snackPosition: SnackPosition.BOTTOM);
        fetchApprovals(); // Refresh the list
      } else {
        Get.snackbar('Error', 'Failed to update status: ${response.statusCode}', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

}
