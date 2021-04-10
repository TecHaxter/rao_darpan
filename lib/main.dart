import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rao_darpan/view/AuthView.dart';
import 'package:rao_darpan/viewmodel/AuthViewModel.dart';
import 'package:rao_darpan/viewmodel/MagazineViewModel.dart';
import 'package:rao_darpan/viewmodel/MembershipViewModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthViewModel.instance(),
        child: ChangeNotifierProvider(
          create: (_) => MembershipViewModel(),
          child: ChangeNotifierProvider(
            create: (_) => MagazineViewModel(),
            child: MaterialApp(
              title: 'Rao Darpan',
              theme: ThemeData(
                primarySwatch: Colors.green,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: AuthView(),
            ),
          ),
        ));
  }
}
