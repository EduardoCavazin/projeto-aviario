import 'package:projeto_ddm/app/domain/dto/user_dto.dart';
import 'package:projeto_ddm/app/database/user_dao.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserApplication {
  final UserDAO _userDAO = UserDAO();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUserWithEmail(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await userCredential.user!.sendEmailVerification();

      UserDTO newUser = UserDTO(
        id: uid,
        name: name,
        email: email,
      );

      await _userDAO.save(newUser);
    } catch (e) {
      print("Erro ao registrar o usuário: $e");
      rethrow;
    }
  }

  Future<void> loginUserWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("Erro ao realizar login: $e");
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Erro ao resetar a senha: $e");
      rethrow;
    }
  }

  Future<void> saveUser(UserDTO user) async {
    try {
      await _userDAO.save(user);
    } catch (e) {
      print("Erro ao salvar o usuário: $e");
      rethrow;
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _userDAO.delete(id);
    } catch (e) {
      print("Erro ao deletar o usuário: $e");
      rethrow;
    }
  }

  Future<UserDTO?> getUserById(String id) async {
    try {
      return await _userDAO.findById(id);
    } catch (e) {
      print("Erro ao buscar o usuário: $e");
      rethrow;
    }
  }

  Future<List<UserDTO>> getAllUsers() async {
    try {
      return await _userDAO.findAll();
    } catch (e) {
      print("Erro ao buscar todos os usuários: $e");
      rethrow;
    }
  }

  Future<UserDTO> createUser(String name, String email) async {
    final user = UserDTO(
      id: '',
      name: name,
      email: email,
    );
    await saveUser(user);
    return user;
  }

  Future<void> updateUser(String id, String newName, String newEmail) async {
    final user = await getUserById(id);
    if (user != null) {
      user.name = newName;
      user.email = newEmail;
      await saveUser(user);
    } else {
      print("Usuário não encontrado");
    }
  }
}
