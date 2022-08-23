# Release e envio para a loja

## Build
Realize o build da aplicação com o comando `flutter build appbundle`


## Adicionar .aab com o jarsigner

`jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore keys/gooex-upload.keystore build/app/outputs/bundle/release/app-release.aab gooex-upload`

NOTA: A chave encontra-se na pasta **keys**.

## zipalign
Executando zipalign para otimizar o app

`$ANDROID_SDK_ROOT/build-tools/29.0.2/zipalign -v 4 $PWD/build/app/outputs/bundle/release/app-release.aab app.aab`

## apksigner

`$ANDROID_SDK_ROOT/build-tools/29.0.2/apksigner sign --min-sdk-version 21 --ks ./keys/gooex-upload.keystore app.aab`