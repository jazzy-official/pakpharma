import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';

import '../../Controllers/receivable_controller.dart';
import '../header.dart';

class ReceivableScreen extends StatelessWidget {
   ReceivableScreen({Key? key}) : super(key: key);
  final formatter = NumberFormat('#,##,000');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ReceivableController>(
        init: ReceivableController(),
        builder: (cont) => SafeArea(
          child: Column(
            children: [
              //Accounts Card
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Header(title: "Receivable"),
              ),
              Divider(
                color: Colors.grey.shade400,
              ),
              cont.receivable != null
                  ? Expanded(
                      child: DataTable2(
                          minWidth: Get.height,
                          dataRowHeight: 70,
                          smRatio: 0.5,
                          lmRatio: 2,
                          columns: const [
                            DataColumn2(label: Text('Sr',style: TextStyle(color: Colors.black)), size: ColumnSize.S),
                            DataColumn2(
                                label: Text('Title',style: TextStyle(color: Colors.black)), size: ColumnSize.L),
                            DataColumn2(
                                label: Text('Opening',style: TextStyle(color: Colors.black)), size: ColumnSize.L),
                            DataColumn2(
                                label: Text('Amount',style: TextStyle(color: Colors.black)), size: ColumnSize.L),
                            DataColumn2(
                                label: Text('Type',style: TextStyle(color: Colors.black)), size: ColumnSize.M),
                          ],
                          rows: List<DataRow>.generate(cont.receivable!.length,
                              (index) {
                            var i = cont.receivable![index];
                            return DataRow(
                                color: MaterialStateProperty.all(index % 2 == 0
                                    ? Colors.grey.shade300
                                    : Colors.white),
                                cells: [
                                  DataCell(Text((index + 1).toString(),style: TextStyle(color: Colors.black))),
                                  DataCell(Text(i.accounttitle,style: TextStyle(color: Colors.black))),
                                  DataCell(Text(formatter.format(i.openingbalance),style: TextStyle(color: Colors.black))),
                                  DataCell(Text(formatter.format(i.currentbalance),style: TextStyle(color: Colors.black))),
                                  DataCell(Text('Debit',style: TextStyle(color: Colors.black))),
                                ]);
                          })),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
