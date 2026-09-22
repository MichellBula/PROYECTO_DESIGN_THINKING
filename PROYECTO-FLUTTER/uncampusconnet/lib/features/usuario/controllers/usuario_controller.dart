import 'package:get/get.dart';

import '../data/datasources/usuario_remote_data_source_impl.dart';
import '../data/repositories/usuario_repository_impl.dart';
import '../domain/entities/usuario.dart';

class UsuarioController extends GetxController {
  UsuarioController({
    UsuarioRepositoryImpl? repository,
  }) : repository = repository ??
            UsuarioRepositoryImpl(
              remoteDataSource: UsuarioRemoteDataSourceImpl(),
            );

  final UsuarioRepositoryImpl repository;

  final Rxn<Usuario> perfilUsuario = Rxn<Usuario>();

  final RxBool cargando = false.obs;

  bool get tienePerfil => perfilUsuario.value != null;

  Future<Usuario?> obtenerMiPerfil(String idAutenticador) async {
    try {
      cargando.value = true;

      final usuario = await repository.obtenerUsuarioActual(
        idAutenticador,
      );

      perfilUsuario.value = usuario;

      return usuario;
    } finally {
      cargando.value = false;
    }
  }

  Future<Usuario> crearPerfil({
    required String nombreUsuario,
    required String correoInstitucional,
    required String carrera,
    required int semestre,
    required String idAutenticador,
  }) async {
    try {
      cargando.value = true;

      final usuario = await repository.crearUsuario(
        nombreUsuario: nombreUsuario,
        correoInstitucional: correoInstitucional,
        carrera: carrera,
        semestre: semestre,
        idAutenticador: idAutenticador,
      );

      perfilUsuario.value = usuario;

      return usuario;
    } finally {
      cargando.value = false;
    }
  }
}