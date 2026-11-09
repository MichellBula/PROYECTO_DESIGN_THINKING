

import { RobleClient } from "@/core/roble/roble_client";
import { ComentarioRemoteDatasource } from "./data/datasources/comentario_remote_datasource";
import { ComentarioRepositoryImpl } from "./data/repositories/comentario_repository_impl";
import { Comentario } from "./domain/entities/comentario";
import { CreateComentario } from "./domain/usecases/create_comentario";
import { GetComentariosByPublicacion } from "./domain/usecases/get_comentarios_by_publicacion";

// =======================================================
// OBTENER ID DEL USUARIO AUTENTICADO
// =======================================================

async function obtenerIdUsuarioAutenticado(
  user: { userId?: string }
): Promise<number> {
  const userId = user.userId?.toString();

  if (!userId) {
    throw new Error(
      "No se pudo obtener el userId de Roble."
    );
  }

  const usuarios = await RobleClient.instance.read(
    "usuario",
    {
      id_autenticador: userId,
    }
  );

  if (usuarios.length === 0) {
    throw new Error(
      "La cuenta autenticada no tiene perfil en usuario."
    );
  }

  const idUsuario = Number(
    usuarios[0]["id_usuario"]
  );

  if (!Number.isSafeInteger(idUsuario)) {
    throw new Error(
      "El perfil no tiene un id_usuario válido."
    );
  }

  return idUsuario;
}

// =======================================================
// TEST PRINCIPAL
// =======================================================

async function main(): Promise<void> {
  console.log("========================================");
  console.log("TEST DE COMENTARIO");
  console.log("========================================");

  const roble = RobleClient.instance;

  let sesionIniciada = false;

  try {
    // =======================================================
    // 1. LOGIN
    // =======================================================

    console.log("\n--- LOGIN ---");

    await roble.login({
      email: "prueba@correo.com",
      password: "Prueba123!",
    });

    sesionIniciada = true;

    console.log("Login exitoso.");

    // =======================================================
    // 2. OBTENER USUARIO AUTENTICADO
    // =======================================================

    console.log(
      "\n--- OBTENIENDO USUARIO AUTENTICADO ---"
    );

    const authUser = await roble.currentUser();

    const idUsuario =
      await obtenerIdUsuarioAutenticado(authUser);

    console.log(
      `id_usuario autenticado: ${idUsuario}`
    );

    // =======================================================
    // 3. COMPROBAR PUBLICACIÓN
    // =======================================================

    const idPublicacion = 1;

    console.log(
      "\n--- COMPROBANDO PUBLICACIÓN ---"
    );

    const publicaciones = await roble.read(
      "publicacion",
      {
        id_publicacion: idPublicacion,
      }
    );

    if (publicaciones.length === 0) {
      throw new Error(
        `No existe la publicación ${idPublicacion}.`
      );
    }

    console.log(
      `Publicación encontrada: ${publicaciones[0]["titulo"]}`
    );

    // =======================================================
    // 4. CREAR DEPENDENCIAS
    // =======================================================

    const datasource = new ComentarioRemoteDatasource(
      roble
    );

    const repository = new ComentarioRepositoryImpl(
      datasource
    );

    const createComentario = new CreateComentario(
      repository
    );

    const getComentarios = new GetComentariosByPublicacion(
      repository
    );

    // =======================================================
    // 5. CREAR COMENTARIO
    // =======================================================

    console.log("\n--- CREANDO COMENTARIO ---");

    const comentario = new Comentario(
      idPublicacion,
      idUsuario,
      "Este es un comentario de prueba.",
      new Date()
    );

    const resultado = await createComentario.execute(
      comentario
    );

    console.log(
      "Comentario creado correctamente."
    );

    console.log(
      "Resultado:",
      resultado
    );

    const idComentario = Number(
      resultado["id_comentario"]
    );

    if (!Number.isSafeInteger(idComentario)) {
      throw new Error(
        "No se pudo obtener un id_comentario válido."
      );
    }

    console.log(
      `id_comentario: ${idComentario}`
    );

    // =======================================================
    // 6. LEER COMENTARIOS
    // =======================================================

    console.log(
      "\n--- LEYENDO COMENTARIOS ---"
    );

    const comentarios = await getComentarios.execute(
      idPublicacion
    );

    console.log(
      `Cantidad de comentarios de la publicación ${idPublicacion}: ${comentarios.length}`
    );

    for (const item of comentarios) {
      console.log(
        `id_comentario=${item["id_comentario"]} ` +
        `→ usuario=${item["id_usuario"]} ` +
        `→ publicacion=${item["id_publicacion"]}`
      );

      console.log(
        `contenido=${item["contenido"]}`
      );

      console.log(
        `fecha=${item["fecha_comentario"]}`
      );

      console.log("----------------------------------------");
    }

    // =======================================================
    // 7. VALIDAR COMENTARIO CREADO
    // =======================================================

    const comentarioEncontrado = comentarios.some(
      (item) =>
        Number(item["id_comentario"]) === idComentario
    );

    if (!comentarioEncontrado) {
      throw new Error(
        "El comentario se creó, pero no apareció en la consulta."
      );
    }

    console.log(
      "Validación correcta: el comentario creado aparece en la publicación."
    );

    // =======================================================
    // RESULTADO FINAL
    // =======================================================

    console.log("\n========================================");
    console.log("TEST FINALIZADO CORRECTAMENTE");
    console.log("========================================");

  } catch (error) {
    console.log("\n========================================");
    console.log("ERROR EN EL TEST");
    console.log("========================================");

    console.error("Error:", error);

    process.exitCode = 1;

  } finally {
    // =======================================================
    // 8. LOGOUT
    // =======================================================

    if (sesionIniciada) {
      console.log("\n--- LOGOUT ---");

      try {
        await roble.logout();

        console.log("Logout exitoso.");

      } catch (error) {
        console.error(
          "Error cerrando sesión:",
          error
        );

        process.exitCode = 1;
      }
    }
  }
}

// =======================================================
// EJECUTAR TEST
// =======================================================

main().catch((error) => {
  console.error("Error inesperado:", error);
  process.exitCode = 1;
});