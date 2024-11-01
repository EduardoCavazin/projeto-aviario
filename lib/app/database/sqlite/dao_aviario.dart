import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_avirario/app/domain/dto/dto_aviario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_aviario.dart';

class DAOAviario implements IDAOAviario {
  final CollectionReference _aviariosCollection =
      FirebaseFirestore.instance.collection('aviarios');

  @override
  Future<DTOAviario> salvar(DTOAviario dto) async {
    if (dto.id == null) {
      DocumentReference docRef = await _aviariosCollection.add({
        'nome': dto.nome,
        'capacidade': dto.capacidade,
      });
      dto.id = docRef.id; 
    } else {
      await _aviariosCollection.doc(dto.id).update({
        'nome': dto.nome,
        'capacidade': dto.capacidade,
      });
    }
    return dto;
  }

  @override
  Future<void> deletar(dynamic id) async {
    await _aviariosCollection.doc(id).delete();
  }

  @override
  Future<DTOAviario?> buscarPorId(dynamic id) async {
    DocumentSnapshot doc = await _aviariosCollection.doc(id).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DTOAviario(
        id: doc.id,
        nome: data['nome'] as String,
        capacidade: data['capacidade'] as int,
      );
    }
    return null;
  }

  @override
  Future<List<DTOAviario>> buscarTodos() async {
    QuerySnapshot querySnapshot = await _aviariosCollection.get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DTOAviario(
        id: doc.id,
        nome: data['nome'] as String,
        capacidade: data['capacidade'] as int,
      );
    }).toList();
  }
}
