class DTOLote {
  dynamic id;
  DateTime dataEntrada;
  int quantidadeAves;
  double pesoMedio;
  double quantidadeRacaoInicial;

  DTOLote({
    this.id,
    required this.dataEntrada,
    required this.quantidadeAves,
    required this.pesoMedio,
    required this.quantidadeRacaoInicial,
  });
}
