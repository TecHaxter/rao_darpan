import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rao_darpan/model/Membership.dart';

class MembershipService {
  Membership membership;

  Future<void> initPlatformState(String userID) async {
    print(userID);
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(
        ////RevenuCat API Key/////
        ,appUserId: userID);
  }

  Future<Offering> availableProducts() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.current;
      }
      return null;
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  }

  Future<Membership> makePurchase(Package package) async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
      EntitlementInfo entitlementInfo =
          purchaserInfo.entitlements.all["all_features"];
      return Membership.fromData(entitlementInfo);
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        print(e);
      }
      return null;
    }
  }

  Future<Membership> subscriptionStatus() async {
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      if (purchaserInfo.entitlements.all["all_features"] != null) {
        EntitlementInfo entitlementInfo =
            purchaserInfo.entitlements.all["all_features"];
        return Membership.fromData(entitlementInfo);
      } else
        return Membership(isPro: false);
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  }
}
