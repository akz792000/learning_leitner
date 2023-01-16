# learning_leitner

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Hive configuration
add hive_generator and build_runner to the dev dependencies

# for generate file continue following steps
1. add part '<name>.g.dart';
2. run => flutter packages pub run build_runner build

# run the project
flutter run

# create apk
flutter channel stable
flutter upgrade
flutter clean
flutter build apk --release

download file from build -> app -> outputs -> apk -> release

# Bug
On my phone (Android) Uri.https download file from internet was not working so I did the following
1. Got to android/app/src/main/AndroidManifest.xml
2. Add this line <uses-permission android:name="android.permission.INTERNET" /> before opening <application>