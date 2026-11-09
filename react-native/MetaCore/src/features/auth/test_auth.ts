
import "dotenv/config";

import {
  RobleApiClient,
  RobleApiHttpException,
} from "roble-client";
import { AuthRepository } from "./domain/repositories/auth_repository";
import { AuthRemoteDataSourceImpl } from "./data/datasources/auth_remote_data_source_impl";
import { AuthRepositoryImpl } from "./data/repositories/auth_repository_impl";


// ======================================================
// TIPOS
// ======================================================

type ResultadoPrueba = "OK" | "FALLO" | "OMITIDA";

// Cuando migremos usuario, conectaremos aquí
// la consulta real de su perfil.
type BuscarPerfilUsuario = (
  userId: string
) => Promise<unknown | null>;

// ======================================================
// PRUEBA 1: REGISTRAR UNA CUENTA EXISTENTE
// ======================================================

async function probarCuentaExistente(
  repository: AuthRepository
): Promise<ResultadoPrueba> {
  console.log("\n========================================");
  console.log("PRUEBA 1: CUENTA YA EXISTENTE");
  console.log("========================================");

  const email = process.env.ROBLE_TEST_EXISTING_EMAIL;
  const password = process.env.ROBLE_TEST_EXISTING_PASSWORD;

  if (!email || !password) {
    console.log("OMITIDA: faltan credenciales.");
    return "OMITIDA";
  }

  // Confirmar que la cuenta realmente existe.
  try {
    await repository.login({ email, password });
    await repository.logout();
  } catch (error) {
    console.log(
      "OMITIDA: no se pudo verificar la cuenta existente."
    );
    console.error(error);

    if (repository.estaAutenticado) {
      await repository.logout().catch(() => {});
    }

    return "OMITIDA";
  }

  // Intentar registrar nuevamente el mismo correo.
  try {
    await repository.registrar({
      email,
      password,
      name: "Usuario Duplicado",
    });

    console.error(
      "FALLO: Roble permitió registrar una cuenta existente."
    );

    return "FALLO";
  } catch (error) {
    // Un conflicto HTTP 409 indica un registro duplicado.
    if (
      error instanceof RobleApiHttpException &&
      error.statusCode === 409
    ) {
      console.log(
        "OK: Roble rechazó correctamente la cuenta duplicada."
      );

      return "OK";
    }

    console.error(
      "FALLO: el registro produjo un error diferente."
    );
    console.error(error);

    return "FALLO";
  }
}

// ======================================================
// PRUEBA 2: CREAR CUENTA NUEVA
// ======================================================

async function probarCuentaNueva(
  repository: AuthRepository,
  buscarPerfilUsuario?: BuscarPerfilUsuario
): Promise<ResultadoPrueba> {
  console.log("\n========================================");
  console.log("PRUEBA 2: CUENTA NUEVA SIN PERFIL");
  console.log("========================================");

  if (process.env.ROBLE_TEST_CREATE_USER !== "true") {
    console.log(
      "OMITIDA: habilita ROBLE_TEST_CREATE_USER=true para ejecutarla."
    );

    return "OMITIDA";
  }

  const password = process.env.ROBLE_TEST_NEW_PASSWORD;

  if (!password) {
    console.error(
      "FALLO: falta ROBLE_TEST_NEW_PASSWORD."
    );
    return "FALLO";
  }

  const identificador = Date.now();

  const emailNuevo =
    `registro_sin_perfil_${identificador}@correo.com`;

  const nombreNuevo = "Usuario Sin Perfil";

  let pruebaCorrecta = true;

  try {
    // ======================================================
    // 1. CREAR CUENTA
    // ======================================================

    console.log("\n--- 1. CREAR CUENTA ---");

    await repository.registrar({
      email: emailNuevo,
      password,
      name: nombreNuevo,
    });

    console.log("Registro exitoso: true");
    console.log("Correo creado:", emailNuevo);

    // ======================================================
    // 2. INICIAR SESIÓN
    // ======================================================

    console.log("\n--- 2. INICIAR SESIÓN ---");

    const usuarioAuth = await repository.login({
      email: emailNuevo,
      password,
    });

    console.log("Login exitoso: true");

    console.log("Cuenta autenticada correctamente.");
    console.log("userId:", usuarioAuth.userId);
    console.log("email:", usuarioAuth.email);
    console.log("name:", usuarioAuth.name);

    // ======================================================
    // 3. COMPROBAR AUTENTICACIÓN Y PERFIL
    // ======================================================

    console.log("\n--- 3. COMPROBAR PERFIL ---");

    const estaAutenticado = repository.estaAutenticado;

    console.log("Está autenticado:", estaAutenticado);

    if (!estaAutenticado) {
      console.error(
        "FALLO: no se detectó la sesión autenticada."
      );
      pruebaCorrecta = false;
    }

    if (buscarPerfilUsuario) {
      const perfil = await buscarPerfilUsuario(
        usuarioAuth.userId
      );

      const tienePerfil = perfil !== null;

      const necesitaCompletarPerfil =
        estaAutenticado && !tienePerfil;

      console.log("Tiene perfil:", tienePerfil);

      console.log(
        "Necesita completar perfil:",
        necesitaCompletarPerfil
      );

      if (necesitaCompletarPerfil) {
        console.log(
          "OK: la cuenta existe, pero no tiene perfil."
        );
      } else {
        console.error(
          "FALLO: se esperaba una cuenta sin perfil."
        );
        pruebaCorrecta = false;
      }
    } else {
      console.log(
        "PENDIENTE: falta conectar el repositorio de usuario."
      );
    }

    // ======================================================
    // 4. CERRAR SESIÓN
    // ======================================================

    console.log("\n--- 4. CERRAR SESIÓN ---");

    await repository.logout();

    console.log(
      "Está autenticado después del logout:",
      repository.estaAutenticado
    );

    if (repository.estaAutenticado) {
      console.error(
        "FALLO: la sesión continúa activa."
      );
      pruebaCorrecta = false;
    }

    return pruebaCorrecta ? "OK" : "FALLO";
  } catch (error) {
    console.error("\nERROR EN LA PRUEBA 2:");
    console.error(error);

    return "FALLO";
  } finally {
    // Asegurar que la sesión quede cerrada.
    if (repository.estaAutenticado) {
      try {
        await repository.logout();
      } catch (error) {
        console.error(
          "No se pudo cerrar la sesión de prueba:",
          error
        );
        process.exitCode = 1;
      }
    }
  }
}

// ======================================================
// FUNCIÓN PRINCIPAL
// ======================================================

async function main(): Promise<void> {
  console.log("========================================");
  console.log("PRUEBAS FINALES DE AUTH + USUARIO");
  console.log("========================================");

  const baseUrl =
    process.env.EXPO_PUBLIC_ROBLE_BASE_URL ??
    "https://roble-api.test-openlab.uninorte.edu.co";

  const contractId =
    process.env.EXPO_PUBLIC_ROBLE_CONTRACT_ID;

  if (!contractId) {
    throw new Error(
      "Falta EXPO_PUBLIC_ROBLE_CONTRACT_ID en .env."
    );
  }

  // Crear un cliente para las pruebas de terminal.
  const roble = new RobleApiClient({
    baseUrl,
    contractId,
  });

  // Construir dependencias de autenticación.
  const remoteDataSource = new AuthRemoteDataSourceImpl(
    roble
  );

  const repository = new AuthRepositoryImpl(
    remoteDataSource
  );

  // Ejecutar pruebas.
  const resultado1 = await probarCuentaExistente(
    repository
  );

  const resultado2 = await probarCuentaNueva(
    repository
  );

  console.log("\n========================================");
  console.log("RESUMEN DE PRUEBAS");
  console.log("========================================");

  console.log("Prueba 1:", resultado1);
  console.log("Prueba 2:", resultado2);

  if (resultado1 === "FALLO" || resultado2 === "FALLO") {
    process.exitCode = 1;
  }

  console.log("\nPRUEBAS FINALIZADAS");
}

main().catch((error) => {
  console.error("Error general:", error);
  process.exitCode = 1;
});
