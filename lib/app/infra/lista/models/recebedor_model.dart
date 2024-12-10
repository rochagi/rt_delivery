class RecebedorModel {
  RecebedorModel({required this.id, required this.nome});

  int id;
  String nome;

  static List<RecebedorModel> tipoRecebedores = [
    RecebedorModel(id: 1, nome: "Próprio"),
    RecebedorModel(id: 2, nome: "Mãe"),
    RecebedorModel(id: 3, nome: "Pai"),
    RecebedorModel(id: 4, nome: "Porteiro"),
    RecebedorModel(id: 5, nome: "Secretário"),
    RecebedorModel(id: 6, nome: "Segurança"),
    RecebedorModel(id: 7, nome: "Funcionário"),
    RecebedorModel(id: 8, nome: "Empregada"),
    RecebedorModel(id: 9, nome: "Filho"),
    RecebedorModel(id: 10, nome: "Tio"),
    RecebedorModel(id: 11, nome: "Sobrinho"),
    RecebedorModel(id: 12, nome: "Avô"),
    RecebedorModel(id: 13, nome: "Procurador"),
    RecebedorModel(id: 14, nome: "Esposa"),
    RecebedorModel(id: 15, nome: "Esposo"),
    RecebedorModel(id: 16, nome: "Recepção"),
    RecebedorModel(id: 17, nome: "Primo"),
    RecebedorModel(id: 18, nome: "Sogro"),
    RecebedorModel(id: 19, nome: "Inquilino"),
    RecebedorModel(id: 20, nome: "Síndico"),
    RecebedorModel(id: 21, nome: "Irmão"),
    RecebedorModel(id: 22, nome: "Noivo"),
    RecebedorModel(id: 23, nome: "Cunhado"),
    RecebedorModel(id: 24, nome: "Genro"),
    RecebedorModel(id: 25, nome: "Neto"),
    RecebedorModel(id: 26, nome: "Res Autorizado"),
    RecebedorModel(id: 50, nome: "Deixado na Varanda"),
    RecebedorModel(id: 53, nome: "Garagem"),
    RecebedorModel(id: 0, nome: "Agência"),
    RecebedorModel(id: 51, nome: "Caixa de Correspondência"),
    RecebedorModel(id: 52, nome: "Entregue sob a Porta"),
    RecebedorModel(id: 54, nome: "Outros"),
    RecebedorModel(id: 100, nome: "POS Ativado"),
    RecebedorModel(id: 101, nome: "E.C. Ativado"),
    RecebedorModel(id: 102, nome: "Pesquisa Realizada com Sucesso")
  ];
}
