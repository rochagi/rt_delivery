class FinalizarColeta {
  final String codColeta;
  final String clienteId;
  final String contratoId;
  final String dataProcesso;
  final String tipoProcesso;
  final String latitude;
  final String longitude;
  final String foraAlvo;
  final String nivelBateria;
  final String recebedor;
  final String rg;

  // Construtor nomeado
  FinalizarColeta({
    required this.codColeta,
    required this.clienteId,
    required this.contratoId,
    required this.dataProcesso,
    required this.tipoProcesso,
    required this.latitude,
    required this.longitude,
    required this.foraAlvo,
    required this.nivelBateria,
    required this.recebedor,
    required this.rg,
  });

  // Método toMap
  Map<String, dynamic> toMap() {
    return {
      'codColeta': codColeta,
      'clienteId': clienteId,
      'contratoId': contratoId,
      'dataProcesso': dataProcesso,
      'tipoProcesso': tipoProcesso,
      'latitude': latitude,
      'longitude': longitude,
      'foraAlvo': foraAlvo,
      'nivelBateria': nivelBateria,
      'recebedor': recebedor,
      'rg': rg,
    };
  }

  // Método fromMap
  factory FinalizarColeta.fromMap(Map<String, dynamic> map) {
    try {
      return FinalizarColeta(
        codColeta: map['codColeta'],
        clienteId: map['clienteId'],
        contratoId: map['contratoId'],
        dataProcesso: map['dataProcesso'],
        tipoProcesso: map['tipoProcesso'],
        latitude: map['latitude'],
        longitude: map['longitude'],
        foraAlvo: map['foraAlvo'],
        nivelBateria: map['nivelBateria'],
        recebedor: map['recebedor'],
        rg: map['rg'],
      );
    } catch (e) {
      rethrow;
    }
  }

  // Método copyWith
  FinalizarColeta copyWith({
    String? codColeta,
    String? clienteId,
    String? contratoId,
    String? dataProcesso,
    String? tipoProcesso,
    String? latitude,
    String? longitude,
    String? foraAlvo,
    String? nivelBateria,
    String? recebedor,
    String? rg,
  }) {
    return FinalizarColeta(
      codColeta: codColeta ?? this.codColeta,
      clienteId: clienteId ?? this.clienteId,
      contratoId: contratoId ?? this.contratoId,
      dataProcesso: dataProcesso ?? this.dataProcesso,
      tipoProcesso: tipoProcesso ?? this.tipoProcesso,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      foraAlvo: foraAlvo ?? this.foraAlvo,
      nivelBateria: nivelBateria ?? this.nivelBateria,
      recebedor: recebedor ?? this.recebedor,
      rg: rg ?? this.rg,
    );
  }
}
