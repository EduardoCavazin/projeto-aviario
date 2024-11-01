import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_avirario/app/domain/dto/dto_propriedade.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_propriedade.dart';

class DAOPropriedade implements IDAOPropriedade {
  // Referência à coleção "propriedades" no Firestore
  final CollectionReference _propriedadesCollection =
      FirebaseFirestore.instance.collection('propriedades');

  @override
  Future<DTOPropriedade> salvar(DTOPropriedade dto) async {
    if (dto.id == null) {
      // Cria um novo documento na coleção "propriedades"
      DocumentReference docRef = await _propriedadesCollection.add({
        'nome': dto.nome,
        'localizacao': dto.localizacao,
        'qtdAviario': dto.qtdAviario,
      });
      dto.id = docRef.id; // Atribui o ID gerado pelo Firestore ao DTO
    } else {
      // Atualiza o documento existente
      await _propriedadesCollection.doc(dto.id.toString()).update({
        'nome': dto.nome,
        'localizacao': dto.localizacao,
        'qtdAviario': dto.qtdAviario,
      });
    }
    return dto;
  }

  @override
  Future<void> deletarPropriedade(dynamic id) async {
    await _propriedadesCollection.doc(id.toString()).delete();
  }

  @override
  Future<DTOPropriedade?> buscarPorId(dynamic id) async {
    DocumentSnapshot doc = await _propriedadesCollection.doc(id.toString()).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DTOPropriedade(
        id: doc.id,
        nome: data['nome'] as String,
        localizacao: data['localizacao'] as String,
        qtdAviario: data['qtdAviario'] as int,
        aviarios: [], // A lista de aviários pode ser carregada separadamente
      );
    }
    return null;
  }

  @override
  Future<List<DTOPropriedade>> buscarPropriedade() async {
    QuerySnapshot querySnapshot = await _propriedadesCollection.get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DTOPropriedade(
        id: doc.id,
        nome: data['nome'] as String,
        localizacao: data['localizacao'] as String,
        qtdAviario: data['qtdAviario'] as int,
        aviarios: [], // Aviários podem ser carregados depois, usando o ID da propriedade
      );
    }).toList();
  }
}
