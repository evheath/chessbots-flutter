# Useful links

## Discord
https://discord.gg/eC2WHe6

## Android
https://play.google.com/store/apps/details?id=com.chessbots.mobile

## iOS
https://testflight.apple.com/join/9Q3CwqpZ

# Useful commands

## Debugging
```flutter run```

## Building
```flutter build apk --release```

```flutter build ios --release --no-codesign```

## Deploying via FastLane
first build (as above) then cd into andriod or ios folder
```fastlane beta```

## Widget testing
flutter test

## Keytool (signing)
/c/Program\ Files/Android/Android\ Studio/jre/bin/keytool.exe -printcert -file ./GOOGPLAY.RSAd

# Standard Operating Procedures 

## Adding a singleplayer bot

1. Create the bot in /lib/shared/prebuilt_bots/new_bot.dart
1. Add the bot to the preBuiltBots List in /lib/shared/prebuilt_bots.dart

## Adding a gambit

1. Create the gambit in /lib/shared/gambits/new_gambit.dart
1. Export the gambit in the /lib/shared/gambits.dart library
1. Add an instance of the gambit's singleton to the allGambits List in /lib/shared/all_gambits.dart