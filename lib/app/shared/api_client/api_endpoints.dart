const String _homologUrl = ''; //TODO: Substituir

const String _prodUrl = ''; //TODO: Substituir

const String _baseUrl = _homologUrl; //TODO: Trocar entre Homolog e Prod

enum ApiEndpoint {
  auth(url: '$_baseUrl/COLOCAR-AQUI'), //TODO: Substituir url
  buscarLista(url: '$_baseUrl/COLOCAR-AQUI'), //TODO: Substituir url
  buscarColeta(url: '$_baseUrl/COLOCAR-AQUI'), //TODO: Substituir url
  finalizarColeta(url: '$_baseUrl/COLOCAR-AQUI'), //TODO: Substituir url
  finalizarHawb(url: '$_baseUrl/COLOCAR-AQUI'); //TODO: Substituir url

  const ApiEndpoint({required this.url});

  final String url;
}
