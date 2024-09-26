
import 'dart:convert';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:pak_pharma/Controllers/profilecontroller.dart';
import 'package:pak_pharma/Models/receivable_model.dart';

import '../Models/payable_model.dart';
import '../api/api_client.dart';
import 'authcontroller.dart';


class ReceivableController extends GetxController {

  final auth = Get.put(AuthController());

  final prof = Get.put(ProfileController());
  List<Receivable>? receivable;
  List<Receivable>? foundreceivable = [];
  ApiClient api = ApiClient();
  @override
  Future<void> onInit() async {
    await refreshAll();
    super.onInit();
  }
  Future refreshAll() async {
    await setReceivable(prof.userDetail?.organization.organizationId);
  }
  Future setReceivable(String? id) async {
    Response response = await api.getData("api/Dashboard/AccountsReceivables",query: {"organizationId":id});
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Map<String, dynamic> receivableData = response.body;
      List<dynamic> data = receivableData["Data"];
      List<Receivable> receivabledata = data
          .map(
            (dynamic item) => Receivable.fromJson(item),
      ).toList();
      receivable = receivabledata.where((receivabledata) => receivabledata.currentbalance != 0||receivabledata.currentbalance != 0).toList();
      print(receivable?.length);
      foundreceivable = receivable;
      update();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to get payable data');
    }
  }
  void runFilter(String enteredKeyword) {
    List<Receivable> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = receivable!;
    } else {
      results = receivable!
          .where((user) => user.accounttitle
          .toUpperCase()
          .contains(enteredKeyword.toUpperCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    foundreceivable = results;
    update();

  }
}
