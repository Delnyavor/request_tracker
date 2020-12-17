import 'package:flutter/material.dart';
import 'package:request_tracker/controller/controller.dart';
import 'package:request_tracker/models/feedback_form.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  FormController formController = FormController();

  bool sending = false;
  bool sent = false;

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      setState(() {
        sending = true;
      });
      //TODO header frozen, index++
      FeedbackForm feedbackForm = FeedbackForm(
          nameController.text,
          emailController.text,
          mobileNoController.text,
          feedbackController.text,
          '5',
          FormController.MARK_RETURNED);

      showSnackbar("Submitting Feedback");

      formController.submitForm(feedbackForm, (String response) {
        print("Response: $response");
        if (response == FormController.STATUS_SUCCESS) {
          showSnackbar("Feedback Submitted");
          setState(() {
            sending = false;
            sent = true;
          });
          Future.delayed(Duration(milliseconds: 400), () {
            setState(() {
              sent = false;
            });
          });
        } else {
          showSnackbar("Error Occurred!");
          sending = false;
          sent = false;
        }
      });
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Form'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Valid Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextFormField(
                      controller: emailController,
                      // validator: (value) {
                      //   if (!value.contains("@")) {
                      //     return 'Enter Valid Email';
                      //   }
                      //   return null;
                      // },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: mobileNoController,
                      validator: (value) {
                        if (value.contains(' ')) {
                          return 'Numbers shouldn\'t contain spaces';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                      ),
                    ),
                    TextFormField(
                      controller: feedbackController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Valid Feedback';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(labelText: 'Feedback'),
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: _submitForm,
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
