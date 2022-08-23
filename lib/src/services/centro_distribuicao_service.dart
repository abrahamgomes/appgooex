import 'dart:convert';

import 'package:gooex_mobile/src/models/aeroporto.dart';
import 'package:gooex_mobile/src/models/ordem_servico_entregador.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/api.dart';

import 'exceptions/api_response_exception.dart';
import 'package:http/http.dart' as http;

class CentroDistribuicaoService {
  Future<List<Aeroporto>> listarAeroportos() async {
    final response = await Api.get('/centro_distribuicao/aeroportos');
    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      print(response.statusCode);
      print(data);
      throw ApiResponseException('Houve um erro ao listar as fotos do pedido',
          payload: data);
    }

    final results =
        json.decode(utf8.decode(response.bodyBytes))['results'] as List;
    return results.map((aeroporto) => Aeroporto.fromJson(aeroporto)).toList();
  }

  Future enviaFoto(String entregaUUID, String pathImagem) async {
    var uri = Uri.parse(
        '${Api.baseUrl}/centro_distribuicao/$entregaUUID/salvar_imagem_entrega');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Token ${loginStore.usuario.token}'
      ..files.add(await http.MultipartFile.fromPath('foto', pathImagem));

    print('Request sent!');
    print('Token ${loginStore.usuario.token}');

    var response = await request.send();

    var responseString = await response.stream.toBytes();
    var data = json.decode(utf8.decode(responseString));

    print('Response');
    print(data);

    if (response.statusCode != 200 && response.statusCode != 201) {
      var responseString = await response.stream.toBytes();
      var data = json.decode(utf8.decode(responseString));
      print(data);
      throw new ApiResponseException('Erro ao enviar a foto $pathImagem',
          payload: data);
    }
  }

  Future<List<OrdemServicoEntregador>> listarEntregasDisponiveis() async {
    final response =
        await Api.get('/centro_distribuicao/ordem_servico_compativeis');
    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      throw ApiResponseException('Erro ao listar as entregas', payload: data);
    }

    final results = json.decode(utf8.decode(response.bodyBytes)) as List;
    return results
        .map((ordemServicoEntregador) =>
            OrdemServicoEntregador.fromJson(ordemServicoEntregador))
        .toList();
  }

  Future<OrdemServicoEntregador> aceitarEntrega(String uuidPedido) async {
    final response = await Api.post('/centro_distribuicao/aceitar_entrega',
        {'ordem_servico_viagem': uuidPedido});
    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      throw ApiResponseException('Falha ao aceitar entrega', payload: data);
    }

    final result = json.decode(utf8.decode(response.bodyBytes)) as Map;
    return OrdemServicoEntregador.fromJson(result);
  }

  Future<void> notificarEntregadores() async {
    final response =
        await Api.post('/centro_distribuicao/notificar_entregadores', {});
    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      throw ApiResponseException('Falha ao notificar entregadores', payload: data);
    }
  }

  Future<void> cancelarEntrega(String uuidEntrega) async {
    final response = await Api.post(
        '/centro_distribuicao/cancelar_entrega', {'entrega': uuidEntrega});
    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      throw ApiResponseException('Falha ao cancelar entrega', payload: data);
    }
  }

  Future<List<OrdemServicoEntregador>> listarEntregas() async {
    final response = await Api.get('/centro_distribuicao/entregas');
    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      throw ApiResponseException('Falha ao listar entregas', payload: data);
    }

    final results = json.decode(utf8.decode(response.bodyBytes)) as List;
    return results
        .map((ordemServicoEntregador) =>
            OrdemServicoEntregador.fromJson(ordemServicoEntregador))
        .toList();
  }
}
