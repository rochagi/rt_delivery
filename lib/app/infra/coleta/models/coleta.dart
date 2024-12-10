enum ColetaFormFieldsEnum {
  fotoProdutoColetado,
  fotoLocalColeta,
  fotoPedidoColeta,
  fotoForaDoAlvo,
}

class ColetaModel {
  String? statusRetorno;
  String? clienteId;
  String? contratoId;
  String? coletaId;
  String? dnaColeta;
  String? responsavel;
  String? dtHoraFimCol;
  String? dtHoraProcesso;
  String? distanciaAlvoRT;
  String? franquia;
  String? nomeCliente;
  String? tipoEncomenda;
  String? logradouro;
  String? numEnd;
  String? complEnd;
  String? bairro;
  String? cidade;
  String? uf;
  String? cep;
  String? obs;

  ColetaModel(
      {this.statusRetorno,
      this.clienteId,
      this.contratoId,
      this.coletaId,
      this.dnaColeta,
      this.responsavel,
      this.dtHoraFimCol,
      this.dtHoraProcesso,
      this.distanciaAlvoRT,
      this.franquia,
      this.nomeCliente,
      this.tipoEncomenda,
      this.logradouro,
      this.numEnd,
      this.complEnd,
      this.bairro,
      this.cidade,
      this.uf,
      this.cep,
      this.obs});

  ColetaModel.fromMap(Map<String, dynamic> map) {
    statusRetorno = map['statusRetorno'];
    clienteId = map['clienteId'];
    contratoId = map['contratoId'];
    coletaId = map['coletaId'];
    dnaColeta = map['dnaColeta'];
    responsavel = map['responsavel'];
    dtHoraFimCol = map['dtHoraFimCol'];
    dtHoraProcesso = map['dtHoraProcesso'];
    distanciaAlvoRT = map['distanciaAlvoRT'];
    franquia = map['franquia'];
    nomeCliente = map['nomeCliente'];
    tipoEncomenda = map['tipoEncomenda'];
    logradouro = map['logradouro'];
    numEnd = map['numEnd'];
    complEnd = map['complEnd'];
    bairro = map['bairro'];
    cidade = map['cidade'];
    uf = map['uf'];
    cep = map['cep'];
    obs = map['obs'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusRetorno'] = statusRetorno;
    data['clienteId'] = clienteId;
    data['contratoId'] = contratoId;
    data['coletaId'] = coletaId;
    data['dnaColeta'] = dnaColeta;
    data['responsavel'] = responsavel;
    data['dtHoraFimCol'] = dtHoraFimCol;
    data['dtHoraProcesso'] = dtHoraProcesso;
    data['distanciaAlvoRT'] = distanciaAlvoRT;
    data['franquia'] = franquia;
    data['nomeCliente'] = nomeCliente;
    data['tipoEncomenda'] = tipoEncomenda;
    data['logradouro'] = logradouro;
    data['numEnd'] = numEnd;
    data['complEnd'] = complEnd;
    data['bairro'] = bairro;
    data['cidade'] = cidade;
    data['uf'] = uf;
    data['cep'] = cep;
    data['obs'] = obs;
    return data;
  }

  List<ColetaFormFieldsEnum> get requiredFields {
    if (dnaColeta == null) {
      return [];
    }
    String breakDna =
        int.parse(dnaColeta!).toRadixString(2); // converte para binário

    List<String> binaryArray = breakDna.split('').reversed.toList();
    return [
      if (binaryArray.isNotEmpty && binaryArray[0] == '1')
        ColetaFormFieldsEnum.fotoProdutoColetado,
      if (binaryArray.length > 2 && binaryArray[1] == '1')
        ColetaFormFieldsEnum.fotoLocalColeta,
      if (binaryArray.length > 3 && binaryArray[2] == '1')
        ColetaFormFieldsEnum.fotoPedidoColeta,
      if (binaryArray.length > 4 && binaryArray[3] == '1')
        ColetaFormFieldsEnum.fotoForaDoAlvo
    ];
  }
}
