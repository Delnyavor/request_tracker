import 'dart:io';

import 'package:request_tracker/models/feedback_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.	/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyjjW-eXXFFbOgISU80vxH7kVi_99WlSst8-O1jv0pzwW8dZbE/exec";

// Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  static const GET_ALL = "get_all";
  static const FIND_ALL_BY_ID = "find_all";
  static const FIND_LAST = "find_last";
  static const MARK_RETURNED = "update";
  static const ADD_NEW = "add_new";

  /// Async function which saves feedback, parses [feedbackForm] parameters	  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(
      FeedbackForm feedbackForm, void Function(String) callback) async {
    try {
      var response = await http.post(URL, body: feedbackForm.toJson());
      if (response.statusCode == 302) {
        var url = response.headers['location'];
        await http.get(url).then((response) {
          callback(convert.jsonDecode(response.body)['status']);
          print(response.body);
        });
      } else {
        callback(convert.jsonDecode(response.body)['status']);
      }
    } on SocketException catch (e) {
      print(e);
    }
  }

  Future<List<FeedbackForm>> getFeedbackList(GetterParams params) async {
    try {
      http.Response response = await http.get(
        URL + '?id=${params.id}&type=${params.type}',
      );

      dynamic jsonFeedback = convert.jsonDecode(response.body);
      print(response.body);

      return jsonFeedback
          .map<FeedbackForm>((json) => FeedbackForm.fromJson(json))
          .toList();
    } on Exception catch (e) {
      print(e.toString());
      return <FeedbackForm>[];
    }
  }

  Future<void> getFeedback() async {
    return await http.get(URL).then((response) {
      print(response.body);
    });
  }
}

// List<FeedbackForm> parseContent(String responseBody) {
//   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

//   return parsed
//       .map<FeedbackForm>((json) => FeedbackForm.fromJson(json))
//       .toList();
// }
