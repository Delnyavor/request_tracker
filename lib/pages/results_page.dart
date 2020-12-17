import 'package:flutter/material.dart';
import 'package:request_tracker/controller/controller.dart';
import 'package:request_tracker/models/feedback_form.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<FeedbackForm> feedbackItems = <FeedbackForm>[];

  // Method to Submit Feedback and save it in Google Sheets

  @override
  void initState() {
    super.initState();

    FormController()
        .getFeedbackList(
            GetterParams(id: 'shsy', type: FormController.FIND_ALL_BY_ID))
        .then((feedbackItems) {
      feedbackItems.removeAt(0);
      setState(() {
        this.feedbackItems = feedbackItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: feedbackItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.person),
                Expanded(
                  child: Text(
                      "${feedbackItems[index].name} (${feedbackItems[index].email}), ${feedbackItems[index].mobileNo}"),
                )
              ],
            ),
            subtitle: Row(
              children: <Widget>[
                Icon(Icons.message),
                Expanded(
                  child: Text(feedbackItems[index].feedback),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
