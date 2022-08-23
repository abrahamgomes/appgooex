import 'package:flutter_test/flutter_test.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/ordem_servico_service.dart';
import 'package:gooex_mobile/src/services/viagem_service.dart';

void main() {
  var viagemService = ViagemService();
  var ordemServicoService = OrdemServicoService();

  test('listar pedidos transportador', () async {
    await loginStore.doLogin('thetransporter@gmail.com', '123456');
    final pedidos = await viagemService.listarPedidosTransportador();
    
    expect(pedidos.length != null, true);
  });

  test('listar pedidos cliente', () async {
    await loginStore.doLogin('edigleyssonsilva@outlook.com', '123456');
    final pedidos = await ordemServicoService.listarPedidosCliente();
    
    expect(pedidos.length != null, true);
  });
  // test('registrar viagem', () async {
  //   await loginStore.doLogin('thetransporter@gmail.com', '123456');
  //   final first = DateTime.now().add(Duration(days: 7));
  //   final last = first.add(Duration(days: 4));

  //   print('first: ${first.toIso8601String()}');
  //   print('last: ${last.toIso8601String()}');

  //   await viagemService.criarViagem(
  //     Viagem(
  //       dataChegada: first.toIso8601String()+'Z',
  //       dataPartida: last.toIso8601String()+'Z',
  //       cepOrigemString: '01001000',
  //       numeroOrigem: '100',
  //       complementoOrigem: 'Test 1',
  //       cepDestinoString: '01004902',
  //       numeroDestino: '200',
  //       complementoDestino: 'Test 2'
  //     )
  //   );

  //   expect(true,true);
  // });
}
