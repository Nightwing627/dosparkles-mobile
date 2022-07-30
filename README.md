# dosparkles
Flutter 2.2.0-10.3.pre • channel beta


flutter clean
flutter packages pub upgrade

# Update translations:

flutter pub run intl*translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/main.dart lib/l10n/intl*\*.arb

# build apk:

flutter build apk --release

flutter build apk --no-sound-null-safety
flutter build apk --split-per-abi --no-sound-null-safety
# update repos:

cd ios
pod cache clean --all
pod repo update
pod update
cd ..
flutter clean
flutter build ios
grep -r IUWebView ios/Pods

android emulator with local backend

ipconfig
// 192.168.43.136

{
"graphQLHttpLink": "http://192.168.43.136:1337/graphql",
"baseApiHost": "http://192.168.43.136:1337"
}

{
"graphQLHttpLink": "https://backend.dosparkles.com/graphql",
"baseApiHost": "https://backend.dosparkles.com"
}
