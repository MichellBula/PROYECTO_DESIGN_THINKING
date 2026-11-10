import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { CreateProjectController } from "../controllers/create_project_controller";
import type { CreateProjectRequest } from "../domain/entities/create_project_request";

const request: CreateProjectRequest = {
  nombreProyecto: "Test", descripcion: "Desc", objetivo: "Obj",
  categoria: "Cat", tipoProyecto: "Tipo", roles: ["Programador"],
  cantidadesPorRol: { Programador: 1 }, habilidades: ["Java"],
  requisitos: "Req", fechaInicio: new Date(),
  fechaCierre: new Date(Date.now() + 10 * 86400000), deseaDocente: false,
};

describe("Pruebas unitarias - CreateProjectController", () => {
  it("retorna true al publicar exitosamente", async () => {
    let llamadas = 0;
    const controller = new CreateProjectController({
      execute: async (recibido) => {
        assert.equal(recibido, request);
        llamadas++;
        return { id: "123", status: "ok" };
      },
    });
    const resultado = await controller.publicarProyecto(request);
    assert.equal(resultado, true);
    assert.equal(controller.cargando, false);
    assert.equal(llamadas, 1);
  });

  it("retorna false si Roble falla y libera el estado cargando", async () => {
    const controller = new CreateProjectController({
      execute: async () => { throw new Error("Error de red"); },
    });
    const resultado = await controller.publicarProyecto(request);
    assert.equal(resultado, false);
    assert.equal(controller.cargando, false);
  });
});
