CREATE TABLE IF NOT EXISTS tb_lista (
    lista INTEGER PRIMARY KEY,
    franquia TEXT,
    sistema TEXT,
    idEntregador INTEGER,
    nomeEntregador TEXT,
    quantidadeDocumentos INTEGER,
    perimetro INTEGER
);

CREATE TABLE IF NOT EXISTS tb_hawb (
    hawbId INTEGER PRIMARY KEY,
    idCliente INTEGER,
    idContrato INTEGER,
    idCCusto INTEGER,
    idProduto INTEGER,
    codHawb TEXT,
    listaId INTEGER,
    numeroEncomandaCliente TEXT,
    nomeDestinatario TEXT,
    dna INTEGER,
    tentativas INTEGER,
    fotoEspecial TEXT,
    score INTEGER,
    latitude REAL,
    longitude REAL
);


CREATE TABLE IF NOT EXISTS tb_hawb_finalizada (
    codHawb TEXT PRIMARY KEY,
    tipoBaixa TEXT,
    dataHoraBaixa TEXT,
    idTipoLocal INTEGER,
    idTipoDificuldade INTEGER,
    foraAlvo INTEGER,
    latitude REAL,
    longitude REAL,
    nivelBateria INTEGER,
    nomeRecebedor TEXT,
    RG TEXT,
    idGrauParentesco INTEGER,
    xmlPesquisa TEXT,
    idMotivo INTEGER,
    idSituacao INTEGER,
    foto INTEGER
);


CREATE TABLE IF NOT EXISTS tb_coleta (
    coletaId TEXT PRIMARY KEY,
    statusRetorno TEXT,
    clienteId TEXT,
    contratoId TEXT,
    dnaColeta TEXT,
    responsavel TEXT,
    dtHoraFimCol TEXT,
    dtHoraProcesso TEXT,
    distanciaAlvoRT TEXT,
    franquia TEXT,
    nomeCliente TEXT,
    tipoEncomenda TEXT,
    logradouro TEXT,
    numEnd TEXT,
    complEnd TEXT,
    bairro TEXT,
    cidade TEXT,
    uf TEXT,
    cep TEXT,
    obs TEXT
);

CREATE TABLE IF NOT EXISTS tb_coleta_finalizada (
    codColeta TEXT PRIMARY KEY,
    clienteId TEXT,
    contratoId TEXT,
    dataProcesso TEXT,
    tipoProcesso TEXT,
    latitude TEXT,
    longitude TEXT,
    foraAlvo TEXT,
    nivelBateria TEXT,
    recebedor TEXT,
    rg TEXT
);


CREATE TABLE IF NOT EXISTS tb_images (
    imageType TEXT,
    id TEXT,
    imagePath TEXT,
    imageName TEXT,
    operationType TEXT
);



