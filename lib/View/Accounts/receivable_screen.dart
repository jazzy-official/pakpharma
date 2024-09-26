import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../Controllers/receivable_controller.dart';
import '../header.dart';

class ReceivableScreen extends StatelessWidget {
  const ReceivableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GetBuilder<ReceivableController>(
        init: ReceivableController(),
        builder: (cont) => SafeArea(
            child:Column(
              children: [
                //Accounts Card
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Header(title: "Receivable"),
                ),
                Divider(color: Colors.grey.shade400,),
                cont.receivable!=null?
                    Expanded(child: DataTable2(
                      minWidth: 600,
                      columns: const [
                        DataColumn(label: Text('Sr')),
                        DataColumn(label: Text('Title')),
                        DataColumn(label: Text('Opening')),
                        DataColumn(label: Text('Amount')),
                        DataColumn(label: Text('Type')),
                      ],
                       rows: List<DataRow>.generate(
                            cont.receivable!.length,
                                (index)
                                {
                                  var i = cont.receivable![index];
                                    return DataRow(
                                      color: Colors.grey,
                                        cells: [
                                      DataCell(Text((index+1).toString())),
                                      DataCell(Text(i.accounttitle)),
                                      DataCell(Text(i.openingbalance.toString())),
                                      DataCell(Text(i.currentbalance.toString())),
                                      DataCell(Text('Debit')),
                                    ]);
                                  })),



                    )

                    :
                Center(child: CircularProgressIndicator(),),



              ],
            ),
        ),
      ),
    );
  }
}
