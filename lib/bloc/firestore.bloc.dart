import 'dart:async';
import 'package:chessbotsmobile/models/user.doc.dart';
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
  DocumentReference _userRef;

  // provides its own external-out
  // internal in handled in constructor
  /// user document in firestore
  Observable<UserDoc> userDoc$;

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
    // all things impacted by auth changes (where we get the delicious uid)
    _auth.onAuthStateChanged.listen((u) {
      // send the raw firebase user out our behavior subject
      _internalInUser.add(u);

      if (u == null) {
        _userRef = null;
        userDoc$ = Observable.just(UserDoc()).shareValue();
      } else {
        _userRef = _db.collection('users').document(u.uid);

        // needed otherwise the userdoc will not rebuilt on snap changes
        ValueObservable<DocumentSnapshot> _snaps =
            Observable(_userRef.snapshots()).shareValue();

        userDoc$ =
            _snaps.map((snap) => UserDoc.fromFirestore(snap.data)).shareValue();
      }
    });

    // listen for incoming events from the external-in sink
    _authEventController.stream.listen(_handleAuthEvent);
    _firestoreEventController.stream.listen(_handleFirestoreEvent);
  }
  void _handleAuthEvent(AuthEvent event) async {
    if (event is SignInWithGoogleEvent) {
      // print('sign in event');
      _internalInLoading.add(true);
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      // print('got google user');
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // print('got google auth');
      FirebaseUser _fbUser = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // print('got firebase auth');
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
      // quick sanity check
      if (event.nerdPoints <= 0) {
        return;
      }
      UserDoc _currentUserData = await userDoc$.first;
      int _currentNerdPoints = _currentUserData.nerdPoints ?? 0;
      int _newNerdPoints = _currentNerdPoints += event.nerdPoints;

      await _userRef.updateData({"nerdPoints": _newNerdPoints});
    }
  }

  /// keeps firestore user collection up-to-date with firebase auth data
  /// typically run after sign in
  void _updateUserData(FirebaseUser _fbUser) async {
    return _userRef.setData({
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

  Future<void> spendNerdPoints(int _nerdPointsToBeSpent) async {
    // this is not in the events because the UI is depending on a promise
    // TODO can we somehow launch dialogs from in here?
    // if so, then we could put this in the event queue
    UserDoc _currentUserData = await userDoc$.first;
    int _currentNerdPoints = _currentUserData.nerdPoints ?? 0;
    int _newNerdPoints = _currentNerdPoints - _nerdPointsToBeSpent;
    if (_newNerdPoints < 0) {
      throw ("Not enough nerd points");
    } else {
      await _userRef.updateData({"nerdPoints": _newNerdPoints});
      return;
    }
  }
}
