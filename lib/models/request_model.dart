import 'package:cloud_firestore/cloud_firestore.dart';

/// FeedbackForm is a data class which stores data fields of Feedback.

class Request {
  final DocumentReference reference;
  String documentId;
  String id, requestedBy, takenBy, checkedBy, takenOn, returnedOn;

  Request(this.id, this.requestedBy, this.takenBy, this.checkedBy, this.takenOn,
      this.returnedOn,
      {this.documentId, this.reference});

  Request.fromMap(Map<String, dynamic> map, {this.reference, this.documentId})
      : id = map['index'].toString(),
        requestedBy = map['requestedBy'] ?? '',
        takenBy = map['takenBy'] ?? '',
        checkedBy = map['checkedBy'] ?? '',
        takenOn = map['takenOn'] ?? '',
        returnedOn = map['returnedOn'] ?? '';

  Request.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(),
            reference: snapshot.reference, documentId: snapshot.id);

  // Method to make GET parameters.
  Map<String, dynamic> toJson() => {
        'id': id,
        'requestedBy': requestedBy,
        'takenBy': takenBy,
        'checkedBy': checkedBy,
        "takenOn": takenOn,
        "returnedOn": returnedOn,
      };
}
