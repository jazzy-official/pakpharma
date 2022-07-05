import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:pak_pharma/Controllers/profilecontroller.dart';
import '../Models/account_model.dart';
import '../api/api_checker.dart';
import '../api/api_client.dart';



class PayableController extends GetxController {
  final prof = Get.put(ProfileController());
  List<Account>? payable;
  List<Account>? foundPayable = [];
  ApiClient api = ApiClient();
  @override
  Future<void> onInit() async {
    await refreshAll();
    super.onInit();
  }
  Future refreshAll() async {
    await setPayable(prof.userDetail?.organization.organizationId);
  }
  Future setPayable(String? id) async {
    Response response = await api.getData("api/Dashboard/AccountsPayable",query: {"organizationId":id});
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Map<String, dynamic> Data = response.body;
      List<dynamic> data = Data["Data"];
      List<Account> payabledata = data
          .map(
            (dynamic item) => Account.fromJson(item),
      ).toList();
      payable = payabledata.where((data) => data.currentbalance != 0||data.currentbalance != 0).toList();
      print(payable?.length);
      foundPayable = payable;
      update();
    } else {
      ApiChecker().checkApi(response);
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to get payable data');
    }
  }
  void runFilter(String enteredKeyword) {
    List<Account> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = payable!;
    } else {
      results = payable!
          .where((user) => user.accounttitle
          .toUpperCase()
          .contains(enteredKeyword.toUpperCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    foundPayable = results;
    update();

  }
}
