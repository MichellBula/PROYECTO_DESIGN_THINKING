// Prueba de INTEGRACIÓN REAL: inserta datos en varias tablas Roble.
// Ubicación: src/features/create_project/test_create_project_integration.ts
// Ejecutar desde MetaCore con: node --env-file=.env --import tsx src/features/create_project/test_create_project_integration.ts

import assert from "node:assert/strict";
import { RobleClient } from "../../core/roble/roble_client";
import { CreateProjectCompleteRemoteDatasource } from "./data/datasources/create_project_complete_remote_datasource";
import { RobleIntegranteCreator, RobleUsuarioStatsUpdater } from "./data/datasources/roble_project_support";
import type { CreateProjectRequest } from "./domain/entities/create_project_request";
import { CreateCompleteProject } from "./domain/usecases/create_complete_project";
import { parseId } from "./domain/entities/types";

async function main(): Promise<void> {
  console.log("========================================");
  console.log("TEST REAL - CREAR PROYECTO COMPLETO");
  console.log("========================================");
  console.log("ATENCIÓN: insertará un proyecto, roles, habilidades, convocatoria y líder.");

  const roble = RobleClient.instance;
  let loginIntentado = false;

  try {
    console.log("\n--- LOGIN ---");
    loginIntentado = true;
    await roble.login({
      email: process.env.ROBLE_TEST_EMAIL ?? "prueba@correo.com",
      password: process.env.ROBLE_TEST_PASSWORD ?? "Prueba123!",
    });
    console.log("Login exitoso.");

    const integranteDatasource = new RobleIntegranteCreator(roble);
    const statsService = new RobleUsuarioStatsUpdater(roble);

    // Comprobar antes de insertar que el esquema de integrantes es reconocible.
    console.log("\n--- COMPROBACIÓN PREVIA ---");
    await integranteDatasource.preflight();

    const categorias = await roble.read("categoria");
    const tipos = await roble.read("tipo_proyecto");
    const roles = await roble.read("rol");
    const habilidades = await roble.read("habilidad");
    const incluye = (rows: Record<string, unknown>[], field: string, nombre: string) =>
      rows.some(row => String(row[field] ?? "").trim().toLowerCase() === nombre.toLowerCase());

    assert.ok(incluye(categorias, "nombre_categoria", "Tecnología"), "Falta categoría Tecnología");
    assert.ok(incluye(tipos, "nombre_tipo_proyecto", "Investigación"), "Falta tipo Investigación");
    assert.ok(incluye(roles, "nombre_rol", "Desarrollador"), "Falta rol Desarrollador");
    assert.ok(incluye(habilidades, "nombre_habilidad", "Programación"), "Falta habilidad Programación");
    console.log("Catálogos e integrantes disponibles.");

    const hoy = new Date();
    const inicio = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate() + 1);
    const cierre = new Date(hoy.getFullYear(), hoy.getMonth(), hoy.getDate() + 15);
    const request: CreateProjectRequest = {
      nombreProyecto: `MetaCore Prueba TS ${Date.now()}`,
      descripcion: "Proyecto de prueba de integración entre TypeScript y Roble.",
      objetivo: "Verificar la creación completa desde React Native / Node.",
      categoria: "Tecnología",
      tipoProyecto: "Investigación",
      roles: ["Desarrollador"],
      cantidadesPorRol: { Desarrollador: 2 },
      habilidades: ["Programación"],
      requisitos: "Conocimientos básicos de TypeScript.",
      fechaInicio: inicio,
      fechaCierre: cierre,
      deseaDocente: false,
    };

    const datasource = new CreateProjectCompleteRemoteDatasource(
      roble, integranteDatasource, statsService
    );
    const crear = new CreateCompleteProject(datasource);

    console.log("\n--- CREANDO PROYECTO REAL ---");
    const resultado = await crear.execute(request);
    const idProyecto = parseId(resultado.id_proyecto, "id_proyecto");
    console.log("Proyecto creado:", request.nombreProyecto);
    console.log("id_proyecto:", idProyecto);

    console.log("\n--- VALIDANDO REGISTROS EN ROBLE ---");
    const [proyectos, rolesProyecto, habilidadesProyecto, convocatorias, integrantes] = await Promise.all([
      roble.read("proyecto", { id_proyecto: idProyecto }),
      roble.read("proyecto_roles", { id_proyecto: idProyecto }),
      roble.read("proyecto_habilidades", { id_proyecto: idProyecto }),
      roble.read("convocatoria", { id_proyecto: idProyecto }),
      roble.read("integrantes", { id_proyecto: idProyecto }),
    ]);

    assert.equal(proyectos.length, 1, "El proyecto no se encontró exactamente una vez");
    assert.equal(String(proyectos[0].nombre), request.nombreProyecto);
    assert.ok(rolesProyecto.length >= 1, "No se guardó el rol del proyecto");
    assert.ok(habilidadesProyecto.length >= 1, "No se guardó la habilidad del proyecto");
    assert.ok(convocatorias.length >= 1, "No se creó la convocatoria");
    assert.ok(integrantes.some((row: Record<string, unknown>) => String(row.id_rol) === "1"), "El creador no se agregó como líder");

    console.log("Proyecto:", proyectos.length);
    console.log("Roles:", rolesProyecto.length);
    console.log("Habilidades:", habilidadesProyecto.length);
    console.log("Convocatorias:", convocatorias.length);
    console.log("Integrantes:", integrantes.length);
    console.log("\n========================================");
    console.log("TEST REAL FINALIZADO CORRECTAMENTE");
    console.log("========================================");
    console.log("El proyecto permanecerá en Roble. No se eliminó ningún registro.");
  } catch (error) {
    console.error("\nERROR EN TEST DE CREACIÓN REAL:", error);
    console.error("IMPORTANTE: si la inserción empezó, pueden quedar datos parciales. Revisa Roble antes de repetir.");
    process.exitCode = 1;
  } finally {
    if (loginIntentado) {
      try { await roble.logout(); console.log("Logout exitoso."); }
      catch (error) { console.error("Error cerrando sesión:", error); process.exitCode = 1; }
    }
  }
}

void main().catch(error => { console.error(error); process.exitCode = 1; });
