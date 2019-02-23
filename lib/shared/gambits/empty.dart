import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';

class EmptyGambit extends Gambit {
  // singleton logic so that MakeRandomMove is only created once
  static final EmptyGambit _singleton = EmptyGambit._internal();
  factory EmptyGambit() => _singleton;

  EmptyGambit._internal()
      : super(
            vector: CustomPaint(), // TODO empty vector?
            title: "Empty",
            color: Colors.white,
            description: "Assign a gambit!",
            altText: "Waste not",
            //TODO find appropriate icon
            icon: Icons.add_circle_outline,
            findMove: FindMove((chess.Chess game) {
              return null;
            }));
}
