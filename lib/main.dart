import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:request_tracker/pages/form_page.dart';
import 'package:request_tracker/pages/home.dart';
import 'package:request_tracker/pages/results_page.dart';

import 'controller/form_controller.dart';
import 'models/request_model.dart';
import 'models/data_upload.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(RequestTracker());
}

class RequestTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // textTheme: GoogleFonts.sourceSansProTextTheme().copyWith(
        //     bodyText2: TextStyle(fontSize: 14),
        //     subtitle1: TextStyle(fontSize: 14)),
        // fontFamily: GoogleFonts.sourceSansPro().fontFamily),
      ),
      home: Landing(),
    );
  }
}

class Landing extends StatefulWidget {
  @override
  LandingState createState() => LandingState();
}

class LandingState extends State<Landing> {
  List<Request> data;

  @override
  void initState() {
    super.initState();
    data = conferDates(
      FormController.data.reversed
          .map((e) => Request.fromMap(e))
          .take(120)
          .toList(),
    );
    data.removeAt(0);

    // ctrl.FormController().getFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder:
            (BuildContext buildContext, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(snapshot.error),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {},
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            requests: data,
                          ),
                        ),
                      );
                    },
                    child: Text('Home Page'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormPage()),
                      );
                    },
                    child: Text('Form Page'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResultsPage()),
                      );
                    },
                    child: Text('Results'),
                  ),
                ],
              ),
            );
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}
