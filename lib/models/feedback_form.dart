/// FeedbackForm is a data class which stores data fields of Feedback.
class FeedbackForm {
  String name;
  String email;
  String mobileNo;
  String feedback;
  String position = '';
  String type = '';
  //TODO: add api call parameters
  //TODO: have different models for the different request types.
  //each model has a function type declaration for the api

  FeedbackForm(this.name, this.email, this.mobileNo, this.feedback,
      [this.position, this.type]);

  factory FeedbackForm.fromJson(dynamic json) {
    return FeedbackForm(
        "${json['name']}",
        "${json['email']}",
        "${json['mobileNo']}",
        "${json['feedback']}",
        "${json['position']}",
        "${json['type']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
        'name': name,
        'email': email,
        'mobileNo': mobileNo,
        'feedback': feedback,
        'position': position,
        'type': type
      };
}

class GetterParams {
  final String id;
  final String type;

  const GetterParams({this.id, this.type});

  Map toJson() => {'id': id, 'type': type};
}
