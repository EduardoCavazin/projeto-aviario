import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:projeto_avirario/app/domain/interface/i_dao_usuario.dart';

class DAOUsuario implements IDAOUsuario {
  final FirebaseAuth _auth;
  final CollectionReference _usuariosCollection;

  DAOUsuario({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _usuariosCollection = (firestore ?? FirebaseFirestore.instance).collection('usuarios');

  @override
  Future<DTOUsuario> salvar(DTOUsuario dto, {required String senha}) async {
    if (dto.id == null) {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: dto.email,
        password: senha,
      );
      dto.id = userCredential.user!.uid;
    }

    await _usuariosCollection.doc(dto.id).set({
      'nome': dto.nome,
      'email': dto.email,
    }, SetOptions(merge: true));

    return dto;
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
      );
    }).toList();
  }

  @override
  Future<void> deletar(dynamic id) async {
    await _usuariosCollection.doc(id.toString()).delete();
    await _auth.currentUser!.delete();
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
      );
    }
    return null;
  }
}
