import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:projeto_avirario/app/database/firebase/dao_usuario.dart';
import 'package:projeto_avirario/app/domain/dto/dto_usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late DAOUsuario dao;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();

    when(mockFirestore.collection('usuarios')).thenReturn(mockCollection);
    when(mockCollection.doc(any)).thenReturn(mockDocument);

    dao = DAOUsuario(auth: mockAuth, firestore: mockFirestore);
  });

  test('Salvar e buscar usuário', () async {
    final mockUserCredential = MockUserCredential();
    final mockUser = MockUser();
    when(mockAuth.createUserWithEmailAndPassword(
      email: 'test@example.com',
      password: 'test123',
    )).thenAnswer((_) async => mockUserCredential);
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('user123');
    when(mockDocument.set(any as Map<String, dynamic>, any))
        .thenAnswer((_) async => {});

    final usuarioDto =
        DTOUsuario(nome: 'Teste User', email: 'teste@example.com');
    final salvo = await dao.salvar(usuarioDto, senha: 'test123');

    expect(salvo.id, isNotNull);
    expect(salvo.id, 'user123');
  });

  test('Deletar usuário', () async {
    final mockUser = MockUser();
    when(mockAuth.currentUser).thenReturn(mockUser);
    when(mockUser.delete()).thenAnswer((_) async => {});
    when(mockDocument.delete()).thenAnswer((_) async => {});

    final usuarioDto =
        DTOUsuario(nome: 'User to Delete', email: 'delete@example.com');
    await dao.salvar(usuarioDto, senha: 'delete123');
    await dao.deletar('user123');

    verify(mockDocument.delete()).called(1);
    verify(mockUser.delete()).called(1);
  });

  test('Buscar todos os usuários', () async {
    final mockSnapshot = MockDocumentSnapshot();
    when(mockSnapshot.exists).thenReturn(true);
    when(mockSnapshot.data()).thenReturn({
      'nome': 'User1',
      'email': 'user1@example.com',
    });
    when(mockCollection.get()).thenAnswer((_) async => QuerySnapshotMock([
          mockSnapshot,
          mockSnapshot,
        ]));

    final usuarios = await dao.buscarUsuarios();
    expect(usuarios.length, 2);
  });
}

class QuerySnapshotMock extends Mock implements QuerySnapshot<Map<String, dynamic>> {
  @override
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs;

  QuerySnapshotMock(this.docs);
}
