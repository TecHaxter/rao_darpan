import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rao_darpan/utils/cardDesign.dart';
import 'package:rao_darpan/utils/moths.dart';
import 'package:rao_darpan/utils/size_config.dart';
import 'package:rao_darpan/view/DashboardView.dart';
import 'package:rao_darpan/view/MoreYearsView.dart';
import 'package:rao_darpan/viewmodel/AuthViewModel.dart';
import 'package:rao_darpan/viewmodel/MagazineViewModel.dart';
import 'package:rao_darpan/viewmodel/MembershipViewModel.dart';
import 'package:rao_darpan/widget/MagCard.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _pageIndex = 0;
  bool _isPro;

  final _pageViewController =
      PageController(initialPage: 0, viewportFraction: 1.1);

  @override
  void initState() {
    super.initState();
    context.read<MagazineViewModel>().getAllYears().whenComplete(() {
      context
          .read<MagazineViewModel>()
          .getMagazinesByYear(
              context.read<MagazineViewModel>().threeYears.first.year)
          .whenComplete(
              () => {context.read<MagazineViewModel>().getLatestMagazine()});
    });
    context
        .read<MembershipViewModel>()
        .initPlatformState(context.read<AuthViewModel>().userAuth.userId)
        .then((value) => context
                .read<MembershipViewModel>()
                .subscriptionStatus()
                .whenComplete(() {
              setState(() {
                _isPro = context
                    .read<MembershipViewModel>()
                    .membershipModelData
                    .isPro;
              });
            }));
  }

  void refreshMagazines() {
    context.read<MagazineViewModel>().getMagazinesByYear(
        context.read<MagazineViewModel>().threeYears.first.year);
    setState(() {
      this._pageIndex = 0;
    });
  }

  void refreshMembership() {
    context.read<MembershipViewModel>().subscriptionStatus();
    if (context.read<MembershipViewModel>().membershipModelData.isPro)
      setState(() {
        this._isPro = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final magazineVM = Provider.of<MagazineViewModel>(context);
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardView()),
              );
            },
            child: Row(
              children: [
                Center(
                  child: Text(
                    "Hello " + authVM.userAuth.userName.split(' ').first,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black54),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 3.0,
                ),
                CircleAvatar(
                  maxRadius: SizeConfig.blockSizeHorizontal * 4.0,
                  // onBackgroundImageError: ,
                  backgroundImage: NetworkImage(authVM.userAuth.userPhoto),
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                  child: authVM.userAuth.userPhoto.isEmpty
                      ? Text(authVM.userAuth.userName[0],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ))
                      : SizedBox(),
                ),
              ],
            ),
          ),
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 5.0,
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   width: double.maxFinite,
              //   // height: SizeConfig.screenHeight * 0.57,
              //   child: _buildLatestMag(context, magazineViewModel),
              // ),
              // SizedBox(
              //   width: 200.0,
              //   height: 100.0,
              //   child: Shimmer.fromColors(
              //     baseColor: Colors.red,
              //     highlightColor: Colors.yellow,
              //     child: Text(
              //       'Shimmer',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         fontSize: 40.0,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              Text(
                "Latest",
                style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w900,
                    fontSize: 18),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 2),
              _buildLatestMag(context, magazineVM),
              Container(
                  width: double.maxFinite,
                  height: SizeConfig.blockSizeVertical * 5.0,
                  margin:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: SizeConfig.screenWidth * 0.6,
                          height: SizeConfig.blockSizeVertical * 5.0,
                          child: magazineVM.threeYears != null
                              ? ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: magazineVM.threeYears.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          scrollTags(
                                              magazineVM.threeYears[index].year,
                                              index,
                                              magazineVM))
                              : SizedBox()),
                      InkWell(
                        onTap: () => {
                          if (_isPro != null)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MoreYearsView(
                                      refresh: refreshMagazines,
                                      isPro: _isPro)),
                            ),
                        },
                        child: SizedBox(
                          height: SizeConfig.blockSizeVertical * 5.0,
                          child: Text("More".toUpperCase(),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16.0,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                    ],
                  )),
              Container(
                  width: double.maxFinite,
                  height: SizeConfig.screenHeight * 0.54,
                  child: magazineVM.loadingStatusThreeYears ==
                          LoadingStatus.completed
                      ? PageView.builder(
                          controller: _pageViewController,
                          itemCount: magazineVM.threeYears.length,
                          onPageChanged: (index) {
                            magazineVM.getMagazinesByYear(
                                magazineVM.threeYears[index].year);
                            setState(() => _pageIndex = index);
                          },
                          itemBuilder: (context, index) =>
                              _buildPage(context, magazineVM))
                      : Column(
                          children: [
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 2.0,
                            ),
                            shimmerMagCard(),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 4.0,
                            ),
                            shimmerMagCard(),
                          ],
                        ))
            ],
          )),
    );
  }

  Widget _buildPage(BuildContext context, MagazineViewModel vm) {
    switch (vm.loadingStatusMagByYear) {
      case LoadingStatus.searching:
        return Column(
          children: [
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
        return page(vm);
    }
  }

  Widget _buildLatestMag(BuildContext context, MagazineViewModel vm) {
    switch (vm.loadingStatusLatMag) {
      case LoadingStatus.searching:
        return shimmerMagCard();

      case LoadingStatus.empty:
        return Align(child: Center(child: Text("No result found !!")));

      case LoadingStatus.completed:
        int publishMonth = vm.magazine.publishDate.toDate().month;
        return MagCard(
          magazineUrl: vm.magazine.magazineUrl,
          month: monthsFullForm[publishMonth - 1],
          card: cardDesign[0],
          isPro: _isPro == null ? false : _isPro,
          refresh: refreshMembership,
        );
    }
  }

  Widget page(MagazineViewModel vm) {
    List card;
    return ListView.builder(
      itemCount: vm.magazineListCache[vm.threeYears[_pageIndex].year].length,
      itemBuilder: (context, index) {
        card = index.isEven ? cardDesign[1] : cardDesign[0];
        int publishMonth = vm
            .magazineListCache[vm.threeYears[_pageIndex].year][index]
            .publishDate
            .toDate()
            .month;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 5.0,
            vertical: SizeConfig.blockSizeVertical * 2.0,
          ),
          child: MagCard(
            // title: vm.magazineList[index].title,
            // description: vm.magazineList[index].description,
            magazineUrl: vm
                .magazineListCache[vm.threeYears[_pageIndex].year][index]
                .magazineUrl,
            month: monthsFullForm[publishMonth - 1],
            card: card,
            isPro: _isPro == null ? false : _isPro,
            refresh: refreshMembership,
          ),
        );
      },
    );
  }

  Widget scrollTags(int tag, int index, MagazineViewModel vm) {
    return InkWell(
      onTap: () {
        setState(() {
          _pageIndex = index;
          _pageViewController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          vm.getMagazinesByYear(DateTime.now().year - index);
        });
      },
      child: Container(
          margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 12.0),
          height: 60,
          child: Column(
            children: [
              Text(
                tag.toString(),
                style: TextStyle(
                    color:
                        index == _pageIndex ? Colors.black54 : Colors.black54,
                    fontWeight: index == _pageIndex
                        ? FontWeight.w900
                        : FontWeight.normal,
                    fontSize: 18),
              ),
              index == _pageIndex
                  ? Icon(
                      FontAwesomeIcons.solidCircle,
                      color: Colors.black54,
                      size: 10,
                    )
                  : SizedBox()
            ],
          )),
    );
  }
}
