
import "dotenv/config";

import { RobleApiClient } from "roble-client";

import { AuthRemoteDataSourceImpl } from "./data/datasources/auth_remote_data_source_impl";

import { AuthRepositoryImpl } from "./data/repositories/auth_repository_impl";

// ======================================================
// PRUEBA DE AUTENTICACIÓN CON ROBLE
// ======================================================

async function probarAuth(): Promise<void> {
  console.log("========================================");
  console.log("PRUEBAS DE AUTENTICACIÓN - ROBLE");
  console.log("========================================");

  // ======================================================
  // CONFIGURACIÓN
  // ======================================================

  const baseUrl =
    process.env.EXPO_PUBLIC_ROBLE_BASE_URL ??
    "https://roble-api.test-openlab.uninorte.edu.co";

  const contractId =
    process.env.EXPO_PUBLIC_ROBLE_CONTRACT_ID;

  const email =
    process.env.ROBLE_TEST_EXISTING_EMAIL ??
    process.env.ROBLE_SEED_EMAIL;

  const password =
    process.env.ROBLE_TEST_EXISTING_PASSWORD ??
    process.env.ROBLE_SEED_PASSWORD;

  if (!contractId || !email || !password) {
    throw new Error(
      "Faltan variables de configuración en .env"
    );
  }

  // ======================================================
  // CREAR DEPENDENCIAS
  // ======================================================

  const roble = new RobleApiClient({
    baseUrl,
    contractId,
  });

  const dataSource = new AuthRemoteDataSourceImpl(
    roble
  );

  const repository = new AuthRepositoryImpl(
    dataSource
  );

  try {
    // ======================================================
    // PRUEBA 1: INICIAR SESIÓN
    // ======================================================

    console.log("\n--- PRUEBA 1: LOGIN ---");

    const usuario = await repository.login({
      email,
      password,
    });

    if (!usuario || !usuario.userId) {
      throw new Error(
        "No se obtuvo un usuario válido."
      );
    }

    console.log("✅ Login exitoso");
    console.log("userId:", usuario.userId);
    console.log("email:", usuario.email);
    console.log("name:", usuario.name);

    // ======================================================
    // PRUEBA 2: ESTADO DE AUTENTICACIÓN
    // ======================================================

    console.log("\n--- PRUEBA 2: ESTADO DE SESIÓN ---");

    if (!repository.estaAutenticado) {
      throw new Error(
        "Roble no reconoce la sesión como activa."
      );
    }

    console.log("✅ El usuario está autenticado.");

    // ======================================================
    // PRUEBA 3: OBTENER USUARIO ACTUAL
    // ======================================================

    console.log("\n--- PRUEBA 3: USUARIO ACTUAL ---");

    const usuarioActual =
      await repository.obtenerUsuarioActual();

    if (usuarioActual === null) {
      throw new Error(
        "No se pudo recuperar el usuario actual."
      );
    }

    if (usuarioActual.userId !== usuario.userId) {
      throw new Error(
        "El usuario recuperado no coincide con el autenticado."
      );
    }

    console.log("✅ Usuario recuperado correctamente.");
    console.log("userId:", usuarioActual.userId);
    console.log("email:", usuarioActual.email);

    // ======================================================
    // PRUEBA 4: CERRAR SESIÓN
    // ======================================================

    console.log("\n--- PRUEBA 4: LOGOUT ---");

    await repository.logout();

    if (repository.estaAutenticado) {
      throw new Error(
        "La sesión continúa activa después del logout."
      );
    }

    const usuarioDespuesLogout =
      await repository.obtenerUsuarioActual();

    if (usuarioDespuesLogout !== null) {
      throw new Error(
        "Todavía existe un usuario autenticado."
      );
    }

    console.log("✅ Sesión cerrada correctamente.");

    // ======================================================
    // RESULTADO FINAL
    // ======================================================

    console.log("\n========================================");
    console.log("✅ TODAS LAS PRUEBAS DE AUTH PASARON");
    console.log("========================================");

  } catch (error) {
    console.error("\n========================================");
    console.error("❌ ERROR EN LAS PRUEBAS DE AUTH");
    console.error("========================================");

    console.error(error);
    process.exitCode = 1;

  } finally {
    // Asegurar el cierre de sesión.
    if (repository.estaAutenticado) {
      try {
        await repository.logout();
      } catch (error) {
        console.error(
          "Error al cerrar sesión:",
          error
        );
        process.exitCode = 1;
      }
    }
  }
}

probarAuth().catch((error) => {
  console.error("Error general:", error);
  process.exitCode = 1;
});
