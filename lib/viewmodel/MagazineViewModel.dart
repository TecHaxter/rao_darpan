import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rao_darpan/model/Magazine.dart';
import 'package:rao_darpan/model/PublishDates.dart';
import 'package:rao_darpan/service/MagazineService.dart';

enum LoadingStatus { completed, searching, empty }

class MagazineModelData {
  Magazine _magazine;
  MagazineModelData({Magazine magazine}) : _magazine = magazine;

  // String get title {
  //   return _magazine.title;
  // }

  // String get description {
  //   return _magazine.description;
  // }

  String get magazineUrl {
    return _magazine.magazineUrl;
  }

  Timestamp get publishDate {
    return _magazine.publishDate;
  }
}

class MagazineViewModel extends ChangeNotifier {
  var loadingStatusMagByYear = LoadingStatus.searching;
  var loadingStatusLatMag = LoadingStatus.searching;
  var loadingStatusAllYears = LoadingStatus.searching;
  var loadingStatusThreeYears = LoadingStatus.searching;

  List<PublishDates> years = [];
  List<PublishDates> threeYears = [];
  // List<MagazineModelData> magazineList = List<MagazineModelData>();
  MagazineModelData magazine = MagazineModelData();
  // HashMap<int, MagazineModelData> latestMagCache = HashMap();
  HashMap<int, List<MagazineModelData>> magazineListCache = HashMap();

  Future<void> getMagazinesByYear(int year) async {
    this.loadingStatusMagByYear = LoadingStatus.searching;
    if (!magazineListCache.containsKey(year)) {
      final results = await MagazineService().getMagazinesByYear(year);
      List<MagazineModelData> magazineList = results
          .map((magazine) => MagazineModelData(magazine: magazine))
          .toList();
      this.magazineListCache[year] = magazineList;
      print(this.magazineListCache[year].length);
    }
    this.loadingStatusMagByYear = !this.magazineListCache.containsKey(year)
        ? LoadingStatus.empty
        : this.magazineListCache[year].length == 0
            ? LoadingStatus.empty
            : LoadingStatus.completed;
    print(loadingStatusMagByYear);
    notifyListeners();
  }

  Future<void> getLatestMagazine() async {
    this.loadingStatusLatMag = LoadingStatus.searching;
    this.magazine = this.magazineListCache[this.threeYears.first.year].last;
    this.loadingStatusLatMag =
        this.magazine == null ? LoadingStatus.empty : LoadingStatus.completed;
    notifyListeners();
  }

  Future<void> getAllYears() async {
    this.loadingStatusAllYears = LoadingStatus.searching;
    this.loadingStatusThreeYears = LoadingStatus.searching;
    if (years.isEmpty) {
      final results = await MagazineService().getAllYears();
      this.years = results.map((publishDate) => publishDate).toList();
      this.threeYears = this.years.sublist(0, 2);
    }
    this.loadingStatusAllYears =
        this.years.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
    this.loadingStatusThreeYears =
        this.threeYears.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
    notifyListeners();
  }

  // Future<void> getThreeYears() async {
  //   this.loadingStatusThreeYears = LoadingStatus.searching;
  //   if (years.isEmpty) await getAllYears();
  //   this.threeYears = this.years.sublist(0, 1);
  //   this.loadingStatusThreeYears =
  //       this.threeYears.isEmpty ? LoadingStatus.empty : LoadingStatus.completed;
  //   notifyListeners();
  // }
}
