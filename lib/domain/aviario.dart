import 'package:projeto_avirario/domain/lote.dart';

class Aviario {

  String id;
  List<Lote> lotes;

  Aviario({
    required this.id,
    List<Lote>? lotes,
    }) : lotes = lotes ?? <Lote>[];
}