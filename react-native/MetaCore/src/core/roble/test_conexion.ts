
import "dotenv/config";
import { RobleApiClient } from "roble-client";

async function probarConexion(): Promise<void> {
  console.log("========================================");
  console.log("PRUEBA DE CONEXIÓN CON ROBLE");
  console.log("========================================");

  const baseUrl =
    process.env.EXPO_PUBLIC_ROBLE_BASE_URL ??
    "https://roble-api.test-openlab.uninorte.edu.co";

  const contractId = process.env.EXPO_PUBLIC_ROBLE_CONTRACT_ID;
  const email = process.env.ROBLE_SEED_EMAIL;
  const password = process.env.ROBLE_SEED_PASSWORD;

  if (!contractId || !email || !password) {
    console.error("Faltan variables en el archivo .env");
    process.exitCode = 1;
    return;
  }

  const roble = new RobleApiClient({
    baseUrl,
    contractId,
  });

  let sesionIniciada = false;

  try {
    // 1. Probar autenticación
    console.log("\n[1] Intentando iniciar sesión...");

    const usuario = await roble.login({
      email,
      password,
    });

    sesionIniciada = true;

    console.log("✅ Conexión y login exitosos");
    console.log("Usuario:", usuario.name);
    console.log("Correo:", usuario.email);

    // 2. Probar lectura de la base de datos
    console.log("\n[2] Consultando tabla categoria...");

    const categorias = await roble.read("categoria");

    console.log("✅ Consulta realizada correctamente");
    console.log("Categorías encontradas:", categorias.length);

    if (categorias.length > 0) {
      console.log("Primera categoría:", categorias[0]);
    } else {
      console.log("La tabla está vacía.");
    }

    console.log("\n========================================");
    console.log("✅ PRUEBA FINALIZADA CORRECTAMENTE");
    console.log("========================================");

  } catch (error) {
    console.error("\n❌ ERROR EN LA PRUEBA:");
    console.error(error);
    process.exitCode = 1;

  } finally {
    if (sesionIniciada) {
      try {
        await roble.logout();
        console.log("\nSesión cerrada correctamente.");
      } catch (error) {
        console.error("Error al cerrar sesión:", error);
        process.exitCode = 1;
      }
    }
  }
}

probarConexion();
