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

abstract class FirestoreEvent {}

class AwardNerdPointsEvent extends FirestoreEvent {
  final int nerdPoints;
  AwardNerdPointsEvent(this.nerdPoints);
}

class FirestoreBloc extends BlocBase {
  // provides its own external-out
  // internal in handled in constructor
  /// user document in firestore
  Observable<Map<String, dynamic>> userDoc;

  // dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  /// external-in/internal-out controller
  StreamController<AuthEvent> _authEventController = StreamController();
  StreamController<FirestoreEvent> _firestoreEventController =
      StreamController();

  /// external-in (alias)
  StreamSink<AuthEvent> get authEvent => _authEventController.sink;
  StreamSink<FirestoreEvent> get firestoreEvent =>
      _firestoreEventController.sink;

  /// internal-in/external-out controller
  StreamController<FirebaseUser> _userController =
      BehaviorSubject<FirebaseUser>();
  StreamController<bool> _loadingController =
      BehaviorSubject<bool>(seedValue: false);

  /// internal-in (alias)
  StreamSink<FirebaseUser> get _internalInUser => _userController.sink;
  StreamSink<bool> get _internalInLoading => _loadingController.sink;

  /// external-out (alias)
  /// Mostly used to determine if the user is authenticated
  Stream<FirebaseUser> get user => _userController.stream;
  Stream<bool> get loading => _loadingController.stream;

  // constructor
  FirestoreBloc() {
    // setup user stream (behavior subject)
    _auth.onAuthStateChanged.listen((_fbUser) {
      _internalInUser.add(_fbUser);
    });

    // setup userDoc (by listening to user stream)
    userDoc = Observable(user).switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });

    // listen for incoming events from the external-in sink
    // these events will interact with _auth
    _authEventController.stream.listen(_handleAuthEvent);
    _firestoreEventController.stream.listen(_handleFirestoreEvent);
  }
  void _handleAuthEvent(AuthEvent event) async {
    if (event is SignInWithGoogleEvent) {
      print('sign in event');
      _internalInLoading.add(true);
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      print('got google user');
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('got google auth');
      FirebaseUser _fbUser = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('got firebase auth');
      _internalInLoading.add(false);
      _updateUserData(_fbUser);
    } else if (event is SignOutEvent) {
      _auth.signOut();
    } else if (event is SignInAnonymouslyEvent) {
      _internalInLoading.add(true);
      FirebaseUser _user = await _auth.signInAnonymously();
      _internalInLoading.add(false);
      _updateUserData(_user);
    }
  }

  void _handleFirestoreEvent(FirestoreEvent event) async {
    // events are inherently connected to internal-in if they update the proper document reference
    if (event is AwardNerdPointsEvent) {
      Map<String, dynamic> _currentProfile = await userDoc.first;
      int _currentNerdPoints = _currentProfile["nerdPoints"] ?? 0;
      int _newNerdPoints = _currentNerdPoints += event.nerdPoints;

      DocumentReference _ref =
          _db.collection('users').document(_currentProfile["uid"]);
      await _ref.updateData({"nerdPoints": _newNerdPoints});
    }
  }

  /// keeps firestore user collection up-to-date with firebase auth data
  /// typically run after sign in
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
    _authEventController.close();
    _loadingController.close();
    _firestoreEventController.close();
  }
}
