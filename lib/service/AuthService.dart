import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rao_darpan/model/Auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // @override
  Stream<Auth> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
        (User user) {
          Map<String, dynamic> userJson = {
            'userPhoto': user?.photoURL,
            'userName': user?.displayName,
            'userEmail': user?.email,
            'userId': user?.uid
          };
          return Auth.fromJSON(userJson);
        },
      );

  // @override
  Future<Auth> currentUser() async {
    User user = _firebaseAuth.currentUser;
    Map<String, dynamic> userJson = {
      'userPhoto': user.photoURL,
      'userName': user.displayName,
      'userEmail': user.email,
      'userId': user.uid
    };
    return Auth.fromJSON(userJson);
  }

  // @override
  Future<Auth> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _auth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _auth.accessToken,
      idToken: _auth.idToken,
    );
    User user = (await _firebaseAuth.signInWithCredential(credential)).user;
    Map<String, dynamic> userJson = {
      'userPhoto': user.photoURL,
      'userName': user.displayName,
      'userEmail': user.email,
      'userId': user.uid
    };
    return Auth.fromJSON(userJson);
  }

  // @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
