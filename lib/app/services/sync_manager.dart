import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:projeto_avirario/app/database/supabase/dao_aviario_supabase.dart';
import 'package:projeto_avirario/app/database/supabase/dao_lote_supabase.dart';
import 'package:projeto_avirario/app/database/supabase/dao_propriedade_supabase.dart';
import 'package:projeto_avirario/app/database/supabase/dao_usuario_supabase.dart';
import 'package:projeto_avirario/app/database/firebase/dao_aviario.dart';
import 'package:projeto_avirario/app/database/firebase/dao_lote.dart';
import 'package:projeto_avirario/app/database/firebase/dao_propriedade.dart';
import 'package:projeto_avirario/app/database/firebase/dao_usuario.dart';

class SyncManager {
  final DAOAviario localAviarioDAO = DAOAviario();
  final DAOLote localLoteDAO = DAOLote();
  final DAOPropriedade localPropriedadeDAO = DAOPropriedade();
  final DAOUsuario localUsuarioDAO = DAOUsuario();

  final DAOAviarioSupabase remoteAviarioDAO = DAOAviarioSupabase();
  final DAOLoteSupabase remoteLoteDAO = DAOLoteSupabase();
  final DAOPropriedadeSupabase remotePropriedadeDAO = DAOPropriedadeSupabase();
  final DAOUsuarioSupabase remoteUsuarioDAO = DAOUsuarioSupabase();

  Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> syncAviarios() async {
    if (await _isConnected()) {
      final localAviarios = await localAviarioDAO.buscarTodos();
      for (var aviario in localAviarios) {
        await remoteAviarioDAO.salvar(aviario);
      }

      final remoteAviarios = await remoteAviarioDAO.buscarTodos();
      for (var aviario in remoteAviarios) {
        final existingAviario = await localAviarioDAO.buscarPorId(aviario.id);
        if (existingAviario == null) {
          await localAviarioDAO.salvar(aviario);
        }
      }
      print("Sincronização bidirecional de aviários concluída!");
    } else {
      print("Sem conexão. Sincronização de aviários adiada.");
    }
  }

  Future<void> syncLotes() async {
    if (await _isConnected()) {
      final localLotes = await localLoteDAO.buscarTodos();
      for (var lote in localLotes) {
        await remoteLoteDAO.salvar(lote);
      }

      final remoteLotes = await remoteLoteDAO.buscarTodos();
      for (var lote in remoteLotes) {
        final existingLote = await localLoteDAO.buscarPorId(lote.id);
        if (existingLote == null) {
          await localLoteDAO.salvar(lote);
        }
      }
      print("Sincronização bidirecional de lotes concluída!");
    } else {
      print("Sem conexão. Sincronização de lotes adiada.");
    }
  }

  Future<void> syncPropriedades() async {
    if (await _isConnected()) {
      final localPropriedades = await localPropriedadeDAO.buscarPropriedade();
      for (var propriedade in localPropriedades) {
        await remotePropriedadeDAO.salvar(propriedade);
      }

      final remotePropriedades = await remotePropriedadeDAO.buscarPropriedade();
      for (var propriedade in remotePropriedades) {
        final existingPropriedade = await localPropriedadeDAO.buscarPorId(propriedade.id);
        if (existingPropriedade == null) {
          await localPropriedadeDAO.salvar(propriedade);
        }
      }
      print("Sincronização bidirecional de propriedades concluída!");
    } else {
      print("Sem conexão. Sincronização de propriedades adiada.");
    }
  }

  Future<void> syncUsuarios() async {
    if (await _isConnected()) {
      final localUsuarios = await localUsuarioDAO.buscarUsuarios();
      for (var usuario in localUsuarios) {
        await remoteUsuarioDAO.salvar(usuario);
      }

      final remoteUsuarios = await remoteUsuarioDAO.buscarUsuarios();
      for (var usuario in remoteUsuarios) {
        final existingUsuario = await localUsuarioDAO.buscarPorId(usuario.id);
        if (existingUsuario == null) {
          await localUsuarioDAO.salvar(usuario);
        }
      }
      print("Sincronização bidirecional de usuários concluída!");
    } else {
      print("Sem conexão. Sincronização de usuários adiada.");
    }
  }

  Future<void> syncAll() async {
    await syncAviarios();
    await syncLotes();
    await syncPropriedades();
    await syncUsuarios();
  }
}
