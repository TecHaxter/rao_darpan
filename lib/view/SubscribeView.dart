import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rao_darpan/utils/size_config.dart';
import 'package:rao_darpan/viewmodel/MembershipViewModel.dart';

class SubscribeView extends StatefulWidget {
  SubscribeView({Key key}) : super(key: key);

  @override
  _SubscribeViewState createState() => _SubscribeViewState();
}

class _SubscribeViewState extends State<SubscribeView> {
  @override
  void initState() {
    super.initState();
    context.read<MembershipViewModel>().availableProducts();
    context.read<MembershipViewModel>().subscriptionStatus();
  }

  @override
  Widget build(BuildContext context) {
    final membershipVM = Provider.of<MembershipViewModel>(context);
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: new Icon(
              FontAwesomeIcons.times,
              color: Colors.black54,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
            width: SizeConfig.screenWidth * 0.8,
            height: SizeConfig.screenHeight * 0.4,
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 6.0),
            decoration: BoxDecoration(
                color: membershipVM.membershipModelData.isPro
                    ? Colors.green[50]
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(
                    SizeConfig.blockSizeHorizontal * 6.0)),
            child: membershipVM.membershipModelData.isPro
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        // widget.month,
                        "Purchase Date : " +
                            membershipVM.membershipModelData.purchaseDate
                                .split("T")[0]
                                .toString(),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.blockSizeHorizontal * 6.0,
                            letterSpacing: 2.0),
                      ),
                      Text(
                        // widget.month,
                        "Expiration Date : " +
                            membershipVM.membershipModelData.expirationDate
                                .split("T")[0]
                                .toString(),
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.blockSizeHorizontal * 6.0,
                            letterSpacing: 2.0),
                      ),
                    ],
                  )
                : membershipVM.product != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            // widget.month,
                            membershipVM.product.monthly.product.title,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeConfig.blockSizeHorizontal * 6.0,
                                letterSpacing: 2.0),
                          ),
                          Text(
                            // widget.month,
                            membershipVM.product.monthly.product.priceString +
                                "/month",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w400,
                                fontSize: SizeConfig.blockSizeHorizontal * 6.0,
                                letterSpacing: 2.0),
                          ),
                          FlatButton(
                            onPressed: () {
                              membershipVM
                                  .makePurchase(membershipVM.product.monthly);
                            },
                            color: Colors.white,
                            shape: RoundedRectangleBorder(

                                // side: BorderSide,
                                borderRadius: BorderRadius.circular(8.0)),
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.blockSizeHorizontal * 6.0,
                                vertical: SizeConfig.blockSizeVertical * 2.0),
                            child: Text(
                              // widget.month,
                              "Subscribe",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                  fontSize:
                                      SizeConfig.blockSizeHorizontal * 6.0,
                                  letterSpacing: 2.0),
                            ),
                          )
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )),
      ),
    );
  }
}
