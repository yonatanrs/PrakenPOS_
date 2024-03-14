import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_scs/mobile_sms/lib/models/Approved.dart';
import 'package:flutter_scs/mobile_sms/lib/models/ApprovedDetail.dart';

class TransactionApprovedPresenter extends GetxController {
  var approvedList = <Approved>[].obs;

  @override
  void onReady() {
    super.onReady();
    fetchApproved(); // Pindahkan ke sini untuk auto-refresh data setiap kali halaman ditampilkan
  }

  Future<void> fetchApproved() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int idEmp = int.tryParse(prefs.getString("getIdEmp") ?? '0') ?? 0;
    final Uri url = Uri.parse('http://api-scs.prb.co.id/api/SampleApproval/$idEmp?approved=true');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        approvedList.value = jsonResponse.map((data) => Approved.fromJson(data)).toList();
      } else {
        Get.snackbar('Info', 'No approved data found', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showApprovedDetail(BuildContext context, int id) async {
    final Uri url = Uri.parse('http://api-scs.prb.co.id/api/SampleApproval/$id?detail=true');
    try {
      final response = await http.get(url, headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final details = (jsonResponse['Lines'] as List)
            .map((detailJson) => ApprovedDetail.fromJson(detailJson))
            .toList();

        String productName = '';
        String productQtyUnit = '';

        // Menampilkan detail produk pertama (jika ada)
        if (details.isNotEmpty) {
          final firstDetail = details.first;
          productName = firstDetail.product;
          productQtyUnit = 'Qty: ${firstDetail.qty}, Unit: ${firstDetail.unit}';
        } else {
          // Jika tidak ada detail produk
          productName = 'No product details available';
          productQtyUnit = '';
        }

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.33,
              maxChildSize: 0.5,
              builder: (_, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            ListTile(
                              title: Text(productName, style: TextStyle(overflow: TextOverflow.ellipsis), maxLines: 2),
                              subtitle: Text(productQtyUnit),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      } else {
        Get.snackbar('Error', 'Failed to fetch detail: ${response.statusCode}', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

}

