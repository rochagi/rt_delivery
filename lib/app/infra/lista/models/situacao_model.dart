class SituacaoModel {
  SituacaoModel({required this.id, required this.nome});

  int id;
  String nome;

  static List<SituacaoModel> situacaoModel = [
    SituacaoModel(id: 73, nome: "Outros"),
    SituacaoModel(id: 500, nome: "Endereço Errado/Insuficiente"),
    SituacaoModel(id: 503, nome: "Difícil Acesso"),
    SituacaoModel(id: 505, nome: "Falecido"),
    SituacaoModel(id: 508, nome: "Caixa Postal"),
    SituacaoModel(id: 510, nome: "Pessoa sem Documentação"),
    SituacaoModel(id: 516, nome: "Encomenda Danificada"),
    SituacaoModel(id: 517, nome: "A Pedido do Cliente"),
    SituacaoModel(id: 502, nome: "Alto Risco"),
    SituacaoModel(id: 507, nome: "Não Existe Número Indicado"),
    SituacaoModel(id: 511, nome: "CEP Não Atendido"),
    SituacaoModel(id: 512, nome: "Transferido"),
    SituacaoModel(id: 515, nome: "Licença/Afastado"),
    SituacaoModel(id: 501, nome: "Recusado (Destinatário/Interlocutor"),
    SituacaoModel(id: 509, nome: "Desconhecido (Destinatário/Interlocutor)"),
    SituacaoModel(id: 518, nome: "Zona Rural"),
    SituacaoModel(id: 506, nome: "Roteiro Indevido"),
    SituacaoModel(id: 519, nome: "Cadastro Destinatário Incompleto"),
    SituacaoModel(id: 520, nome: "Endereço Rejeitado"),
    SituacaoModel(id: 963, nome: "Fechada - Sem Expediente"),
    SituacaoModel(id: 504, nome: "Mudou-se (endereço)"),
    SituacaoModel(id: 513, nome: "Em Férias/Licença"),
    SituacaoModel(id: 514, nome: "Ex-Funcionário/Transferido"),
    SituacaoModel(id: 525, nome: "Falta Bloco/Apto"),
    SituacaoModel(id: 524, nome: "Falta Bairro/Lote/Quadra"),
    SituacaoModel(id: 531, nome: "Atraso Motivo Chuva"),
    SituacaoModel(id: 529, nome: "Greve/Recesso"),
    SituacaoModel(id: 528, nome: "Espera Excedida"),
    SituacaoModel(id: 532, nome: "Veículo Quebrado"),
    SituacaoModel(id: 104, nome: "Caixa de Correspondência não Encontrada"),
    SituacaoModel(id: 523, nome: "Falta o Número"),
    SituacaoModel(id: 530, nome: "Dest Outra Unidade"),
    SituacaoModel(id: 522, nome: "Rua Não Existe"),
    SituacaoModel(id: 527, nome: "Em Reunião"),
    SituacaoModel(id: 526, nome: "Falta Ramal"),
    SituacaoModel(id: 521, nome: "Número Não Localizado"),
  ];
}
