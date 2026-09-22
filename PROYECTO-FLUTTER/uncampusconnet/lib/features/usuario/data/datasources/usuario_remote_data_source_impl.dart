import 'package:uncampusconnet/core/database/roble_client.dart';

import '../../domain/entities/usuario.dart';
import 'usuario_remote_data_source.dart';

class UsuarioRemoteDataSourceImpl implements UsuarioRemoteDataSource {
  static const int _maxIntentosCrearUsuario = 5;

  Usuario _mapearUsuario(Map<String, dynamic> data) {
    return Usuario(
      idUsuario: int.parse(data['id_usuario'].toString()),
      nombreUsuario: data['nombre_usuario'].toString(),
      correoInstitucional: data['correo_institucional'].toString(),
      carrera: data['carrera'].toString(),
      semestre: int.parse(data['semestre'].toString()),
      idAutenticador: data['id_autenticador'].toString(),
    );
  }

  Future<int> _obtenerSiguienteIdUsuario() async {
    final registros = await RobleClient.instance.read('usuario');

    int mayorId = 0;

    for (final registro in registros) {
      final id = int.tryParse(
        registro['id_usuario'].toString(),
      );

      if (id != null && id > mayorId) {
        mayorId = id;
      }
    }

    return mayorId + 1;
  }

  Future<bool> _idYaExiste(int idUsuario) async {
    final registros = await RobleClient.instance.read(
      'usuario',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    return registros.isNotEmpty;
  }

  @override
  Future<Usuario> crearUsuario({
    required String nombreUsuario,
    required String correoInstitucional,
    required String carrera,
    required int semestre,
    required String idAutenticador,
  }) async {
    for (int intento = 1; intento <= _maxIntentosCrearUsuario; intento++) {
      final idUsuario = await _obtenerSiguienteIdUsuario();

      try {
        final resultado = await RobleClient.instance.create(
          'usuario',
          {
            'id_usuario': idUsuario,
            'nombre_usuario': nombreUsuario,
            'correo_institucional': correoInstitucional,
            'carrera': carrera,
            'semestre': semestre,
            'id_autenticador': idAutenticador,
          },
        );

        return _mapearUsuario(
          Map<String, dynamic>.from(resultado),
        );
      } catch (e) {
        final idFueOcupado = await _idYaExiste(idUsuario);

        if (!idFueOcupado || intento == _maxIntentosCrearUsuario) {
          rethrow;
        }
      }
    }

    throw StateError(
      'No fue posible generar un id_usuario disponible.',
    );
  }

  @override
  Future<Usuario?> obtenerUsuarioActual(String idAutenticador) async {
    final resultado = await RobleClient.instance.read(
      'usuario',
      filters: {
        'id_autenticador': idAutenticador,
      },
    );

    if (resultado.isEmpty) {
      return null;
    }

    return _mapearUsuario(
      Map<String, dynamic>.from(resultado.first),
    );
  }

  @override
  Future<Usuario?> obtenerUsuarioPorId(int idUsuario) async {
    final resultado = await RobleClient.instance.read(
      'usuario',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    if (resultado.isEmpty) {
      return null;
    }

    return _mapearUsuario(
      Map<String, dynamic>.from(resultado.first),
    );
  }
}