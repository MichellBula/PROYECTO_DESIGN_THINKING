import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roble/roble.dart';
import '../../../core/database/roble_client.dart';
import '../../comentario/data/datasources/comentario_remote_datasource.dart';
import '../../comentario/data/repositories/comentario_repository_impl.dart';
import '../../comentario/domain/entities/comentario.dart';
import '../controllers/post_interaction_controller.dart';
import '../data/post_data.dart';

class PostDetailPage extends StatefulWidget {
  final PostData post;
  final PostInteractionController interaction;
  final bool focusComposer;

  const PostDetailPage({
    super.key,
    required this.post,
    required this.interaction,
    this.focusComposer = false,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final RobleApiDataBase _roble = RobleClient.instance;

  final TextEditingController _commentController =
      TextEditingController();

  final FocusNode _commentFocusNode = FocusNode();

  late final ComentarioRepositoryImpl _comentarioRepository;

  bool _cargandoComentarios = true;
  bool _enviandoComentario = false;
  String? _errorComentarios;

  List<_ComentarioVista> _comentarios = [];

  final Map<int, String> _nombresUsuarios = {};

  @override
  void initState() {
    super.initState();

    final datasource = ComentarioRemoteDatasource(
      roble: _roble,
    );

    _comentarioRepository = ComentarioRepositoryImpl(
      datasource: datasource,
    );

    _cargarComentarios();

    if (widget.focusComposer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          FocusScope.of(context).requestFocus(
            _commentFocusNode,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  // ==========================================================
  // CARGAR TODOS LOS COMENTARIOS
  // ==========================================================

  Future<void> _cargarComentarios() async {
    if (mounted) {
      setState(() {
        _cargandoComentarios = true;
        _errorComentarios = null;
      });
    }

    try {
      final registros =
          await _comentarioRepository.getComentariosByPublicacion(
        widget.post.idPublicacion,
      );

      final comentarios = <_ComentarioVista>[];

      for (final registro in registros) {
        final idUsuario = int.tryParse(
          registro['id_usuario'].toString(),
        );

        final idComentario = int.tryParse(
          registro['id_comentario'].toString(),
        );

        if (idUsuario == null) {
          continue;
        }

        final nombre = await _obtenerNombreUsuario(idUsuario);

        final fecha = _parsearFecha(
          registro['fecha_comentario'],
        );

        comentarios.add(
          _ComentarioVista(
            idComentario: idComentario,
            idUsuario: idUsuario,
            nombreUsuario: nombre,
            contenido:
                registro['contenido']?.toString() ?? '',
            fecha: fecha,
          ),
        );
      }

      comentarios.sort(
        (a, b) => a.fecha.compareTo(b.fecha),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _comentarios = comentarios;
      });

      widget.interaction.actualizarCantidadComentarios(
        comentarios.length,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorComentarios =
              'No fue posible cargar los comentarios.';
        });
      }

      debugPrint('Error cargando comentarios: $e');
    } finally {
      if (mounted) {
        setState(() {
          _cargandoComentarios = false;
        });
      }
    }
  }

  // ==========================================================
  // OBTENER NOMBRE DEL AUTOR DEL COMENTARIO
  // ==========================================================

  Future<String> _obtenerNombreUsuario(int idUsuario) async {
    final cache = _nombresUsuarios[idUsuario];

    if (cache != null) {
      return cache;
    }

    final usuarios = await _roble.read(
      'usuario',
      filters: {
        'id_usuario': idUsuario,
      },
    );

    final nombre = usuarios.isEmpty
        ? 'Usuario'
        : usuarios.first['nombre_usuario']?.toString().trim();

    final resultado =
        nombre == null || nombre.isEmpty ? 'Usuario' : nombre;

    _nombresUsuarios[idUsuario] = resultado;

    return resultado;
  }

  DateTime _parsearFecha(dynamic valor) {
    if (valor is DateTime) {
      return valor;
    }

    if (valor is int) {
      return DateTime.fromMillisecondsSinceEpoch(valor);
    }

    return DateTime.tryParse(valor?.toString() ?? '') ??
        DateTime.now();
  }

  String _formatearFecha(DateTime fecha) {
    final local = fecha.toLocal();

    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');

    final hora = local.hour.toString().padLeft(2, '0');
    final minuto = local.minute.toString().padLeft(2, '0');

    return '$dia/$mes/${local.year} · $hora:$minuto';
  }

  // ==========================================================
  // ENVIAR COMENTARIO
  // ==========================================================

  Future<void> _enviarComentario() async {
    if (_enviandoComentario) {
      return;
    }

    final contenido = _commentController.text.trim();

    if (contenido.isEmpty) {
      return;
    }

    setState(() {
      _enviandoComentario = true;
    });

    try {
      final authUser = await _roble.currentUser();

      final idAutenticador =
          authUser['userId']?.toString();

      if (idAutenticador == null || idAutenticador.isEmpty) {
        throw Exception(
          'No se pudo identificar al usuario autenticado.',
        );
      }

      final usuarios = await _roble.read(
        'usuario',
        filters: {
          'id_autenticador': idAutenticador,
        },
      );

      if (usuarios.isEmpty) {
        throw Exception(
          'La cuenta autenticada no tiene un perfil registrado.',
        );
      }

      final idUsuario = int.tryParse(
        usuarios.first['id_usuario'].toString(),
      );

      if (idUsuario == null) {
        throw Exception(
          'El perfil del usuario tiene un id_usuario inválido.',
        );
      }

      await _comentarioRepository.createComentario(
        Comentario(
          idPublicacion: widget.post.idPublicacion,
          idUsuario: idUsuario,
          contenido: contenido,
          fechaComentario: DateTime.now(),
        ),
      );

      _commentController.clear();

      await _cargarComentarios();

      if (mounted) {
        FocusScope.of(context).requestFocus(
          _commentFocusNode,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se pudo enviar el comentario: '
              '${e.toString().replaceFirst('Exception: ', '')}',
            ),
          ),
        );
      }

      debugPrint('Error enviando comentario: $e');
    } finally {
      if (mounted) {
        setState(() {
          _enviandoComentario = false;
        });
      }
    }
  }

  Future<void> _toggleLike() async {
    try {
      await widget.interaction.toggleLike();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se pudo actualizar el like: '
              '${e.toString().replaceFirst('Exception: ', '')}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.post.nombreProyecto,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _cargarComentarios,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  18,
                  16,
                  18,
                  20,
                ),
                children: [
                  // PUBLICACIÓN
                  Text(
                    widget.post.titulo,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.post.nombreProyecto,
                    style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _formatearFecha(
                      widget.post.fechaPublicacion,
                    ),
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    widget.post.contenido,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  ),

                  const SizedBox(height: 16),

                  // ACCIONES
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Me gusta',
                        onPressed:
                            widget.interaction.changingLike.value
                                ? null
                                : _toggleLike,
                        icon: Obx(
                          () => Icon(
                            widget.interaction
                                    .likedByCurrentUser.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: widget.interaction
                                    .likedByCurrentUser.value
                                ? Colors.red
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ),

                      Obx(
                        () => Text(
                          '${widget.interaction.likesCount.value}',
                          style: TextStyle(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),

                      const SizedBox(width: 22),

                      const Icon(
                        Icons.chat_bubble_outline,
                        size: 20,
                      ),

                      const SizedBox(width: 6),

                      Obx(
                        () => Text(
                          '${widget.interaction.commentsCount.value}',
                          style: TextStyle(
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 28),

                  // COMENTARIOS
                  Text(
                    'Comentarios (${_comentarios.length})',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 12),

                  if (_cargandoComentarios)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_errorComentarios != null)
                    Column(
                      children: [
                        Text(
                          _errorComentarios!,
                          style: TextStyle(
                            color: scheme.error,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _cargarComentarios,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    )
                  else if (_comentarios.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                      ),
                      child: Text(
                        'Todavía no hay comentarios. '
                        '¡Sé el primero en comentar!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    ..._comentarios.map(
                      (comentario) => _ComentarioTile(
                        comentario: comentario,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // CAMPO PARA ESCRIBIR
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                14,
                10,
                8,
                10,
              ),
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(
                  top: BorderSide(
                    color: scheme.outlineVariant,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      focusNode: _commentFocusNode,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization:
                          TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Escribe un comentario...',
                        filled: true,
                        fillColor:
                            scheme.surfaceContainerHighest,
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(22),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _enviarComentario(),
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton.filled(
                    tooltip: 'Enviar comentario',
                    onPressed: _enviandoComentario
                        ? null
                        : _enviarComentario,
                    icon: _enviandoComentario
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComentarioVista {
  final int? idComentario;
  final int idUsuario;
  final String nombreUsuario;
  final String contenido;
  final DateTime fecha;

  const _ComentarioVista({
    required this.idComentario,
    required this.idUsuario,
    required this.nombreUsuario,
    required this.contenido,
    required this.fecha,
  });
}

class _ComentarioTile extends StatelessWidget {
  final _ComentarioVista comentario;

  const _ComentarioTile({
    required this.comentario,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final inicial = comentario.nombreUsuario.isNotEmpty
        ? comentario.nombreUsuario[0].toUpperCase()
        : 'U';

    final fecha = comentario.fecha.toLocal();

    final fechaTexto =
        '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year} '
        '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: scheme.primaryContainer,
            child: Text(
              inicial,
              style: TextStyle(
                color: scheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comentario.nombreUsuario,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    fechaTexto,
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    comentario.contenido,
                    style: TextStyle(
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}