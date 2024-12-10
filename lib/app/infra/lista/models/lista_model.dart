import 'package:rt_flash/app/infra/lista/models/hawb_model.dart';

class ListaModel {
  String? franquia;
  String? sistema;
  int? lista;
  int? idEntregador;
  String? nomeEntregador;
  int? quantidadeDocumentos;
  int? perimetro;
  List<HawbModel>? documentos;

  ListaModel(
      {this.franquia,
      this.sistema,
      this.lista,
      this.idEntregador,
      this.nomeEntregador,
      this.quantidadeDocumentos,
      this.perimetro,
      this.documentos});

  ListaModel.fromMap(Map<String, dynamic> map) {
    franquia = map['franquia'];
    sistema = map['sistema'];
    lista = map['lista'];
    idEntregador = map['idEntregador'];
    nomeEntregador = map['nomeEntregador'];
    quantidadeDocumentos = map['quantidadeDocumentos'];
    perimetro = map['perimetro'];

    if (map['documentos'] != null) {
      documentos = <HawbModel>[];
      map['documentos'].forEach((v) {
        (v as Map<String, dynamic>).addEntries({"listaId": lista}.entries);
        documentos!.add(HawbModel.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['franquia'] = franquia;
    data['sistema'] = sistema;
    data['lista'] = lista;
    data['idEntregador'] = idEntregador;
    data['nomeEntregador'] = nomeEntregador;
    data['quantidadeDocumentos'] = quantidadeDocumentos;
    data['perimetro'] = perimetro;
    return data;
  }
}
