import 'package:flutter/material.dart';
import 'package:rao_darpan/utils/size_config.dart';
import 'package:rao_darpan/view/SubscribeView.dart';
import 'package:rao_darpan/viewmodel/MagazineViewModel.dart';

class LatestMagazine extends StatelessWidget {
  const LatestMagazine({Key key, this.magazineViewModel, this.month})
      : super(key: key);
  final MagazineViewModel magazineViewModel;
  final String month;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubscribeView()),
        );
      },
      child: Container(
          width: double.maxFinite,
          height: SizeConfig.screenHeight * 0.20,
          decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius:
                  BorderRadius.circular(SizeConfig.blockSizeHorizontal * 6.0)),
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4.0),
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
                      // Container(
                      //   width: SizeConfig.screenWidth * 0.7,
                      //   // color: Colors.blue,
                      //   child: Text(
                      //     magazineViewModel.magazine.title,
                      //     overflow: TextOverflow.ellipsis,
                      //     textAlign: TextAlign.right,
                      //     style: TextStyle(
                      //         color: Colors.black54,
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: SizeConfig.blockSizeHorizontal * 12.0,
                      //         letterSpacing: 2.0),
                      //   ),
                      // ),
                      Text("READ NOW".toUpperCase(),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16.0,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  )
                ],
              ),
            ],
          )),
    );
  }
}
