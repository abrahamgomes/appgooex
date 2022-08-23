import 'package:flutter_test/flutter_test.dart';
import 'package:gooex_mobile/src/models/ordem_servico.dart';
import 'package:gooex_mobile/src/models/usuario.dart';
import 'package:gooex_mobile/src/models/viagem.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/usuario_service.dart';
import 'package:gooex_mobile/src/services/viagem_service.dart';


void main() {
  var viagemService = ViagemService();


  test('listagem de viagens', () async {
    await loginStore.doLogin('howard@gmail.com', '123456');
    var viagens = await viagemService.listarViagens();
  });

    

  // test('conversão de datas', () {
  //   final first = DateTime.now().add(Duration(days: 2));
  //   final last = first.add(Duration(days: 2));

  //   print(first.toUtc());
  //   print(first.toIso8601String());
  // });
  

  // test('listagem de pedidos', () async {
  //   await loginStore.doLogin('thetransporter@gmail.com', '123456');
  //   final pedidos = await viagemService.listarPedidos('');

  //   expect(pedidos.length != null, true);
  //   // expect(pedidos[0].id, 19);
  // });


  // test('aceite na ordem de serviço', () async {
  //   await loginStore.doLogin('thetransporter@gmail.com', '123456');
  //   await viagemService.aceitarOrdemServico('', '');
  // });


  test('registrar viagem', () async { 
    await loginStore.doLogin('howard@gmail.com', '123456');
    final first = DateTime.now().add(Duration(days: 7));
    final last = first.add(Duration(days: 4));

    await viagemService.criarViagem(
      Viagem(
        dataChegada: first.toIso8601String()+'Z',
        dataPartida: last.toIso8601String()+'Z',
        cepOrigemString: '58030213',
        numeroOrigem: '100',
        complementoOrigem: 'Test 1',
        cepDestinoString: '60765410',
        numeroDestino: '200',
        complementoDestino: 'Test 2'
      )
    );

    expect(true,true);
  });

}