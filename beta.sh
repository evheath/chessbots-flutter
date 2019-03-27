#!/bin/bash
flutter clean
flutter build apk --release
cd android
fastlane beta
cd ..
flutter build ios --release --no-codesign
cd ios
fastlane beta