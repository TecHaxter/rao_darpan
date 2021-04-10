import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rao_darpan/utils/size_config.dart';
import 'package:rao_darpan/view/MagPdfView.dart';
import 'package:rao_darpan/view/SubscribeView.dart';
import 'package:shimmer/shimmer.dart';

class MagCard extends StatelessWidget {
  const MagCard(
      {Key key,
      this.isPro,
      this.magazineUrl,
      this.month,
      this.card,
      this.refresh})
      : super(key: key);

  final Function refresh;
  final String month;
  final bool isPro;
  final String magazineUrl;
  final List card;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        width: double.maxFinite,
        height: SizeConfig.screenHeight * 0.20,
        decoration: BoxDecoration(
            color: card[0],
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6.0)),
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.blockSizeHorizontal * 6.0,
                      letterSpacing: 2.0),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FlatButton(
                      onPressed: () {
                        if (isPro)
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => MagPdfView(
                                        url: magazineUrl,
                                        // title: widget.title,
                                      ))).then((value) => refresh);
                        else
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => SubscribeView(
                                      // url: widget.magazineUrl,
                                      // title: widget.title,
                                      ))).then((value) => refresh());
                      },
                      child: Text("READ NOW".toUpperCase(),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}

Widget shimmerMagCard() {
  return Shimmer.fromColors(
    child: Container(
      width: double.maxFinite,
      height: SizeConfig.screenHeight * 0.20,
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 6.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6.0)),
    ),
    baseColor: Colors.grey[50],
    highlightColor: Colors.grey[100],
  );
}
