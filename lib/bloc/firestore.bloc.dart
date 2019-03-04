import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './auth.bloc.dart';

abstract class FirestoreEvent {}

class AwardNerdPointsEvent extends FirestoreEvent {
  final int nerdPoints;
  AwardNerdPointsEvent(this.nerdPoints);
}

/// This bloc never needs to be provided
/// it can be instantiated anywhere due to its singleton logic
class FirestoreBloc {
  // singleton logic
  static final FirestoreBloc _singleton = FirestoreBloc._internal();
  factory FirestoreBloc() => _singleton;

  // state
  // provides its own external-out
  // internal in handled in constructor
  Observable<Map<String, dynamic>> userDoc; // user document in firestore

  // dependencies
  final Firestore _db = Firestore.instance;

  /// external-in/internal-out controller
  StreamController<FirestoreEvent> _eventController = StreamController();

  /// external-in (alias)
  StreamSink<FirestoreEvent> get event => _eventController.sink;

  // constructor
  FirestoreBloc._internal() {
    // internal in
    userDoc = Observable(AuthBloc().user).switchMap((FirebaseUser u) {
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
    _eventController.stream.listen(_handleEvent);
  }
  void _handleEvent(FirestoreEvent event) async {
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

  void dispose() {
    _eventController.close();
  }
}
