import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rao_darpan/model/PublishDates.dart';
import 'package:rao_darpan/utils/size_config.dart';
import 'package:rao_darpan/view/MoreYearsView.dart';
import 'package:rao_darpan/view/SubscribeView.dart';
import 'package:rao_darpan/viewmodel/AuthViewModel.dart';

class DashboardView extends StatelessWidget {
  DashboardView({
    Key key,
  }) : super(key: key);

  final List<List<dynamic>> cardDesign = [
    [Colors.blueGrey[50], Colors.blueGrey[200], true],
    [Colors.grey[200], Colors.grey[50], false],
    // [Colors.purple[50], Colors.purple[200], false],
    // [Colors.brown[50], Colors.brown[200], true],
    // [Colors.blue[50], Colors.blue[200], true],
    // [Colors.lime[50], Colors.lime[200], true],
    // [Colors.pink[50], Colors.pink[200], false],
    // [Colors.deepPurple[50], Colors.deepPurple[200], false],
    // [Colors.teal[50], Colors.teal[200], false],
    // [Colors.cyan[50], Colors.cyan[200], false],
    // [Colors.indigo[50], Colors.indigo[200], false],
    // [Colors.grey[50], Colors.grey[200], false],
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final authVM = Provider.of<AuthViewModel>(context);
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
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 5.0,
          right: SizeConfig.blockSizeHorizontal * 5.0,
        ),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              accountName: Text(
                authVM.userAuth.userName,
                style: TextStyle(color: Colors.black54),
              ),
              accountEmail: Text(
                authVM.userAuth.userEmail,
                style: TextStyle(color: Colors.black54),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(authVM.userAuth.userPhoto),
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.grey
                        : Colors.black54,
                child: authVM.userAuth.userPhoto.isEmpty
                    ? Text(
                        authVM.userAuth.userName[0],
                        style: TextStyle(fontSize: 40.0, color: Colors.white),
                      )
                    : SizedBox(),
              ),
            ),
            ListTile(
              title: Text("Subscription"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => SubscribeView(
                            // url: widget.magazineUrl,
                            // title: widget.title,
                            )));
              },
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                authVM.signOut();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
