import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rao_darpan/model/PublishDates.dart';
import 'package:rao_darpan/utils/cardDesign.dart';
import 'package:rao_darpan/utils/moths.dart';
import 'package:rao_darpan/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:rao_darpan/viewmodel/MagazineViewModel.dart';
import 'package:rao_darpan/widget/MagCard.dart';

class MoreYearsView extends StatefulWidget {
  MoreYearsView({Key key, this.refresh, this.isPro}) : super(key: key);
  final bool isPro;
  final Function refresh;
  @override
  _MoreYearsViewState createState() => _MoreYearsViewState();
}

class _MoreYearsViewState extends State<MoreYearsView> {
  int selectedYear;

  Future<int> showYearPicker({
    @required List<PublishDates> years,
    @required BuildContext context,
    Widget title,
    EdgeInsetsGeometry titlePadding,
  }) async {
    assert(context != null);
    return await showDialog(
        context: context,
        builder: (context) => new Dialog(
                child: Container(
              width: SizeConfig.screenWidth * 0.5,
              height: SizeConfig.screenHeight * 0.5,
              alignment: Alignment.center,
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (_, __) => SizedBox(
                  height: SizeConfig.safeBlockVertical * 2,
                ),
                itemCount: years.length,
                itemBuilder: (context, index) => InkWell(
                  child: Text(
                    years[index].year.toString(),
                    textAlign: TextAlign.center,
                    style: selectedYear == years[index].year
                        ? TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig.blockSizeHorizontal * 6.0,
                            letterSpacing: 2.0)
                        : TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: SizeConfig.blockSizeHorizontal * 5.0,
                            letterSpacing: 2.0),
                  ),
                  onTap: () {
                    setState(() {
                      selectedYear = years[index].year;
                    });
                    Navigator.pop(context, selectedYear);
                  },
                ),
              ),
            )));
  }

  @override
  void initState() {
    super.initState();
    selectedYear = context.read<MagazineViewModel>().threeYears.first.year;
    // context.read<MagazineViewModel>().getMagazinesByYear(selectedYear);
    context.read<MagazineViewModel>().loadingStatusMagByYear =
        LoadingStatus.completed;
  }

  @override
  Widget build(BuildContext context) {
    final magazineViewModel = context.read<MagazineViewModel>();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: new Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.black54,
            ),
            onPressed: () {
              widget.refresh();
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              // updateShowPickerDates(magazineViewModel.years);
              await showYearPicker(
                      context: context, years: magazineViewModel.years)
                  .then((value) =>
                      {magazineViewModel.getMagazinesByYear(selectedYear)});
              setState(() {});
            },
            child: Container(
              width: double.maxFinite,
              height: SizeConfig.screenHeight * 0.1,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 1),
                  borderRadius: BorderRadius.circular(
                      SizeConfig.safeBlockHorizontal * 6.0)),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5.0,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Year : ",
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.blockSizeHorizontal * 6.0,
                        letterSpacing: 2.0),
                  ),
                  Row(
                    children: [
                      Text(
                        selectedYear.toString(),
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w900,
                            fontSize: SizeConfig.blockSizeHorizontal * 6.0,
                            letterSpacing: 2.0),
                      ),
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.black54,
                        size: SizeConfig.blockSizeVertical * 4.0,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            height: SizeConfig.screenHeight * 0.75,
            child: _buildPage(context, magazineViewModel),
          )
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context, MagazineViewModel vm) {
    switch (vm.loadingStatusMagByYear) {
      case LoadingStatus.searching:
        return Column(
          children: [
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2.0,
            ),
            shimmerMagCard(),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 4.0,
            ),
            shimmerMagCard(),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 4.0,
            ),
            shimmerMagCard(),
          ],
        );

      case LoadingStatus.empty:
        return Align(child: Center(child: Text("No result found !!")));

      case LoadingStatus.completed:
        List card;
        return ListView.builder(
          itemCount: vm.magazineListCache[selectedYear].length,
          itemBuilder: (context, index) {
            card = index.isEven ? cardDesign[0] : cardDesign[1];
            int publishMonth = vm
                .magazineListCache[selectedYear][index].publishDate
                .toDate()
                .month;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5.0,
                vertical: SizeConfig.blockSizeVertical * 2.0,
              ),
              child: MagCard(
                magazineUrl:
                    vm.magazineListCache[selectedYear][index].magazineUrl,
                month: monthsFullForm[publishMonth - 1],
                card: card,
                isPro: widget.isPro,
              ),
            );
          },
        );
    }
    return SizedBox();
  }
}
