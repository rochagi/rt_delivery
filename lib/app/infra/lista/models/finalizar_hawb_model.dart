class FinalizarHawbModel {
  String? codHawb;
  String? tipoBaixa;
  String? dataHoraBaixa;
  int? idTipoLocal;
  int? idTipoDificuldade;
  int? foraAlvo;
  double? latitude;
  double? longitude;
  int? nivelBateria;
  String? nomeRecebedor;
  String? rG;
  int? idGrauParentesco;
  String? xmlPesquisa;
  int? idMotivo;
  int? idSituacao;
  int? foto;

  FinalizarHawbModel(
      {this.codHawb,
      this.tipoBaixa,
      this.dataHoraBaixa,
      this.idTipoLocal,
      this.idTipoDificuldade,
      this.foraAlvo,
      this.latitude,
      this.longitude,
      this.nivelBateria,
      this.nomeRecebedor,
      this.rG,
      this.idGrauParentesco,
      this.xmlPesquisa,
      this.idMotivo,
      this.idSituacao,
      this.foto});

  FinalizarHawbModel.fromMap(Map<String, dynamic> map) {
    codHawb = map['codHawb'];
    tipoBaixa = map['tipoBaixa'];
    dataHoraBaixa = map['dataHoraBaixa'];
    idTipoLocal = map['idTipoLocal'];
    idTipoDificuldade = map['idTipoDificuldade'];
    foraAlvo = map['foraAlvo'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    nivelBateria = map['nivelBateria'];
    nomeRecebedor = map['nomeRecebedor'];
    rG = map['RG'];
    idGrauParentesco = map['idGrauParentesco'];
    xmlPesquisa = map['xmlPesquisa'];
    idMotivo = map['idMotivo'];
    idSituacao = map['idSituacao'];
    foto = map['foto'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codHawb'] = codHawb;
    data['tipoBaixa'] = tipoBaixa;
    data['dataHoraBaixa'] = dataHoraBaixa;
    data['idTipoLocal'] = idTipoLocal;
    data['idTipoDificuldade'] = idTipoDificuldade;
    data['foraAlvo'] = foraAlvo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['nivelBateria'] = nivelBateria;
    data['nomeRecebedor'] = nomeRecebedor;
    data['RG'] = rG;
    data['idGrauParentesco'] = idGrauParentesco;
    data['xmlPesquisa'] = xmlPesquisa;
    data['idMotivo'] = idMotivo;
    data['idSituacao'] = idSituacao;
    data['foto'] = foto;
    return data;
  }
}
