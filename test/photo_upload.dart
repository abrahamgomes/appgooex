import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/ordem_servico_service.dart';
import 'package:http/http.dart' as http;

void main() {
final _ordemServicoService = OrdemServicoService();
  test('listar fotos', () async {
    await loginStore.doLogin('transportador@gmail.com', '123456');
        String ordemServicoUUID =
        'de32aa06-14d3-40d8-ab60-27b93a8aea77';
    await _ordemServicoService.listarFotos(ordemServicoUUID);
    expect(true, true);
  });


  test('upload de imagens', () async {
    //https://stackoverflow.com/questions/45780255/flutter-how-to-load-file-for-testing
    String tokenTransportador = '6849b31e40cd37813dc32953653eafa53859fb70';
    String ordemServicoUUID =
        'de32aa06-14d3-40d8-ab60-27b93a8aea77';
    final String apiUrl =
        'https://apigooex.geomk.com.br/api/1.0/ordem_servico/$ordemServicoUUID/fotos';

    var uri = Uri.parse(apiUrl);
 
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Token $tokenTransportador'
      ..files
          .add(await http.MultipartFile.fromPath('foto', 'test_resources/logo.png'));
    var response = await request.send();

    print('Retorno:\n\n');
    print((await response.stream.bytesToString()));
    print('\n\n');

    expect(response.statusCode, 201);

    // throws
  });
}
