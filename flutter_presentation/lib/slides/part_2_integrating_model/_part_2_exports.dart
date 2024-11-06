import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/slide_00_title.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/slide_01_steps.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/slide_02_libraries.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/slide_03_load_model.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/slide_04_preprocess_input.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/slide_05_run_inference.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/slide_06_handle_output.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/slide_07_best_practices.dart';
import 'package:flutter_presentation/slides/part_2_integrating_model/slide_08_demo.dart';

List<FlutterDeckSlideWidget> slidesPart2 = [
  const P2S00Title(),
  const P2S01Steps(),
  const P2S02Libraries(),
  const P2S03LoadModel(),
  const P2S04PreprocessInput(),
  const P2S05RunInference(),
  const P2S06HandleOutput(),
  const P2S07BestPractices(),
  const P2S08Demo(),
];
