import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:request_tracker/models/request_model.dart';

class SubmissionPage extends StatefulWidget {
  final List<Request> requests;

  const SubmissionPage({Key key, this.requests}) : super(key: key);

  @override
  _SubmissionPageState createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage>
    with TickerProviderStateMixin {
  CollectionReference reference =
      FirebaseFirestore.instance.collection('requests');
  List<Request> requests = <Request>[];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  void submitToDb() async {
    print('starting');
    DataPack pack = DataPack(reference: reference, requests: requests);
    int result = await compute<DataPack, int>(writeData, pack);
    print("$result");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: RaisedButton(
            child: Text('submit'),
            onPressed: () {
              submitToDb();
            },
          ),
        ));
  }
}

conferDates(List<Request> requests) {
  String date = "";
  int index = 1;
  requests.removeAt(0);
  requests.forEach((request) {
    if (request.takenOn.isEmpty || request.takenOn == "*")
      request.takenOn = date;
    else
      date = request.takenOn;
    request.documentId = index.toString();
    index++;
  });
  return requests;
}

class DataPack {
  final List<Request> requests;
  final CollectionReference reference;

  const DataPack({this.reference, this.requests});
}

int writeData(DataPack pack) {
  try {
    // pack.requests
    //     .forEach((request) async => await pack.reference.add(request.toJson()));
    return 1;
  } catch (e) {
    return 0;
  }
}
