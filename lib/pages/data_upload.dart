import 'package:request_tracker/models/request_model.dart';

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
