# Intro to Machine Learning development and integration in Flutter

## Description
This project is a simple demonstration of how to integrate a machine learning model in a Flutter application. There are three demos that are trained and a demo app that uses the trained models to make predictions. There is also a presentation for Flutter meetup. The trained models are:
- Color classifier (very simple model that can be trained in a few seconds)
- Face detection model
- Eye segmentation model

**Important note**: The trained models and datasets are not included in the repository for storage reasons. I am not the owner of the datasets used in the project. The datasets are available on Kaggle and the links are provided below.

## Requirements
- For training files, I use Jupyter notebooks. You can use any Python IDE or VSCode with Jupyter and Python extensions.
- For training, Python 3.10 is used. I recommend using a virtual environment (venv) before running the code. The required packages are in `requirements.txt`. To install the required packages, run `pip install -r requirements.txt` or uncomment the first cell in the notebooks and run it.
- For demo and presentation, Flutter is used. I ran on Android (demo) and macos (presentation). For other targets or if it doesn't start, refer to https://pub.dev/packages/tflite_flutter

## Datasets used
- https://www.kaggle.com/datasets/fareselmenshawii/face-detection-dataset?resource=download
- https://www.kaggle.com/datasets/ashish2001/multiclass-face-segmentation (https://datasetninja.com/multi-class-face-segmentation)

## Assets used in demo
- hat: https://pngtree.com/so/sombrero-hat
- glasses: https://nohat.cc/f/life-cool-glasses-png-transparent-lentes-turn-down-for-what-png/m2i8A0d3b1K9K9Z5-201907231228.html