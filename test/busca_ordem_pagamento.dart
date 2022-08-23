import 'package:flutter_test/flutter_test.dart';
import 'package:gooex_mobile/src/models/ordem_pagamento.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/exceptions/api_response_exception.dart';
import 'package:gooex_mobile/src/services/ordem_servico_service.dart';

void main() {
  
  var ordemServicoService = OrdemServicoService();
  

  test('buscar ordem de pagamento', () async {
    await loginStore.doLogin('cliente@gmail.com', '123456');
    OrdemPagamento ordemPagamento;
    try {
      ordemPagamento = await ordemServicoService.obterURLPagamento('de32aa06-14d3-40d8-ab60-27b93a8aea77');
    } on ApiResponseException catch (e) {
      print(e.message);
      print(e.payload);
    }
    expect(ordemPagamento.state, 'pago');
  });
}