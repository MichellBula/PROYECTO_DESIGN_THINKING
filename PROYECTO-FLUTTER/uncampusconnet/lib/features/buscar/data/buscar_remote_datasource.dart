import '../../../core/database/roble_client.dart';
import '../../create_project/data/datasources/convocatoria_remote_datasource.dart';
import '../../create_project/data/datasources/project_remote_datasource.dart';
import '../../create_project/data/datasources/project_roles_remote_datasource.dart';
import '../../create_project/data/datasources/project_skills_remote_datasource.dart';
import '../../usuario/data/datasources/usuario_remote_data_source.dart';
import '../../usuario/data/datasources/usuario_remote_data_source_impl.dart';
import 'information_list.dart';

class BuscarRemoteDatasource {
  final ProjectRemoteDatasource projectDatasource;
  final ConvocatoriaRemoteDatasource convocatoriaDatasource;
  final ProjectRolesRemoteDatasource rolesDatasource;
  final ProjectSkillsRemoteDatasource skillsDatasource;
  final UsuarioRemoteDataSource usuarioDatasource;

  BuscarRemoteDatasource({
    ProjectRemoteDatasource? projectDatasource,
    ConvocatoriaRemoteDatasource? convocatoriaDatasource,
    ProjectRolesRemoteDatasource? rolesDatasource,
    ProjectSkillsRemoteDatasource? skillsDatasource,
    UsuarioRemoteDataSource? usuarioDatasource,
  })  : projectDatasource =
            projectDatasource ?? ProjectRemoteDatasource(),
        convocatoriaDatasource =
            convocatoriaDatasource ?? ConvocatoriaRemoteDatasource(),
        rolesDatasource =
            rolesDatasource ?? ProjectRolesRemoteDatasource(),
        skillsDatasource =
            skillsDatasource ?? ProjectSkillsRemoteDatasource(),
        usuarioDatasource =
            usuarioDatasource ?? UsuarioRemoteDataSourceImpl();

  Future<List<ProjectInfo>> getProjects() async {
    final proyectos = await projectDatasource.getProjects();

    final categorias = await RobleClient.instance.read(
      'categoria',
    );

    final rolesCatalogo = await RobleClient.instance.read(
      'rol',
    );

    final habilidadesCatalogo = await RobleClient.instance.read(
      'habilidad',
    );

    final resultado = <ProjectInfo>[];

    for (final proyecto in proyectos) {
      final idProyecto = _toInt(
        proyecto['id_proyecto'],
      );

      final idCreador = _toInt(
        proyecto['id_creador'],
      );

      final idCategoria = _toInt(
        proyecto['id_categoria'],
      );

      if (idProyecto == null) {
        continue;
      }

      // ====================================================
      // LIDER
      // ====================================================

      String leader = 'Usuario';

      if (idCreador != null) {
        final usuario =
            await usuarioDatasource.obtenerUsuarioPorId(
          idCreador,
        );

        if (usuario != null) {
          leader = usuario.nombreUsuario;
        }
      }

      if (!leader.startsWith('@')) {
        leader = '@$leader';
      }

      // ====================================================
      // CATEGORIA
      // ====================================================

      String area = 'Sin categorÃ­a';

      if (idCategoria != null) {
        for (final categoria in categorias) {
          final categoriaId = _toInt(
            categoria['id_categoria'],
          );

          if (categoriaId == idCategoria) {
            area = categoria['nombre_categoria']
                    ?.toString() ??
                'Sin categorÃ­a';

            break;
          }
        }
      }

      // ====================================================
      // CONVOCATORIA
      // ====================================================

      final convocatoria =
          await convocatoriaDatasource
              .getConvocatoriaByProject(
        idProyecto,
      );

      String closingDate = '';

      if (convocatoria != null) {
        final fecha = DateTime.tryParse(
          convocatoria['fecha_final']?.toString() ?? '',
        );

        if (fecha != null) {
          closingDate = _formatDate(
            fecha.toLocal(),
          );
        }
      }

      // ====================================================
      // ROLES
      // ====================================================

      final relacionesRoles =
          await rolesDatasource.getRolesByProject(
        idProyecto,
      );

      final projectRoles = <String>[];
      int vacancies = 0;

      for (final relacion in relacionesRoles) {
        final idRol = _toInt(
          relacion['id_rol'],
        );

        final cantidad = _toInt(
              relacion['cantidad'],
            ) ??
            0;

        vacancies += cantidad;

        if (idRol == null) {
          continue;
        }

        for (final rol in rolesCatalogo) {
          final rolId = _toInt(
            rol['id_rol'],
          );

          if (rolId == idRol) {
            final nombreRol =
                rol['nombre_rol']?.toString();

            if (nombreRol != null &&
                nombreRol.isNotEmpty) {
              projectRoles.add(nombreRol);
            }

            break;
          }
        }
      }

      // ====================================================
      // HABILIDADES
      // ====================================================

      final relacionesHabilidades =
          await skillsDatasource.getSkillsByProject(
        idProyecto,
      );

      final habilidades = <String>[];

      for (final relacion in relacionesHabilidades) {
        final idHabilidad = _toInt(
          relacion['id_habilidad'],
        );

        if (idHabilidad == null) {
          continue;
        }

        for (final habilidad in habilidadesCatalogo) {
          final habilidadId = _toInt(
            habilidad['id_habilidad'],
          );

          if (habilidadId == idHabilidad) {
            final nombreHabilidad =
                habilidad['nombre_habilidad']
                    ?.toString();

            if (nombreHabilidad != null &&
                nombreHabilidad.isNotEmpty) {
              habilidades.add(nombreHabilidad);
            }

            break;
          }
        }
      }

      // ====================================================
      // REQUISITOS
      // ====================================================

      final requisitosTexto =
          proyecto['requisitos']?.toString() ?? '';

      final requisitos = requisitosTexto
          .split(RegExp(r'[,;\n]'))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();

      // ====================================================
      // PROJECT INFO PARA BUSCAR
      // ====================================================

      resultado.add(
        ProjectInfo(
          idProyecto: idProyecto,
          leader: leader,
          name: proyecto['nombre']?.toString() ??
              'Proyecto sin nombre',
          members:
              proyecto['num_integrantes']?.toString() ??
                  '0',
          vacancies: vacancies.toString(),
          closingDate: closingDate,
          area: area,
          description:
              proyecto['descripcion']?.toString() ?? '',
          requirements: requisitos,
          roles: projectRoles,
          keywords: habilidades.join(' '),
        ),
      );
    }

    return resultado;
  }

  int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }

  String _formatDate(DateTime date) {
    final day =
        date.day.toString().padLeft(2, '0');

    final month =
        date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }
}

