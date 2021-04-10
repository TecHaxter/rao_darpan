import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:rao_darpan/model/Membership.dart';
import 'package:rao_darpan/service/MembershipService.dart';

class MembershipModelData {
  Membership _membership;
  MembershipModelData({Membership membership}) : _membership = membership;

  bool get isPro {
    return _membership.isPro;
  }

  String get purchaseDate {
    return _membership.purchaseDate;
  }

  String get expirationDate {
    return _membership.expirationDate;
  }
}

class MembershipViewModel extends ChangeNotifier {
  MembershipModelData membershipModelData = MembershipModelData();
  Offering product;
  MembershipService _membershipService = MembershipService();

  Future<void> initPlatformState(String userID) async {
    await _membershipService.initPlatformState(userID);
  }

  Future<void> subscriptionStatus() async {
    this.membershipModelData = MembershipModelData(
        membership: await _membershipService.subscriptionStatus());
    notifyListeners();
  }

  Future<void> availableProducts() async {
    this.product = await _membershipService.availableProducts();
    notifyListeners();
  }

  Future<void> makePurchase(Package package) async {
    this.membershipModelData = MembershipModelData(
        membership: await _membershipService.makePurchase(package));
    // notifyListeners();
    subscriptionStatus();
  }
}
