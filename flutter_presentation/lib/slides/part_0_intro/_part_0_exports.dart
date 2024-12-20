import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/slides/part_0_intro/slide_0_title.dart';
import 'package:flutter_presentation/slides/part_0_intro/slide_1_william.dart';
import 'package:flutter_presentation/slides/part_0_intro/slide_2_ml_is_math.dart';
import 'package:flutter_presentation/slides/part_0_intro/slide_2b_ml_involves_math.dart';
import 'package:flutter_presentation/slides/part_0_intro/slide_2c_types_of_ml.dart';
import 'package:flutter_presentation/slides/part_0_intro/slide_3_neural_network.dart';
import 'package:flutter_presentation/slides/part_0_intro/slide_4_types_of_supervised.dart';

List<FlutterDeckSlideWidget> slidesPart0 = [
  const P0S00Title(),
  const P0S01William(),
  const P0S02MLIsMath(),
  const P0S02bMLInvolvesMath(),
  const P0S02cTypesOfML(),
  const P0S03NeuralNetwork(),
  const P0S04TypesOfSupervised(),
];
