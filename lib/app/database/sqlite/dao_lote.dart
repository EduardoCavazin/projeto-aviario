import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_avirario/app/domain/dto/dto_lote.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_lote.dart';

class DAOLote implements IDAOLote {
  final CollectionReference _lotesCollection =
      FirebaseFirestore.instance.collection('lotes');

  @override
  Future<DTOLote> salvar(DTOLote dto) async {
    if (dto.id == null) {
      DocumentReference docRef = await _lotesCollection.add({
        'dataEntrada': dto.dataEntrada.toIso8601String(),
        'quantidadeAves': dto.quantidadeAves,
        'pesoMedio': dto.pesoMedio,
        'qtdRacaoInicial': dto.qtdRacaoInicial,
      });
      dto.id = docRef.id; 
    } else {
      await _lotesCollection.doc(dto.id.toString()).update({
        'dataEntrada': dto.dataEntrada.toIso8601String(),
        'quantidadeAves': dto.quantidadeAves,
        'pesoMedio': dto.pesoMedio,
        'qtdRacaoInicial': dto.qtdRacaoInicial,
      });
    }
    return dto;
  }

  @override
  Future<DTOLote?> buscarPorId(dynamic id) async {
    DocumentSnapshot doc = await _lotesCollection.doc(id.toString()).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DTOLote(
        id: doc.id,
        dataEntrada: DateTime.parse(data['dataEntrada'] as String),
        quantidadeAves: data['quantidadeAves'] as int,
        pesoMedio: data['pesoMedio'] as double,
        qtdRacaoInicial: data['qtdRacaoInicial'] as double,
      );
    }
    return null;
  }

  @override
  Future<List<DTOLote>> buscarTodos() async {
    QuerySnapshot querySnapshot = await _lotesCollection.get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DTOLote(
        id: doc.id,
        dataEntrada: DateTime.parse(data['dataEntrada'] as String),
        quantidadeAves: data['quantidadeAves'] as int,
        pesoMedio: data['pesoMedio'] as double,
        qtdRacaoInicial: data['qtdRacaoInicial'] as double,
      );
    }).toList();
  }

  @override
  Future<void> deletar(dynamic id) async {
    await _lotesCollection.doc(id.toString()).delete();
  }
}
