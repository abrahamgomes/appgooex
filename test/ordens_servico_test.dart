import 'package:flutter_test/flutter_test.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/ordem_servico_service.dart';

void main() {
  var ordensServicoService = OrdemServicoService();
  String ordemServicoUUID = '';

  test('listar ordes de serviço', () async {
    await loginStore.doLogin('cliente2@gmail.com', '123456');
    var ordensServico = await ordensServicoService.listarOrdensServico();
    expect(ordensServico.length > 0, true);
  });

  test('endereço do transportador', () async {
    await loginStore.doLogin('britta@gmail.com', '123456');
    String uuid = 'c4bf7809-b8a3-4094-afa6-bf643ff220e9';
    var endereco = await ordensServicoService.enderecoTransportador(uuid);
   });

  // test('criar uma ordem de servico', () async {
  //   // await login
  //   var minhaOrdemServico = OrdemServico(
  //       altura: 9,
  //       largura: 10,
  //       comprimento: 16,
  //       complemento: '',
  //       cep: 60765410,
  //       numero: '12A',
  //       peso: 6);

  //   await ordensServicoService.criarOrdemServico(minhaOrdemServico);
  //   expect(true, true);
  // });

  test('ordem de pagamento', () async {
    var ordensServico = await ordensServicoService.listarOrdensServico();
    ordemServicoUUID = ordensServico.last.uuid;
    await ordensServicoService.obterURLPagamento(ordemServicoUUID);
    expect(true, true);
  });

  test('transportadores disponíveis', () async {
    final ordemServico = await ordensServicoService.buscarPorId(ordemServicoUUID);
    expect(ordemServico != null, true);

    final viagens = await ordensServicoService.listaViagensCompativeis(ordemServicoUUID);
    expect(viagens.length != null, true);
  });
}
