import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/gambit.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

class EmptyGambit extends Gambit {
  // singleton logic so that MakeRandomMove is only created once
  static final EmptyGambit _singleton = EmptyGambit._internal();
  factory EmptyGambit() => _singleton;

  EmptyGambit._internal()
      : super(
            vector: CustomPaint(),
            title: "Empty",
            color: Colors.white,
            description: "Assign a gambit!",
            altText: "Waste not",
            icon: FontAwesomeIcons.square,
            findMove: FindMove((chess.Chess game) {
              return null;
            }));
}
