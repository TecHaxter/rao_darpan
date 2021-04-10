import 'package:cloud_firestore/cloud_firestore.dart';

class Magazine {
  // final String title;
  // final String description;
  final String magazineUrl;
  final Timestamp publishDate;

  Magazine({this.magazineUrl, this.publishDate});

  factory Magazine.fromJSON(Map<String, dynamic> json) {
    return Magazine(
        // title: json["title"],
        // description: json["description"],
        magazineUrl: json["magazineUrl"],
        publishDate: json["publishDate"]);
  }
}
