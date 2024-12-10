enum HawbFieldsEnum {
  hawbReceiverType,
  hawbDevolutionReason,
  hawbReceiverName,
  hawbReceiverDocument,
  hawbARPhoto,
  hawbLocalPhoto,
  hawbSpecialPhoto,
  hawbSignature,
  hawbRecebimentoMaoPropria,
  hawbCaixaDeCorrespondecia,
}

class HawbModel {
  int? idCliente;
  int? idContrato;
  int? idCCusto;
  int? idProduto;
  String? codHawb;
  int? listaId;
  String? numeroEncomandaCliente;
  String? nomeDestinatario;
  int? dna;
  int? tentativas;
  String? fotoEspecial;
  int? score;
  double? latitude;
  double? longitude;

  HawbModel(
      {this.idCliente,
      this.idContrato,
      this.idCCusto,
      this.idProduto,
      this.codHawb,
      this.listaId,
      this.numeroEncomandaCliente,
      this.nomeDestinatario,
      this.dna,
      this.tentativas,
      this.fotoEspecial,
      this.score,
      this.latitude,
      this.longitude});

  HawbModel.fromMap(Map<String, dynamic> map) {
    idCliente = map['idCliente'];
    idContrato = map['idContrato'];
    idCCusto = map['idCCusto'];
    idProduto = map['idProduto'];
    codHawb = map['codHawb'];
    numeroEncomandaCliente = map['numeroEncomandaCliente'];
    nomeDestinatario = map['nomeDestinatario'];
    dna = map['dna'];
    tentativas = map['tentativas'];
    fotoEspecial = map['fotoEspecial'];
    score = map['score'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    listaId = map['listaId'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idCliente'] = idCliente;
    data['idContrato'] = idContrato;
    data['idCCusto'] = idCCusto;
    data['idProduto'] = idProduto;
    data['codHawb'] = codHawb;
    data['numeroEncomandaCliente'] = numeroEncomandaCliente;
    data['nomeDestinatario'] = nomeDestinatario;
    data['dna'] = dna;
    data['tentativas'] = tentativas;
    data['fotoEspecial'] = fotoEspecial;
    data['score'] = score;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['listaId'] = listaId;
    return data;
  }

  Set<HawbFieldsEnum> get requiredFields {
    if (dna == null) {
      return {};
    }
    String breakDna = dna!.toRadixString(2); // converte para binário

    List<String> binaryArray = breakDna.split('').reversed.toList();
    return {
      if (binaryArray.length > 9 && binaryArray[9] == '1')
        HawbFieldsEnum.hawbReceiverName,
      if (binaryArray.length > 9 && binaryArray[9] == '1')
        HawbFieldsEnum.hawbReceiverDocument,
      if (binaryArray.length > 9 && binaryArray[10] == '1')
        HawbFieldsEnum.hawbARPhoto,
      if (binaryArray.length > 11 && binaryArray[11] == '1')
        HawbFieldsEnum.hawbLocalPhoto,
      if (binaryArray.length > 12 && binaryArray[12] == '1')
        HawbFieldsEnum.hawbSpecialPhoto,
      if (binaryArray.length > 18 && binaryArray[18] == '1' && tentativas == 0)
        HawbFieldsEnum.hawbCaixaDeCorrespondecia,
      if (binaryArray.length > 19 && binaryArray[19] == '1' && tentativas == 1)
        HawbFieldsEnum.hawbCaixaDeCorrespondecia,
      if (binaryArray.length > 20 && binaryArray[20] == '1' && tentativas == 2)
        HawbFieldsEnum.hawbCaixaDeCorrespondecia,
      if (binaryArray.length > 25 && binaryArray[25] == '1')
        HawbFieldsEnum.hawbRecebimentoMaoPropria,
      if (binaryArray.length > 27 && binaryArray[28] == '1')
        HawbFieldsEnum.hawbSignature,
    };
  }
}
