class DTOLote {
  dynamic id;
  DateTime dataEntrada;
  int quantidadeAves;
  double pesoMedio;
  double qtdRacaoInicial;

  DTOLote({
    this.id,
    required this.dataEntrada,
    required this.quantidadeAves,
    required this.pesoMedio,
    required this.qtdRacaoInicial,
  });
}
