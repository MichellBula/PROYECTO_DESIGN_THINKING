import { describe, it } from "node:test";
import assert from "node:assert/strict";
import { ProjectDetailsController } from "../controllers/project_details_controller";

function nuevo(): ProjectDetailsController { return new ProjectDetailsController(); }
function conObjetivo(): ProjectDetailsController {
  const c = nuevo(); c.objetivo = "Mi objetivo"; return c;
}
function conRoles(): ProjectDetailsController {
  const c = conObjetivo(); c.actualizarRoles({ Programador: 1 }); return c;
}
function conHabilidades(): ProjectDetailsController {
  const c = conRoles(); c.actualizarHabilidades(["Java"]); return c;
}
function conRequisitos(): ProjectDetailsController {
  const c = conHabilidades(); c.requisitos = "Requisitos de prueba"; return c;
}
function conTipo(): ProjectDetailsController {
  const c = conRequisitos(); c.cambiarTipoProyecto("Investigación"); return c;
}

describe("Pruebas unitarias - ProjectDetailsController.validate", () => {
  it("error cuando objetivo vacío", () => {
    assert.equal(nuevo().validate(), "Debes completar el objetivo general.");
  });
  it("error cuando no hay roles", () => {
    assert.equal(conObjetivo().validate(), "Debes seleccionar al menos un rol.");
  });
  it("error cuando no hay habilidades", () => {
    assert.equal(conRoles().validate(), "Debes seleccionar al menos una habilidad.");
  });
  it("error cuando no hay requisitos", () => {
    assert.equal(conHabilidades().validate(), "Debes completar los requisitos.");
  });
  it("error cuando falta tipo", () => {
    assert.equal(conRequisitos().validate(), "Debes seleccionar el tipo de proyecto.");
  });
  it("error cuando falta fecha de inicio", () => {
    assert.equal(conTipo().validate(), "Debes seleccionar la fecha de inicio.");
  });
  it("retorna null cuando todo es válido", () => {
    const controller = conTipo();
    const inicio = new Date();
    const cierre = new Date(inicio);
    cierre.setDate(cierre.getDate() + 10);
    controller.setFechaInicio(inicio);
    controller.setFechaCierre(cierre);
    assert.equal(controller.validate(), null);
  });
});
