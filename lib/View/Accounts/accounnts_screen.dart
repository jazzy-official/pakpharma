import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:pak_pharma/Controllers/account_controller.dart';
import 'package:pak_pharma/Controllers/balance_controller.dart';
import 'package:pak_pharma/View/Accounts/receivable_screen.dart';
import 'package:pak_pharma/View/header.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Constants/loading_widget.dart';

class AccountScreen extends StatelessWidget {
   AccountScreen({Key? key}) : super(key: key);
   var formatter = NumberFormat('#,##,000');
  var accountcont = Get.put(BalanceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GetBuilder<BalanceController>(
        init: BalanceController(),
        builder: (cont) => SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => { cont.refreshAll() },
            child: ListView(
              children: [
                //Accounts Card
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Header(title: "Accounts"),
                ),
                Divider(color: Colors.grey.shade400,),
                buildAccounts(context,cont),

              ],
            ),
          )
        ),
      ),
    );
  }

   Widget buildAccounts(BuildContext context,BalanceController balanceController) {
     final List<ChartData> chartData = [
       ChartData('Banks', balanceController.summary?.bankbBalance??0, Color(0xff2fc0d6)),
       ChartData('Payable', balanceController.summary?.payable??0, Color(0xff40b5f3)),
       ChartData('Cash in hand', balanceController.summary?.cashBalance??0, Color(0xffff447b)),
       ChartData('Receivable',  balanceController.summary?.receivable??0, Color(0xffffd045))
     ];
     return Container(
       margin: const EdgeInsets.all(0),
       decoration: BoxDecoration(

         // color: const Color(0xfff1f6f8),
         // borderRadius: const BorderRadius.only(
         //     topLeft: Radius.circular(10),
         //     topRight: Radius.circular(10),
         //     bottomLeft: Radius.circular(10),
         //     bottomRight: Radius.circular(10)
         // ),
         // boxShadow: [
         //   BoxShadow(
         //     color: Colors.grey.withOpacity(0.5),
         //     spreadRadius: 5,
         //     blurRadius: 7,
         //     offset: const Offset(0, 3), // changes position of shadow
         //   ),
         // ],
       ),

       child: Center(
           child: Column(
             children: [
               balanceController.summary != null ?
               SfCircularChart(
                   legend: Legend(isVisible: true,
                     textStyle: const TextStyle(
                       color: Colors.black,
                       // fontSize: 12.5,
                       // fontStyle: FontStyle.italic,
                       // fontWeight: FontWeight.w600
                     ),
                     position: LegendPosition.bottom,
                     overflowMode: LegendItemOverflowMode.wrap,

                     itemPadding: 10,
                   ),

                   series: <CircularSeries>[
                     // Renders doughnut chart
                     DoughnutSeries<ChartData, String>(
                       dataSource: chartData,
                       pointColorMapper:(ChartData data,  _) => data.color,
                       xValueMapper: (ChartData data, _) => data.x,
                       yValueMapper: (ChartData data, _) => data.y,
                       // explode: true,
                       // explodeIndex: 0,
                     )
                   ]
               ):
               const SizedBox(height:200,child: Center(child: CircularProgressIndicator())),
               const SizedBox(height: 15,),
               GridView.count(
                 primary: false,
                 shrinkWrap: true,
                 padding: const EdgeInsets.all(20),
                 crossAxisSpacing: 10,
                 mainAxisSpacing: 10,
                 crossAxisCount: 2,
                 childAspectRatio: 1.6,
                 children: <Widget>[
                   InkWell(
                     onTap: (){
                       Get.to(ReceivableScreen());
                     },
                     child: Container(
                       height:50,
                       width: MediaQuery.of(context).size.width * 0.40,
                       decoration: BoxDecoration(
                         color: Color(0xffffd045),
                         borderRadius: BorderRadius.circular(10),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.grey.withOpacity(0.5),
                             spreadRadius: 5,
                             blurRadius: 7,
                             offset: Offset(0, 3), // changes position of shadow
                           ),
                         ],
                       ),
                       child: Center(child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           Image.asset("assets/images/receivable.png",height: 50,),
                           Text('Receivable',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
                           Text(formatter.format(balanceController.summary?.receivable??0),),
                         ],
                       )),
                     ),
                   ),
                   Container(
                     height:50,
                     width: MediaQuery.of(context).size.width * 0.40,
                     decoration: BoxDecoration(
                       color: Color(0xff40b5f3),
                       borderRadius: BorderRadius.circular(10),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.grey.withOpacity(0.5),
                           spreadRadius: 5,
                           blurRadius: 7,
                           offset: Offset(0, 3), // changes position of shadow
                         ),
                       ],
                     ),
                     child: Center(child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Image.asset("assets/images/payable.png",height: 50,),
                         Text('Payables',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                         Text(formatter.format(balanceController.summary?.payable??0),style: TextStyle(color: Colors.white),),
                       ],
                     )),
                   ),
                   Container(
                     height:50,
                     width: MediaQuery.of(context).size.width * 0.40,
                     decoration: BoxDecoration(
                       color: Color(0xff2fc0d6),
                       borderRadius: BorderRadius.circular(10),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.grey.withOpacity(0.5),
                           spreadRadius: 5,
                           blurRadius: 7,
                           offset: Offset(0, 3), // changes position of shadow
                         ),
                       ],
                     ),
                     child: Center(child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Icon(Icons.account_balance,size: 40,),
                         const Text('Banks',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                         Text( formatter.format(balanceController.summary?.bankbBalance??0),style: TextStyle(color: Colors.white),),
                       ],
                     )),
                   ),
                   Container(
                     height:50,
                     width: MediaQuery.of(context).size.width * 0.4,
                     decoration: BoxDecoration(
                       color: Color(0xffff447b),
                       borderRadius: BorderRadius.circular(10),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.grey.withOpacity(0.5),
                           spreadRadius: 5,
                           blurRadius: 7,
                           offset: Offset(0, 3), // changes position of shadow
                         ),
                       ],
                     ),
                     child: Center(child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Icon(Icons.money,size: 40,),
                         Text('Cash In Hand',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                         Text(formatter.format(balanceController.summary?.cashBalance??0),style: TextStyle(color: Colors.white),),
                       ],
                     )),
                   ),

                 ],
               ),
             ],
           )
       ),
     );
   }
}
class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}