import 'package:flutter_deck/flutter_deck.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_00_title.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_01_steps.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_02_libraries.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_02b_libraries_code.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_03_load_dataset.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_03b_validate_dataset.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_04_create_model.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_04b_model_visualized.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_04c_compile_model.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_04d_verify_model.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_04e_verify_model_result.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_05_train_the_model.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_05b_train_the_model_video.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_06_evaluate_history.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_07_evaluate_manually.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_08_save_model.dart';
import 'package:flutter_presentation/slides/part_1_develop_ml_model/slide_09_tips_and_tricks.dart';

List<FlutterDeckSlideWidget> slidesPart1 = [
  const P1S00Title(),
  const P1S01Steps(),
  const P1S02Libraries(),
  const P1S02bLibraries(),
  const P1S03LoadDataset(),
  const P1S03bValidateDataset(),
  const P1S04CreateModel(),
  const P1S04bModelVisualised(),
  const P1S04cCompileModel(),
  const P1S04dVerifyModel(),
  const P1S04eVerifyModelResult(),
  const P1S05TrainModel(),
  const P1S05bTrainModelVideo(),
  const P1S06EvaluateHistory(),
  const P1S07EvaluateManually(),
  const P1S08SaveModel(),
  const P1S09TipsAndTricks(),
];
