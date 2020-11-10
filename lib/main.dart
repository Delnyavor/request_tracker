import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:request_tracker/pages/data_upload.dart';
import 'package:request_tracker/pages/home.dart';

import 'controller/form_controller.dart';
import 'models/request_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: MyHomePage(title: 'Flutter Google Sheet Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              child: FlatButton(
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
                child: Text('Click'),
              ),
            );
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}
