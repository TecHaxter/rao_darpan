import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rao_darpan/model/Magazine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rao_darpan/model/PublishDates.dart';

class MagazineService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // @override
  Future<List<Magazine>> getMagazinesByYear(int year) async {
    List<dynamic> result;
    result = await firestore
        .collection('Magazines')
        .doc(year.toString())
        .get()
        .then((value) => value.data()['magazines']);
    result = result.map((magazine) => Magazine.fromJSON(magazine)).toList();
    result.sort((a, b) => a.publishDate.compareTo(b.publishDate));
    return result;
  }

  // @override
  // Future<Magazine> getLatestMagazine() async {
  //   print("getLatestMagazine");
  //   List<QueryDocumentSnapshot> result;
  //   result = await firestore
  //       .collection('magazines')
  //       .where('publishDate',
  //           isGreaterThanOrEqualTo: DateTime(DateTime.now().year))
  //       .orderBy('publishDate', descending: true)
  //       .limit(1)
  //       .get()
  //       .then((value) => value.docs);
  //   return Magazine.fromJSON(result.first.data());
  // }

  // @override
  Future<List<PublishDates>> getAllYears() async {
    print("getAllYears");
    List<dynamic> result;
    result = await firestore
        .collection('publishYears')
        .doc('years')
        .get()
        .then((value) => value.data()['years']);
    return result.map((doc) => PublishDates.fromJSON(doc)).toList();
  }

  // @override
  // Future<List<PublishDates>> getThreeYears() async {
  //   print("getThreeYears");
  //   List<QueryDocumentSnapshot> result;
  //   result = await firestore
  //       .collection('publishYears')
  //       .orderBy('year', descending: true)
  //       .limit(3)
  //       .get()
  //       .then((value) => value.docs);
  //   return result.map((doc) => PublishDates.fromJSON(doc.data())).toList();
  // }
}
