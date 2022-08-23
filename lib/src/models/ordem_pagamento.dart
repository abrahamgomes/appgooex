class OrdemPagamento {
  double valor;
  String paymentUrl;
  String state;
  String stateVerbose;
  String sandboxPaymentUrl;

  OrdemPagamento(
      {this.valor,
      this.paymentUrl,
      this.state,
      this.stateVerbose,
      this.sandboxPaymentUrl});

  OrdemPagamento.fromJson(Map<String, dynamic> json) {
    valor = json['valor'];
    paymentUrl = json['payment_url'];
    state = json['state'];
    stateVerbose = json['state_verbose'];
    sandboxPaymentUrl = json['sandbox_payment_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['valor'] = this.valor;
    data['payment_url'] = this.paymentUrl;
    data['state'] = this.state;
    data['state_verbose'] = this.stateVerbose;
    data['sandbox_payment_url'] = this.sandboxPaymentUrl;
    return data;
  }
}
