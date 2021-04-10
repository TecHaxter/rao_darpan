// import 'package:cloud_firestore/cloud_firestore.dart';

class PublishDates {
  final int year;

  PublishDates({this.year});

  factory PublishDates.fromJSON(int json) {
    return PublishDates(year: json);
  }
}
