import 'dart:async';
import 'package:chessbotsmobile/models/chess_bot.dart';
import 'package:chessbotsmobile/models/gambit.dart';
import 'package:chessbotsmobile/models/user.doc.dart';
import 'package:chessbotsmobile/shared/gambits.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './base.bloc.dart';

abstract class AuthEvent {}

class SignInWithGoogleEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class SignInAnonymouslyEvent extends AuthEvent {}

abstract class UserEvent {
  const UserEvent();
}

class AwardNerdPointsEvent extends UserEvent {
  final int nerdPoints;
  const AwardNerdPointsEvent(this.nerdPoints);
}

class RemoveBotRef extends UserEvent {
  final DocumentReference botDocRef;
  const RemoveBotRef(this.botDocRef);
}

//TODO rename to user/auth bloc
/// Singleton used for all things firebase
///
/// E.g. authentication, firestore CRUD etc
class FirestoreBloc extends BlocBase {
  static final FirestoreBloc _singleton = FirestoreBloc._internal();

  factory FirestoreBloc() {
    return _singleton;
  }

  DocumentReference _userRef;

  // dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  /// external-in/internal-out controller
  StreamController<AuthEvent> _authEventController = StreamController();
  StreamController<UserEvent> _firestoreEventController = StreamController();

  /// external-in (alias)
  StreamSink<AuthEvent> get authEvent => _authEventController.sink;
  StreamSink<UserEvent> get userEvent => _firestoreEventController.sink;

  /// internal-in/external-out controller
  StreamController<UserDoc> _userDocController = BehaviorSubject<UserDoc>();
  StreamController<FirebaseUser> _userController =
      BehaviorSubject<FirebaseUser>();
  StreamController<bool> _loadingController =
      BehaviorSubject<bool>(seedValue: false);

  /// internal-in (alias)
  StreamSink<UserDoc> get _internalInUserDoc => _userDocController.sink;
  StreamSink<FirebaseUser> get _internalInUser => _userController.sink;
  StreamSink<bool> get _internalInLoading => _loadingController.sink;

  /// external-out (alias)
  /// Mostly used to determine if the user is authenticated
  Stream<UserDoc> get userDoc$ => _userDocController.stream;
  Stream<FirebaseUser> get user => _userController.stream;
  Stream<bool> get loading => _loadingController.stream;

  // constructor
  FirestoreBloc._internal() {
    // all things impacted by auth changes (where we get the delicious uid)
    _auth.onAuthStateChanged.listen((u) {
      // send the raw firebase user out our behavior subject
      _internalInUser.add(u);

      if (u == null) {
        _userRef = null;
      } else {
        _userRef = _db.collection('users').document(u.uid);

        _userRef.snapshots().listen((snap) {
          UserDoc _doc = UserDoc.fromFirestore(snap.data);
          _internalInUserDoc.add(_doc);
        });
      }
    });

    // listen for incoming events from the external-in sink
    _authEventController.stream.listen(_handleAuthEvent);
    _firestoreEventController.stream.listen(_handleUserEvent);
  }
  void _handleAuthEvent(AuthEvent event) async {
    if (event is SignInWithGoogleEvent) {
      _internalInLoading.add(true);
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential _authCredentail = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      FirebaseUser _fbUser = await _auth.signInWithCredential(_authCredentail);
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

  void _handleUserEvent(UserEvent event) async {
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
    } else if (event is RemoveBotRef) {
      _userRef.updateData({
        "bots": FieldValue.arrayRemove([event.botDocRef])
      });
    }
  }

  /// keeps firestore user collection up-to-date with firebase auth data
  /// typically run after sign in
  void _updateUserData(FirebaseUser _fbUser) async {
    return _userRef.setData({
      'uid': _fbUser.uid,
      'email': _fbUser.email,
      'displayName': _fbUser.displayName ?? "Guest",
      // 'lastSeen': DateTime.now()
    }, merge: true);
  }

  void dispose() {
    _userDocController.close();
    _userController.close();
    _authEventController.close();
    _loadingController.close();
    _firestoreEventController.close();
  }

  // public methods that the UI depends on

  Future<void> attemptToSpendNerdPoints(int _nerdPointsToBeSpent) async {
    // this is not in the events because the UI is depending on a promise
    // if so, then we could put this in the event queue
    UserDoc _currentUserData = await userDoc$.first;
    int _currentNerdPoints = _currentUserData.nerdPoints ?? 0;
    int _newNerdPoints = _currentNerdPoints - _nerdPointsToBeSpent;
    if (_newNerdPoints < 0) {
      int _abs = _newNerdPoints.abs();
      throw ("You are short $_abs nerd points");
    } else {
      return _userRef.updateData({"nerdPoints": _newNerdPoints});
    }
  }

  Future<void> attemptToBuyGambit(Gambit _gambit) async {
    //sanity check
    UserDoc _currentUserData = await userDoc$.first;
    if (_currentUserData.ownedGambits.contains(_gambit.title)) {
      throw ("You already own' ${_gambit.title}'");
    }

    await attemptToSpendNerdPoints(_gambit.cost);
    _userRef.updateData({
      "ownedGambits": FieldValue.arrayUnion([_gambit.title])
    });
  }

  Future<void> createBotDoc(String name) async {
    final _fbUser = await user.first;
    ChessBot _newBotDocObject = ChessBot(
      name: name,
      uid: _fbUser.uid,
      gambits: [EmptyGambit()],
      kills: 0,
      status: "ready",
    );

    // create document
    final DocumentReference _newBotDocRef = _db.collection('bots').document();
    // set the data in the doc
    await _newBotDocRef.setData(_newBotDocObject.serialize());
    // save a reference to the doc to the user
    return _userRef.updateData({
      "bots": FieldValue.arrayUnion([_newBotDocRef])
    });
  }
}
