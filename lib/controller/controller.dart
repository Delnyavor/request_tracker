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

  /// Async function which saves feedback, parses [feedbackForm] parameters	  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(
      FeedbackForm feedbackForm, void Function(String) callback) async {
    try {
      await http.post(URL, body: feedbackForm.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];

          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  /// Async function which loads feedback from endpoint URL and returns List.
  Future<List<dynamic>> getFeedbackList() async {
    try {
      var response = await http.get(URL);
      print(response.body);
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => FeedbackForm.fromJson(json)).toList();
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
