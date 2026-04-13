import 'package:flutter/material.dart';

class BallColor {
  final Color main;
  final Color glow;
  final Color highlight;
  final Color shadow;
  final String name;

  const BallColor({
    required this.main,
    required this.glow,
    required this.highlight,
    required this.shadow,
    required this.name,
  });
}

const List<BallColor> kBallColors = [
  BallColor(
    name: 'Red',
    main: Color(0xFFFF3B30),
    glow: Color(0x70FF3B30),
    highlight: Color(0xFFFF8F8A),
    shadow: Color(0xFF6A0000),
  ),
  BallColor(
    name: 'Blue',
    main: Color(0xFF0A84FF),
    glow: Color(0x700A84FF),
    highlight: Color(0xFF80C4FF),
    shadow: Color(0xFF003A8A),
  ),
  BallColor(
    name: 'Green',
    main: Color(0xFF32D74B),
    glow: Color(0x7032D74B),
    highlight: Color(0xFF90EEA0),
    shadow: Color(0xFF0A5020),
  ),
  BallColor(
    name: 'Yellow',
    main: Color(0xFFFFD60A),
    glow: Color(0x70FFD60A),
    highlight: Color(0xFFFFEB7A),
    shadow: Color(0xFF6A5500),
  ),
  BallColor(
    name: 'Purple',
    main: Color(0xFFBF5AF2),
    glow: Color(0x70BF5AF2),
    highlight: Color(0xFFDC9EFA),
    shadow: Color(0xFF500A80),
  ),
  BallColor(
    name: 'Orange',
    main: Color(0xFFFF9F0A),
    glow: Color(0x70FF9F0A),
    highlight: Color(0xFFFFCC7A),
    shadow: Color(0xFF6A3A00),
  ),
  BallColor(
    name: 'Cyan',
    main: Color(0xFF5AC8FA),
    glow: Color(0x705AC8FA),
    highlight: Color(0xFFA0E2FF),
    shadow: Color(0xFF0A4A6A),
  ),
  BallColor(
    name: 'Magenta',
    main: Color(0xFFFF2D9B),
    glow: Color(0x70FF2D9B),
    highlight: Color(0xFFFF80CC),
    shadow: Color(0xFF7A0042),
  ),
  BallColor(
    name: 'Teal',
    main: Color(0xFF64D2FF),
    glow: Color(0x7064D2FF),
    highlight: Color(0xFFA1E9FF),
    shadow: Color(0xFF0B4A66),
  ),
  BallColor(
    name: 'Lime',
    main: Color(0xFF9CE73C),
    glow: Color(0x709CE73C),
    highlight: Color(0xFFE2FF96),
    shadow: Color(0xFF3E7409),
  ),
  BallColor(
    name: 'Pink',
    main: Color(0xFFFF6B96),
    glow: Color(0x70FF6B96),
    highlight: Color(0xFFFFA3C0),
    shadow: Color(0xFF7A0F3F),
  ),
  BallColor(
    name: 'Indigo',
    main: Color(0xFF5E5CE6),
    glow: Color(0x705E5CE6),
    highlight: Color(0xFF9B99FF),
    shadow: Color(0xFF1C1A6A),
  ),
];
