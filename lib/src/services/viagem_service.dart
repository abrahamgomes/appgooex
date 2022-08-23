import 'dart:convert';

import 'package:gooex_mobile/src/models/pedido.dart';
import 'package:gooex_mobile/src/models/viagem.dart';
import 'package:gooex_mobile/src/services/api.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';

class ViagemService {
  
  // cep destino e origem está trazendo id ao invés do cep
  Future<List<Viagem>> listarViagens() async {
    final response = await Api.get('/viagem');
    if(response.statusCode != 200 && response.statusCode != 201) {
      throw new ApiResponseException('Houve um erro ao listar as viagens');
    }

    final arr = json.decode(response.body) as List;
    return arr.map((v) => Viagem.fromJsonTransportador(v)).toList();
  }

  // retorno de erro despadronizado
  Future<void> criarViagem(Viagem viagem) async {
    final response = await Api.post('/viagem/', viagem.toJsonTransportador());

    if(response.statusCode != 200 && response.statusCode != 201){
      print(response.body);
      var data = json.decode(utf8.decode(response.bodyBytes));
      // print(data);
      throw new ApiResponseException('Erro registrar a viagem', payload: data);
    }

  }


  // https://apigooex.geomk.com.br/api/1.0/viagem/11/pedidos
  Future<List<Pedido>> listarPedidos(String viagemId, {int status = 0}) async {
    final response = await Api.get('/viagem/$viagemId/pedidos?status=$status');
    if(response.statusCode != 200 && response.statusCode != 201) {
      throw new ApiResponseException('Houve um erro ao listar os pedidos');
    }
    print(response.body);
    final arr = json.decode(response.body) as List;
    return arr.map((ped) => Pedido.fromJson(ped)).toList();
  }

  Future<void> aceitarOrdemServico(String viagemId, String ordemServicoId, bool confirma) async {
    final response = await Api.post('/viagem/$viagemId/aceite/', {
      'ordem_servico': ordemServicoId,
      'confirmar':  confirma
    });

    if(response.statusCode != 200 && response.statusCode != 201){
      print(response.body);
      var data = json.decode(utf8.decode(response.bodyBytes));
      // print(data);
      throw new ApiResponseException('Erro ao aceitar o pedido', payload: data);
    }
  }


  Future<List<Pedido>> listarPedidosTransportador({int status}) async {
    String url = '/viagem/pedidos';
    if(status != null) url += '?status=$status';
    final response = await Api.get(url);
    if(response.statusCode != 200 && response.statusCode != 201) {
      throw new ApiResponseException('Houve um erro ao listar os pedidos');
    }

    final arr = json.decode(response.body)['results'] as List;
    print(json.encode(arr[0]));
    return arr.map((ped) => Pedido.fromJson(ped)).toList();
  }

}