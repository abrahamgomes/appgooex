import 'package:flutter_test/flutter_test.dart';
import 'package:gooex_mobile/src/pages/login/login_store.dart';
import 'package:gooex_mobile/src/services/centro_distribuicao_service.dart';

void main() {
  CentroDistribuicaoService centroDistribuicaoService = CentroDistribuicaoService();

  test('ordem de pagamento', () async {
    await loginStore.doLogin('abcdef@gmail.com', '123456');
    var entregas = await centroDistribuicaoService.listarEntregasDisponiveis();
    expect(entregas.length > 0, true);
  });

 
}
