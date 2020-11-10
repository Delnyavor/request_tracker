import 'package:flutter/material.dart';
import 'package:request_tracker/controller/form_controller.dart';
import 'package:request_tracker/models/request_model.dart';

class FeedbackListPage extends StatefulWidget {
  @override
  _FeedbackListPageState createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  // Method to Submit Feedback and save it in Google Sheets

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Data')), body: ListView(children: [table()])
        //  ListView.builder(
        //   reverse: false,
        //   itemCount: feedbackItems.length,
        //   itemBuilder: (context, index) {
        //     feedbackItems[index].index = index;
        //     return ListTile(
        //       title: Row(
        //         children: <Widget>[
        //           Icon(Icons.person),
        //           Expanded(
        //             child: Text(
        //                 "${feedbackItems[index].index} ${feedbackItems[index].name} ${feedbackItems[index].email} ${feedbackItems[index].mobileNo} ${feedbackItems[index].feedback}"),
        //           )
        //         ],
        //       ),
        //     );
        //   },
        // ),
        );
  }

  Widget table() {
    int visibleRows = 20;
    return PaginatedDataTable(
      onRowsPerPageChanged: (rows) {
        setState(() {
          visibleRows = rows;
        });
      },
      rowsPerPage: visibleRows,
      dataRowHeight: 40,
      horizontalMargin: 10,
      source: TableSource(context),
      header: Text('data'),
      columns: [
        DataColumn(label: Text('Date'), numeric: true, onSort: (int, bool) {}),
        DataColumn(
            label: Text('ID Number'), numeric: true, onSort: (int, bool) {}),
        DataColumn(
            label: Text('Requested By'), numeric: true, onSort: (int, bool) {}),
        DataColumn(
            label: Text('Taken By'), numeric: true, onSort: (int, bool) {}),
        DataColumn(
            label: Text('Date Returned'),
            numeric: true,
            onSort: (int, bool) {}),
        DataColumn(
            label: Text('Checked By'), numeric: true, onSort: (int, bool) {}),
      ],
    );
  }
}

class TableSource extends DataTableSource {
  final BuildContext context;
  List<dynamic> data;
  TableSource(this.context) {
    // data = FormController().getFeedbackList();
  }

  @override
  DataRow getRow(int index) {
    var item = data[index];
    item.index = index++;
    return DataRow.byIndex(index: index, selected: item.selected, cells: [
      DataCell(Text('${item.index}')),
      DataCell(Text('${item.name}')),
      DataCell(Text('${item.email}')),
      DataCell(Text('${item.mobileNo}')),
      DataCell(Text('${item.feedback}')),
      DataCell(Text('${item.index}')),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
