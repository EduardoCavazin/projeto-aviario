import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';

class DAOUsuario implements IDAOUsuario {
  // Referência à coleção "usuarios" no Firestore
  final CollectionReference _usuariosCollection =
      FirebaseFirestore.instance.collection('usuarios');

  @override
  Future<DTOUsuario> salvar(DTOUsuario dto) async {
    if (dto.id == null) {
      // Cria um novo documento na coleção "usuarios"
      DocumentReference docRef = await _usuariosCollection.add({
        'nome': dto.nome,
        'email': dto.email,
        'senha': dto.senha,
      });
      dto.id = docRef.id; // Atribui o ID gerado pelo Firestore ao DTO
    } else {
      // Atualiza o documento existente
      await _usuariosCollection.doc(dto.id.toString()).update({
        'nome': dto.nome,
        'email': dto.email,
        'senha': dto.senha,
      });
    }
    return dto;
  }

  @override
  Future<void> deletar(dynamic id) async {
    await _usuariosCollection.doc(id.toString()).delete();
  }

  @override
  Future<DTOUsuario?> buscarPorId(dynamic id) async {
    DocumentSnapshot doc = await _usuariosCollection.doc(id.toString()).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DTOUsuario(
        id: doc.id,
        nome: data['nome'] as String,
        email: data['email'] as String,
        senha: data['senha'] as String,
      );
    }
    return null;
  }

  @override
  Future<List<DTOUsuario>> buscarUsuarios() async {
    QuerySnapshot querySnapshot = await _usuariosCollection.get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DTOUsuario(
        id: doc.id,
        nome: data['nome'] as String,
        email: data['email'] as String,
        senha: data['senha'] as String,
      );
    }).toList();
  }
  
  @override
  Future<DTOUsuario?> buscarPorEmail(String email) async {
    QuerySnapshot querySnapshot = await _usuariosCollection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return DTOUsuario(
        id: doc.id,
        nome: data['nome'] as String,
        email: data['email'] as String,
        senha: data['senha'] as String,
      );
    }
    return null;
  }
}
