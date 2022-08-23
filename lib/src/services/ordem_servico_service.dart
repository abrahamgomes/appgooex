import 'dart:convert';
import 'package:gooex_mobile/src/models/endereco_transportador.dart';
import 'package:gooex_mobile/src/models/image_upload.dart';
import 'package:gooex_mobile/src/models/ordem_pagamento.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/models/pedido.dart';
import 'package:gooex_mobile/src/models/viagem.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/api.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';
import 'package:http/http.dart' as http;

class OrdemServicoService {
  Future<List<ImageUpload>> listarFotos(String ordemServicoUUID) async {
    final response = await Api.get('/ordem_servico/$ordemServicoUUID/fotos');
    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      throw new ApiResponseException(
          'Houve um erro ao listar as fotos do pedido',
          payload: data);
    }

    final results = json.decode(response.body)['results'] as List;
    return results.map((os) => ImageUpload.fromJson(os, network: true)).toList();
  }


  Future<EnderecoTransportador> enderecoTransportador(String ordemServicoUUID) async {
    final response = await Api.get('/ordem_servico/$ordemServicoUUID/endereco_trasportador');
    var data = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw new ApiResponseException(
          'Houve um erro ao listar as fotos do pedido',
          payload: data);
    }
    print(data);
    return EnderecoTransportador.fromJson(data);
    // final results = json.decode(response.body)['results'] as List;
    // return results.map((os) => EnderecoTransportador.fromJson(os, network: true)).toList();
  }

  Future enviaFoto(String ordemServicoUUID, String pathImagem) async {
    var uri = Uri.parse('${Api.baseUrl}/ordem_servico/$ordemServicoUUID/fotos');
    http.MultipartRequest request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Token ${loginStore.usuario.token}'
      ..files.add(await http.MultipartFile.fromPath('foto', pathImagem));

    var response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      var responseString = await response.stream.toBytes();
      var data = json.decode(utf8.decode(responseString));
      print(data);
      throw new ApiResponseException('Erro ao enviar a foto $pathImagem',
          payload: data);
    }
  }

  Future avaliarServico(
      String ordemServicoUUID, {
        int notaEntregador,
        String comentarioEntregador,
        int notaTransportador, 
        String comentarioTransportador
      }) async {
    final response = await Api.post(
        '/ordem_servico/$ordemServicoUUID/avaliar_servico',
        {
          'nota_entregador': notaEntregador,
          'comentario_entregador': comentarioEntregador,
          'nota_transportador': notaTransportador,
          'comentario_transportador': comentarioTransportador
        }
  );

    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      throw new ApiResponseException('Houve um erro ao avaliar o serviço',
          payload: data);
    }
  }

  Future<OrdemPagamento> obterURLPagamento(String ordemServicoUUID) async {
    final response =
        await Api.get('/ordem_servico/$ordemServicoUUID/pagamento');

    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      throw new ApiResponseException(
          'Houve um erro ao buscar a URL de pagamento',
          payload: data);
    }

    var data = json.decode(utf8.decode(response.bodyBytes));
    return OrdemPagamento.fromJson(data);
  }

  Future<List<OrdemServico>> listarOrdensServico({int status}) async {
    String url = '/ordem_servico';
    if(status != null) url += '?status=$status';
    final response = await Api.get(url);
    print(response.body);

    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'] as List;
      return results.map((os) => OrdemServico.fromJson(os)).toList();
    } else {
      throw new Exception('Falha ao listar as ordens de serviço');
    }
  }

  Future<void> criarOrdemServico(OrdemServico ordemServico) async {
    final jsonOs = ordemServico.toJson();
    jsonOs.removeWhere((key, value) => value == null);
    final response = await Api.post('/ordem_servico/', jsonOs);
    print('Response: ${response.statusCode}');
    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      print(data);
      throw new ApiResponseException('Erro ao criar ordem de serviço',
          payload: data);
    }
  }

  Future<List<Viagem>> listaViagensCompativeis(String ordemServicoId) async {
    final response = await Api.get(
        '/ordem_servico/$ordemServicoId/transportadores_disponiveis');
    if (response.statusCode == 200 && response.statusCode != 201) {
      // final results = json.decode(response.body) as List;
      final results = json.decode(utf8.decode(response.bodyBytes)) as List;
      return results.map((viagem) => Viagem.fromJson(viagem)).toList();
    } else {
      throw new Exception(json.decode(response.body));
    }
  }

  Future<OrdemServico> buscarPorId(String ordemServicoId) async {
    final response = await Api.get('/ordem_servico/$ordemServicoId/');
    if (response.statusCode == 200 && response.statusCode != 201) {
      final result = json.decode(response.body) as Map;
      return OrdemServico.fromJson(result);
    } else {
      throw new Exception(json.decode(response.body));
    }
  }

  Future<void>  adicionarTransportador(
      String ordemServicoId, String viagemId) async {
    final response = await Api.post(
        '/ordem_servico/$ordemServicoId/adicionar_transportador',
        {'viagem': viagemId, 'confirmar': true});

    if (response.statusCode != 200 && response.statusCode != 201) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      throw new ApiResponseException('Erro ao enviar solicitação',
          payload: data);
    }
  }

  Future<List<Pedido>> listarPedidosCliente({int status}) async {
    String url = '/ordem_servico/pedidos';
    if(status != null) url += '?status=$status';
    final response = await Api.get(url);
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw new ApiResponseException('Houve um erro ao listar os pedidos');
    }

    final arr = json.decode(response.body)['results'] as List;
    return arr.map((ped) => Pedido.fromJson(ped)).toList();
  }
}
