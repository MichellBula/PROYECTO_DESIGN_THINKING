
import "dotenv/config";

import { RobleApiClient } from "roble-client";

import { AvanceRemoteDatasource } from "./data/datasources/avance_remote_datasource";
import { AvanceRepositoryImpl } from "./data/repositories/avance_repository_impl";

import { Avance } from "./domain/entities/avance";

import { CreateAvance } from "./domain/usecases/create_avance";
import { GetAvanceById } from "./domain/usecases/get_avance_by_id";
import { GetAvancesByEtapa } from "./domain/usecases/get_avances_by_etapa";

// ======================================================
// CONVERTIR VALORES A ENTEROS
// ======================================================

function convertirEntero(valor: unknown): number | null {
  if (valor === null || valor === undefined) {
    return null;
  }

  const texto = String(valor).trim();

  if (!/^[+-]?\d+$/.test(texto)) {
    return null;
  }

  const numero = Number(texto);

  return Number.isSafeInteger(numero) ? numero : null;
}

// ======================================================
// TEST PRINCIPAL
// ======================================================

async function main(): Promise<void> {
  console.log("========================================");
  console.log("TEST DE AVANCE");
  console.log("========================================");

  // ======================================================
  // CONFIGURACIÓN DE ROBLE
  // ======================================================

  const baseUrl =
    process.env.EXPO_PUBLIC_ROBLE_BASE_URL ??
    "https://roble-api.test-openlab.uninorte.edu.co";

  const contractId =
    process.env.EXPO_PUBLIC_ROBLE_CONTRACT_ID;

  const email = process.env.ROBLE_SEED_EMAIL;
  const password = process.env.ROBLE_SEED_PASSWORD;

  if (!contractId || !email || !password) {
    throw new Error(
      "Faltan variables de configuración en el archivo .env."
    );
  }

  // Cliente independiente para ejecutar desde Node.js.
  const roble = new RobleApiClient({
    baseUrl,
    contractId,
  });

  let sesionIniciada = false;
  let pruebaExitosa = false;

  try {
    // ======================================================
    // LOGIN
    // ======================================================

    console.log("\n--- LOGIN ---");

    await roble.login({
      email,
      password,
    });

    sesionIniciada = true;

    console.log("Login exitoso.");

    // ======================================================
    // OBTENER USUARIO AUTENTICADO
    // ======================================================

    console.log("\n--- OBTENIENDO USUARIO AUTENTICADO ---");

    const authUser = await roble.currentUser();

    const idAutenticador = authUser.userId;

    if (!idAutenticador) {
      throw new Error(
        "No se pudo obtener el usuario autenticado."
      );
    }

    const usuarios = await roble.read("usuario", {
      id_autenticador: idAutenticador,
    });

    if (usuarios.length === 0) {
      throw new Error(
        "No existe un perfil de usuario registrado."
      );
    }

    const idUsuario = convertirEntero(
      usuarios[0]["id_usuario"]
    );

    if (idUsuario === null) {
      throw new Error(
        "El perfil no tiene un id_usuario válido."
      );
    }

    console.log("id_usuario autenticado:", idUsuario);

    // ======================================================
    // BUSCAR PROYECTOS DEL USUARIO
    // ======================================================

    console.log("\n--- BUSCANDO PROYECTOS DEL USUARIO ---");

    const proyectosCreados = await roble.read(
      "proyecto",
      {
        id_creador: idUsuario,
      }
    );

    const relacionesIntegrante = await roble.read(
      "integrantes",
      {
        id_usuario: idUsuario,
      }
    );

    const idsProyectos = new Set<number>();

    // Proyectos creados por el usuario.
    for (const proyecto of proyectosCreados) {
      const id = convertirEntero(
        proyecto["id_proyecto"]
      );

      if (id !== null) {
        idsProyectos.add(id);
      }
    }

    // Proyectos donde participa como integrante.
    for (const relacion of relacionesIntegrante) {
      const id = convertirEntero(
        relacion["id_proyecto"]
      );

      if (id !== null) {
        idsProyectos.add(id);
      }
    }

    if (idsProyectos.size === 0) {
      throw new Error(
        "El usuario no pertenece a ningún proyecto."
      );
    }

    console.log(
      "Proyectos encontrados:",
      Array.from(idsProyectos)
    );

    // ======================================================
    // BUSCAR ETAPA CON MENOS DE CINCO AVANCES
    // ======================================================

    console.log("\n--- BUSCANDO ETAPA DISPONIBLE ---");

    const proyectosOrdenados = Array.from(
      idsProyectos
    ).sort((a, b) => b - a);

    let idEtapaSeleccionada: number | null = null;
    let numeroAvancesActual = 0;

    for (const idProyecto of proyectosOrdenados) {
      const etapas = await roble.read(
        "etapa_proyecto",
        {
          id_proyecto: idProyecto,
        }
      );

      const etapasOrdenadas = [...etapas].sort(
        (a, b) => {
          const ordenA =
            convertirEntero(a["orden"]) ?? 0;

          const ordenB =
            convertirEntero(b["orden"]) ?? 0;

          return ordenA - ordenB;
        }
      );

      for (const etapa of etapasOrdenadas) {
        const idEtapa = convertirEntero(
          etapa["id_etapa"]
        );

        if (idEtapa === null) {
          continue;
        }

        const avancesActuales = await roble.read(
          "avance",
          {
            id_etapa: idEtapa,
          }
        );

        if (avancesActuales.length < 5) {
          idEtapaSeleccionada = idEtapa;
          numeroAvancesActual = avancesActuales.length;

          console.log("Proyecto:", idProyecto);
          console.log("Etapa:", etapa["nombre_etapa"]);
          console.log("id_etapa:", idEtapa);

          console.log(
            "Avances actuales:",
            numeroAvancesActual
          );

          console.log(
            "Progreso actual:",
            numeroAvancesActual * 20 + "%"
          );

          break;
        }
      }

      if (idEtapaSeleccionada !== null) {
        break;
      }
    }

    if (idEtapaSeleccionada === null) {
      throw new Error(
        "No hay etapas disponibles con menos de cinco avances. " +
        "Crea una etapa o utiliza una con espacio disponible."
      );
    }

    // ======================================================
    // PROTECCIÓN CONTRA INSERCIONES ACCIDENTALES
    // ======================================================

    if (process.env.ROBLE_TEST_CREATE_AVANCE !== "true") {
      console.log("\n========================================");
      console.log("PRUEBA DE CREACIÓN OMITIDA");
      console.log("========================================");

      console.log(
        "La conexión, el usuario y la búsqueda de etapas funcionaron."
      );

      console.log(
        "Para crear un avance, configura ROBLE_TEST_CREATE_AVANCE=true"
      );

      return;
    }

    // ======================================================
    // CREAR DEPENDENCIAS
    // ======================================================

    const datasource = new AvanceRemoteDatasource(
      roble
    );

    const repository = new AvanceRepositoryImpl(
      datasource
    );

    const crearAvance = new CreateAvance(
      repository
    );

    const obtenerAvancePorId = new GetAvanceById(
      repository
    );

    const obtenerAvancesPorEtapa =
      new GetAvancesByEtapa(repository);

    // ======================================================
    // CREAR AVANCE
    // ======================================================

    console.log("\n--- CREANDO AVANCE ---");

    const fechaActual = new Date();

    const avance = new Avance(
      idEtapaSeleccionada,
      "Avance de prueba registrado el " +
        fechaActual.toISOString(),
      fechaActual
    );

    const resultado = await crearAvance.execute(
      avance
    );

    console.log("Avance creado correctamente.");
    console.log("Resultado:", resultado);

    const idAvance = convertirEntero(
      resultado["id_avance"]
    );

    if (idAvance === null) {
      throw new Error(
        "El avance creado no tiene un id_avance válido."
      );
    }

    console.log(
      "id_avance generado:",
      idAvance
    );

    // ======================================================
    // LEER AVANCE POR ID
    // ======================================================

    console.log("\n--- LEYENDO AVANCE POR ID ---");

    const avanceLeido =
      await obtenerAvancePorId.execute(idAvance);

    if (avanceLeido === null) {
      throw new Error(
        "Se creó el avance pero no se pudo recuperar."
      );
    }

    console.log("Avance encontrado.");
    console.log("----------------------------------------");

    console.log(
      "id_avance:",
      avanceLeido["id_avance"]
    );

    console.log(
      "id_etapa:",
      avanceLeido["id_etapa"]
    );

    console.log(
      "comentario:",
      avanceLeido["comentario"]
    );

    console.log(
      "fecha:",
      avanceLeido["fecha"]
    );

    console.log("----------------------------------------");

    // ======================================================
    // LEER TODOS LOS AVANCES DE LA ETAPA
    // ======================================================

    console.log("\n--- LEYENDO AVANCES DE LA ETAPA ---");

    const listaAvances =
      await obtenerAvancesPorEtapa.execute(
        idEtapaSeleccionada
      );

    const porcentaje = Math.min(
      100,
      Math.max(0, listaAvances.length * 20)
    );

    console.log(
      "Cantidad de avances:",
      listaAvances.length
    );

    for (const registro of listaAvances) {
      console.log(
        "id_avance=" +
          registro["id_avance"] +
          " → " +
          registro["comentario"]
      );
    }

    console.log(
      "Progreso calculado:",
      porcentaje + "%"
    );

    // ======================================================
    // VALIDAR LÍMITE
    // ======================================================

    if (listaAvances.length > 5) {
      throw new Error(
        "La etapa superó el máximo permitido de cinco avances."
      );
    }

    // Verificar también el cálculo del repositorio.
    const porcentajeRepositorio =
      await repository.getPorcentajeByEtapa(
        idEtapaSeleccionada
      );

    if (porcentajeRepositorio !== porcentaje) {
      throw new Error(
        "El porcentaje del repositorio no coincide con el calculado."
      );
    }

    console.log("Validación de límite: correcta.");
    console.log("Validación de porcentaje: correcta.");

    pruebaExitosa = true;

  } catch (error) {
    console.error("\n========================================");
    console.error("ERROR EN EL TEST");
    console.error("========================================");

    console.error(error);
    process.exitCode = 1;

  } finally {
    // ======================================================
    // LOGOUT
    // ======================================================

    if (sesionIniciada) {
      console.log("\n--- LOGOUT ---");

      try {
        await roble.logout();
        console.log("Logout exitoso.");
      } catch (error) {
        console.error(
          "Error al cerrar sesión:",
          error
        );

        process.exitCode = 1;
      }
    }
  }

  // ======================================================
  // RESULTADO FINAL
  // ======================================================

  if (pruebaExitosa && process.exitCode !== 1) {
    console.log("\n========================================");
    console.log("TEST FINALIZADO CORRECTAMENTE");
    console.log("========================================");
  }
}

main().catch((error) => {
  console.error("Error general:", error);
  process.exitCode = 1;
});
