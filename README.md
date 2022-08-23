# gooex

A new Flutter project.

Deixar esse comando executando no terminal `flutter packages pub run build_runner watch --delete-conflicting-outputs` pois ele vai gerar os arquivo .g.dart


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## ------------ ##

sdk atualizado, todas as dependencias estão funcionando na atual versão, Bundle tambem foi atualizado,
## Instalar Dependências
flutter pub get

## Gerar arquivo .aab para publicação na playstore.
flutter build appbundle

## Gerar o arquivo .apk para instalação manual.
flutter build apk --split-per-abi

## Duvidas e consultas - https://docs.flutter.dev/deployment/android

url de produção está no arquivo api.dart, para fins de desenvolvimento rode em um servidor local.