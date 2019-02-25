import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './base.bloc.dart';

abstract class AuthEvent {}

class SignInWithGoogleEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class SignInAnonymouslyEvent extends AuthEvent {}

class AuthBloc extends BlocBase {
  // dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  /// external-in/internal-out controller
  StreamController<AuthEvent> _eventController = StreamController();

  /// external-in (alias)
  StreamSink<AuthEvent> get event => _eventController.sink;

  /// internal-in/external-out controller
  StreamController<FirebaseUser> _userController =
      BehaviorSubject<FirebaseUser>();

  /// internal-in (alias)
  StreamSink<FirebaseUser> get _internalIn => _userController.sink;

  /// external-out (alias)
  /// Mostly used to determine if the user is authenticated
  Stream<FirebaseUser> get user => _userController.stream;

  // constructor
  AuthBloc() {
    // connect _auth with _internalIn
    _auth.onAuthStateChanged.listen((_fbUser) {
      _internalIn.add(_fbUser);
    });

    // listen for incoming events from the external-in sink
    // these events will interact with _auth
    _eventController.stream.listen(_handleEvent);
  }
  void _handleEvent(AuthEvent event) async {
    if (event is SignInWithGoogleEvent) {
      print("inside google event");
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      FirebaseUser _fbUser = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      _updateUserData(_fbUser);
    } else if (event is SignOutEvent) {
      _auth.signOut();
    } else if (event is SignInAnonymouslyEvent) {
      FirebaseUser _user = await _auth.signInAnonymously();
      _updateUserData(_user);
    }
  }

  /// keeps firestore user collection up-to-date with firebase auth data
  void _updateUserData(FirebaseUser _fbUser) async {
    DocumentReference ref = _db.collection('users').document(_fbUser.uid);

    return ref.setData({
      'uid': _fbUser.uid,
      'email': _fbUser.email,
      'displayName': _fbUser.displayName ?? "Guest",
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  void dispose() {
    _userController.close();
    _eventController.close();
  }
}
