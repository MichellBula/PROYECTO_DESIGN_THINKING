import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uncampusconnet/core/database/roble_client.dart';
import 'package:uncampusconnet/core/theme/text_styles.dart';
import 'package:uncampusconnet/core/theme/theme.dart';
import 'package:uncampusconnet/features/auth/controllers/sesion_controller.dart';
import 'package:uncampusconnet/features/buscar/data/information_list.dart';
import 'package:uncampusconnet/features/buscar/widgets/success_dialog.dart';
import 'package:uncampusconnet/features/create_project/data/datasources/project_roles_remote_datasource.dart';
import 'package:uncampusconnet/features/solicitudes/data/datasources/solicitud_remote_datasource.dart';
import 'package:uncampusconnet/features/solicitudes/data/repositories/solicitud_repository_impl.dart';
import 'package:uncampusconnet/features/solicitudes/domain/usecases/create_solicitud.dart';
import 'package:uncampusconnet/ui/widgets/dropdown_field.dart';
import 'package:uncampusconnet/ui/widgets/screen_title.dart';
import 'package:uncampusconnet/ui/widgets/text_field.dart';

import '../../solicitudes/domain/entities/solicitud.dart';

class CompletarSolicitudPage extends StatefulWidget {
  final ProjectInfo project;

  const CompletarSolicitudPage({super.key, required this.project});

  @override
  State<CompletarSolicitudPage> createState() => _CompletarSolicitudPageState();
}

class _CompletarSolicitudPageState extends State<CompletarSolicitudPage> {
  final _motivoController = TextEditingController();

  final SolicitudRemoteDatasource _solicitudDatasource =
      SolicitudRemoteDatasource();

  final ProjectRolesRemoteDatasource _rolesDatasource =
      ProjectRolesRemoteDatasource();

  String? _rolSeleccionado;

  bool _enviando = false;
  bool _cargandoInicial = true;

  bool _bloqueado = false;

  String? _mensajeBloqueo;

  SesionController get _sesionController => Get.find<SesionController>();

  @override
  void initState() {
    super.initState();

    _cargarInformacionInicial();
  }

  @override
  void dispose() {
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _cargarInformacionInicial() async {
    print('[SOLICITUD_PAGE] Iniciando validación de postulación.');

    final idProyecto = widget.project.idProyecto;

    if (idProyecto == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _bloqueado = true;
        _mensajeBloqueo = 'No fue posible identificar el proyecto.';
        _cargandoInicial = false;
      });

      return;
    }

    try {
      final sesion = _sesionController;

      print('[SOLICITUD_PAGE] Buscando perfil del usuario autenticado...');

      var perfil = sesion.perfilUsuario.value;

      if (perfil == null) {
        perfil = await sesion.actualizarPerfil();
      }

      if (perfil == null) {
        throw Exception('No fue posible obtener tu perfil de usuario.');
      }

      print(
        '[SOLICITUD_PAGE] Perfil encontrado: '
        '${perfil.idUsuario}',
      );

      // ----------------------------------------------------------
      // 1. Verificar si el usuario es creador del proyecto
      // ----------------------------------------------------------

      final idCreador = await _solicitudDatasource.getIdCreadorDelProyecto(
        idProyecto,
      );

      print('[SOLICITUD_PAGE] Creador del proyecto: $idCreador');

      if (idCreador == perfil.idUsuario) {
        if (!mounted) {
          return;
        }

        setState(() {
          _bloqueado = true;
          _mensajeBloqueo =
              'No puedes postularte a este proyecto porque tú eres su creador.';
          _cargandoInicial = false;
        });

        print(
          '[SOLICITUD_PAGE] Postulación bloqueada: '
          'el usuario es el creador.',
        );

        return;
      }

      // ----------------------------------------------------------
      // 2. Verificar si ya existe una solicitud para el proyecto
      // ----------------------------------------------------------

      final yaSePostulo = await _solicitudDatasource.tieneSolicitudEnProyecto(
        idUsuario: perfil.idUsuario,
        idProyecto: idProyecto,
      );

      print('[SOLICITUD_PAGE] ¿Ya se postuló?: $yaSePostulo');

      if (yaSePostulo) {
        if (!mounted) {
          return;
        }

        setState(() {
          _bloqueado = true;
          _mensajeBloqueo =
              'Ya te postulaste a este proyecto. '
              'No puedes enviar otra solicitud para el mismo proyecto.';
          _cargandoInicial = false;
        });

        print(
          '[SOLICITUD_PAGE] Postulación bloqueada: '
          'ya existe una solicitud.',
        );

        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _bloqueado = false;
        _mensajeBloqueo = null;
        _cargandoInicial = false;
      });

      print('[SOLICITUD_PAGE] El usuario puede postularse.');
    } catch (e) {
      print('[SOLICITUD_PAGE] Error validando postulación: $e');

      if (!mounted) {
        return;
      }

      setState(() {
        _bloqueado = true;
        _mensajeBloqueo = _limpiarMensajeError(e.toString());
        _cargandoInicial = false;
      });
    }
  }

  Future<int> _obtenerIdProyectoRol({
    required int idProyecto,
    required String nombreRol,
  }) async {
    final relaciones = await _rolesDatasource.getRolesByProject(idProyecto);

    final catalogoRoles = await RobleClient.instance.read('rol');

    for (final relacion in relaciones) {
      final idRol = int.tryParse(relacion['id_rol']?.toString() ?? '');

      final idProyectoRol = int.tryParse(
        relacion['id_proyecto_rol']?.toString() ?? '',
      );

      if (idRol == null || idProyectoRol == null) {
        continue;
      }

      for (final rol in catalogoRoles) {
        final idRolCatalogo = int.tryParse(rol['id_rol']?.toString() ?? '');

        final nombreRolCatalogo = rol['nombre_rol']?.toString().trim();

        if (idRolCatalogo == idRol &&
            nombreRolCatalogo != null &&
            nombreRolCatalogo.toLowerCase() == nombreRol.trim().toLowerCase()) {
          return idProyectoRol;
        }
      }
    }

    throw Exception(
      'No fue posible encontrar el rol seleccionado para este proyecto.',
    );
  }

  Future<void> _enviarSolicitud() async {
    if (_enviando) {
      return;
    }

    if (_cargandoInicial) {
      return;
    }

    if (_bloqueado) {
      _mostrarMensaje(_mensajeBloqueo ?? 'No puedes enviar esta solicitud.');

      return;
    }

    final motivo = _motivoController.text.trim();

    if (motivo.isEmpty) {
      _mostrarMensaje('Indica por qué deseas unirte al proyecto.');

      return;
    }

    if (_rolSeleccionado == null || _rolSeleccionado!.trim().isEmpty) {
      _mostrarMensaje('Selecciona un rol.');

      return;
    }

    final idProyecto = widget.project.idProyecto;

    if (idProyecto == null) {
      _mostrarMensaje('No fue posible identificar el proyecto.');

      return;
    }

    setState(() {
      _enviando = true;
    });

    try {
      final perfil = _sesionController.perfilUsuario.value;

      if (perfil == null) {
        throw Exception('No fue posible obtener tu perfil de usuario.');
      }

      final idUsuario = perfil.idUsuario;

      print('[SOLICITUD_PAGE] Usuario que envía: $idUsuario');

      print('[SOLICITUD_PAGE] Proyecto al que aplica: $idProyecto');

      final idProyectoRol = await _obtenerIdProyectoRol(
        idProyecto: idProyecto,
        nombreRol: _rolSeleccionado!,
      );

      print(
        '[SOLICITUD_PAGE] Rol seleccionado: '
        '$_rolSeleccionado',
      );

      print(
        '[SOLICITUD_PAGE] ID proyecto/rol: '
        '$idProyectoRol',
      );

      final repository = SolicitudRepositoryImpl(
        datasource: _solicitudDatasource,
      );

      final createSolicitud = CreateSolicitud(repository: repository);

      final solicitud = Solicitud(
        idProyecto: idProyecto,
        idUsuario: idUsuario,
        estado: 'pendiente',
        fechaEnviada: DateTime.now(),
        fechaRespuesta: null,
        idProyectoRol: idProyectoRol,
      );

      await createSolicitud(solicitud);

      if (!mounted) {
        return;
      }

      print('[SOLICITUD_PAGE] Solicitud enviada correctamente.');

      _mostrarSolicitudEnviada();
    } catch (e) {
      if (!mounted) {
        return;
      }

      final mensaje = _limpiarMensajeError(e.toString());

      print('[SOLICITUD_PAGE] Error enviando solicitud: $mensaje');

      _mostrarMensaje(mensaje);
    } finally {
      if (mounted) {
        setState(() {
          _enviando = false;
        });
      }
    }
  }

  String _limpiarMensajeError(String mensaje) {
    return mensaje.replaceFirst('Exception: ', '').trim();
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _mostrarSolicitudEnviada() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SuccessDialog(
        projectName: widget.project.name,
        onClose: () {
          Navigator.pop(dialogContext);

          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildDatoPerfil({required String label, required String value}) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyText.copyWith(
              color: scheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value.isEmpty ? 'No disponible' : value,
            style: AppTextStyles.bodyText.copyWith(color: scheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildBloqueo() {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(AppTheme.smallRadius),
        border: Border.all(color: scheme.error),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: scheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _mensajeBloqueo ?? 'No puedes postularte a este proyecto.',
              style: AppTextStyles.bodyText.copyWith(
                color: scheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_cargandoInicial) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Transform.translate(
                offset: const Offset(-12, 0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: AppScreenTitle(title: 'Completar solicitud'),
                ),
              ),
              const Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      );
    }

    final perfil = _sesionController.perfilUsuario.value;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(-12, 0),
                child: const AppScreenTitle(title: 'Completar solicitud'),
              ),

              const SizedBox(height: 24),

              Text(
                'Postulación a ${widget.project.name}',
                style: AppTextStyles.screenTitle.copyWith(
                  color: scheme.onSurface,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Revisa la información de tu perfil y completa los datos de la postulación.',
                style: AppTextStyles.bodyText.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              if (_bloqueado) _buildBloqueo(),

              if (perfil != null) ...[
                _buildDatoPerfil(
                  label: 'Nombre completo',
                  value: perfil.nombreUsuario,
                ),

                const SizedBox(height: 18),

                _buildDatoPerfil(
                  label: 'Correo electrónico',
                  value: perfil.correoInstitucional,
                ),

                const SizedBox(height: 18),

                _buildDatoPerfil(label: 'Carrera', value: perfil.carrera),

                const SizedBox(height: 18),

                _buildDatoPerfil(
                  label: 'Semestre',
                  value: perfil.semestre.toString(),
                ),

                const SizedBox(height: 18),
              ],

              AppTextField(
                label: '¿Por qué desea unirse al proyecto?',
                hint: 'Cuéntanos brevemente por qué quieres participar',
                controller: _motivoController,
                maxLength: 500,
                maxLines: 4,
              ),

              const SizedBox(height: 18),

              AppDropdownField(
                label: 'Rol deseado',
                hint: 'Selecciona un rol',
                value: _rolSeleccionado,
                items: widget.project.roles,
                onChanged: (value) {
                  if (_bloqueado || _enviando) {
                    return;
                  }

                  setState(() {
                    _rolSeleccionado = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: _enviando
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.primary,
                          side: BorderSide(color: scheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppTheme.smallRadius,
                            ),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _enviando || _bloqueado
                            ? null
                            : _enviarSolicitud,
                        child: _enviando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_bloqueado ? 'No disponible' : 'Enviar'),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
