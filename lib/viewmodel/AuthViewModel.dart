import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rao_darpan/model/Auth.dart';
import 'package:rao_darpan/service/AuthService.dart';

enum AuthStatus {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated
}

class AuthViewModelData {
  Auth _auth;
  AuthViewModelData({Auth auth}) : _auth = auth;

  String get userPhoto {
    return _auth.userPhoto;
  }

  String get userName {
    return _auth.userName;
  }

  String get userEmail {
    return _auth.userEmail;
  }

  String get userId {
    return _auth.userId;
  }
}

class AuthViewModel extends ChangeNotifier {
  AuthStatus _status = AuthStatus.Uninitialized;
  AuthStatus get status => _status;

  AuthViewModelData _userAuth = AuthViewModelData();
  AuthViewModelData get userAuth => _userAuth;

  FirebaseAuth _firebaseAuth;

  AuthService _authService = AuthService();

  AuthViewModel.instance() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.authStateChanges().listen((user) {
      Auth auth = Auth(
          userName: user?.displayName,
          userPhoto: user?.photoURL,
          userEmail: user?.email,
          userId: user?.uid);
      _onAuthStateChanged(auth);
    });
  }

  Future<bool> signIn() async {
    try {
      _status = AuthStatus.Authenticating;
      notifyListeners();
      Auth auth = await _authService.signInWithGoogle();
      this._userAuth = AuthViewModelData(auth: auth);
      return true;
    } catch (e) {
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _authService.signOut();
    _status = AuthStatus.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  // Future<void> currentUser() async {
  //   Auth auth = await AuthService().currentUser();
  //   this.authVMData = AuthViewModelData(auth: auth);
  //   if (authVMData.userId != null)
  //     this.authenticated = true;
  //   else
  //     this.authenticated = false;
  //   notifyListeners();
  // }

  Future<void> _onAuthStateChanged(Auth auth) async {
    if (auth.userId == null) {
      _status = AuthStatus.Unauthenticated;
    } else {
      await Future.delayed(Duration(seconds: 2), () {
        _userAuth = AuthViewModelData(auth: auth);
        _status = AuthStatus.Authenticated;
      });
    }
    notifyListeners();
  }
}

// User _user;
//   Status _status = Status.Uninitialized;

//   FirebaseAuth _auth;
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   AuthViewModel.instance() : _auth = FirebaseAuth.instance {
//     _auth.authStateChanges().listen(_onAuthStateChanged);
//   }

//   Status get status => _status;
//   User get user => _user;

//   Future<bool> signIn() async {
//     try {
//       _status = Status.Authenticating;
//       notifyListeners();
//       final GoogleSignInAccount account = await _googleSignIn.signIn();
//       final GoogleSignInAuthentication _auth = await account.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: _auth.accessToken,
//         idToken: _auth.idToken,
//       );
//       User user = (await _firebaseAuth.signInWithCredential(credential)).user;
//       print(user.displayName.toString() + '----------------------');
//       return true;
//     } catch (e) {
//       _status = Status.Unauthenticated;
//       notifyListeners();
//       return false;
//     }
//   }

//   Future signOut() async {
//     _auth.signOut();
//     _status = Status.Unauthenticated;
//     notifyListeners();
//     return Future.delayed(Duration.zero);
//   }

//   Future<void> _onAuthStateChanged(User firebaseUser) async {
//     if (firebaseUser == null) {
//       _status = Status.Unauthenticated;
//     } else {
//       _user = firebaseUser;
//       _status = Status.Authenticated;
//     }
//     notifyListeners();
//   }
