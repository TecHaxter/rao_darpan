import 'package:purchases_flutter/object_wrappers.dart';
import 'package:rao_darpan/model/Magazine.dart';

class Membership {
  final bool isPro;
  final String purchaseDate;
  final String expirationDate;
  Membership({this.isPro, this.purchaseDate, this.expirationDate});
  factory Membership.fromData(EntitlementInfo entitlementInfo) {
    return Membership(
        isPro: entitlementInfo.isActive,
        purchaseDate: entitlementInfo.latestPurchaseDate,
        expirationDate: entitlementInfo.expirationDate);
  }
}
