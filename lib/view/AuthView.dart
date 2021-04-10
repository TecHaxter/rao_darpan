import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rao_darpan/utils/size_config.dart';
import 'package:rao_darpan/view/HomeView.dart';
import 'package:rao_darpan/viewmodel/MagazineViewModel.dart';
import 'package:rao_darpan/viewmodel/MembershipViewModel.dart';
import '../viewmodel/AuthViewModel.dart';

class AuthView extends StatefulWidget {
  AuthView({Key key}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  @override
  void initState() {
    super.initState();
    // Provider.of<AuthViewModel>(context, listen: false).signIn();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget homeOrLogin(AuthViewModel vm) {
    switch (vm.status) {
      case AuthStatus.Uninitialized:
        return Scaffold(body: Center(child: CircularProgressIndicator()));
        break;
      case AuthStatus.Unauthenticated:
        // return FlatButton(onPressed: () => vm.signIn(), child: Text("Login"));
        return Scaffold(
          body: Center(
            child: Container(
              width: SizeConfig.screenWidth * 0.8,
              height: SizeConfig.screenHeight * 0.3,
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 6.0),
              decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(
                      SizeConfig.blockSizeHorizontal * 6.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // widget.month,
                    "Rao Darpan",
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 8.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black38),
                  ),
                  FlatButton(
                    onPressed: () {
                      vm.signIn();
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(

                        // side: BorderSide,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      // widget.month,
                      "Sign In with Google",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black38),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        break;
      case AuthStatus.Authenticating:
        return Scaffold(body: Center(child: CircularProgressIndicator()));
        break;
      case AuthStatus.Authenticated:
        // return Column(
        //   children: [
        //     FlatButton(onPressed: () => vm.signOut(), child: Text("Logout")),
        //     Text(vm.userAuth.userName != null ? vm.userAuth.userName : 'Wait')
        //   ],
        // );

        // return MultiProvider(
        //   providers: [
        //     Provider<MagazineViewModel>.value(value: MagazineViewModel()),
        //     Provider<MembershipViewModel>.value(value: MembershipViewModel()),
        //   ],
        //   child: HomeView(),
        // );
        // return ChangeNotifierProvider(
        //   create: (_) => MagazineViewModel(),
        //   child: ChangeNotifierProvider(
        //     create: (_) => MembershipViewModel(),
        //     child: MaterialApp(
        //       title: 'Flutter Demo',
        //       theme: ThemeData(
        //         primarySwatch: Colors.blueGrey,
        //         visualDensity: VisualDensity.adaptivePlatformDensity,
        //       ),
        //       // home: ChangeNotifierProvider(
        //       //   create: (_) => AuthViewModel.instance(),
        //       //   child: AuthView(),
        //       // ),
        //       home: HomeView(),
        //     ),
        //   ),
        // );
        return HomeView();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    SizeConfig().init(context);
    return homeOrLogin(authVM);
  }
}
