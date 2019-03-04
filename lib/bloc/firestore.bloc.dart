import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './base.bloc.dart';

abstract class FirestoreEvent {}

class AwardNerdPointsEvent extends FirestoreEvent {
  final int nerdPoints;
  AwardNerdPointsEvent(this.nerdPoints);
}

class FirestoreBloc extends BlocBase {
  Observable<Map<String, dynamic>> userDoc; // user document in firestore

  // dependencies
  final Firestore _db = Firestore.instance;

  /// external-in/internal-out controller
  StreamController<FirestoreEvent> _eventController = StreamController();

  /// external-in (alias)
  StreamSink<FirestoreEvent> get event => _eventController.sink;

  /// internal-in/external-out controller
  // StreamController<FirebaseUser> _userController =
  //     BehaviorSubject<FirebaseUser>();
  // StreamController<bool> _loadingController =
  //     BehaviorSubject<bool>(seedValue: false);

  /// internal-in (alias)
  // StreamSink<FirebaseUser> get _internalInUser => _userController.sink;
  // StreamSink<bool> get _internalInLoading => _loadingController.sink;

  /// external-out (alias)
  /// Mostly used to determine if the user is authenticated
  // Stream<FirebaseUser> get user => _userController.stream;
  // Stream<bool> get loading => _loadingController.stream;

  // constructor
  FirestoreBloc() {
    userDoc = Observable(FirebaseAuth.instance.onAuthStateChanged)
        .switchMap((FirebaseUser u) {
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
    _eventController.stream.listen(_handleEvent);
  }
  void _handleEvent(FirestoreEvent event) async {
    if (event is AwardNerdPointsEvent) {
      // print('awarding nerd points');
      // DocumentReference _ref = _db.collection('users').document(_fbUser.uid);
      // current = await _ref.get();
      Map<String, dynamic> _currentProfile = await userDoc.first;
      int _currentNerdPoints = _currentProfile["nerdPoints"] ?? 0;
      int _newNerdPoints = _currentNerdPoints += event.nerdPoints;

      DocumentReference _ref =
          _db.collection('users').document(_currentProfile["uid"]);
      return _ref.updateData({"nerdPoints": _newNerdPoints});
    }
  }

  void dispose() {
    // _userController.close();
    _eventController.close();
    // _loadingController.close();
  }
}
