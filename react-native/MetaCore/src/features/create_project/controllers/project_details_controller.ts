// Controlador de estado/validaciones portable a React Native.
export class ProjectDetailsController {
  objetivo = "";
  requisitos = "";
  roleQuantities: Record<string, number> = {};
  selectedSkills: string[] = [];
  selectedProjectType: string | null = null;
  fechaInicio: Date | null = null;
  fechaCierre: Date | null = null;
  deseaDocente = false;

  get selectedRoles(): string[] {
    return Object.entries(this.roleQuantities)
      .filter(([, cantidad]) => cantidad > 0).map(([nombre]) => nombre);
  }

  actualizarRoles(values: Record<string, number>): void {
    this.roleQuantities = { ...values };
  }
  actualizarHabilidades(values: string[]): void {
    this.selectedSkills = [...values];
  }
  cambiarTipoProyecto(value: string | null): void {
    this.selectedProjectType = value;
  }
  cambiarDocente(value: boolean): void { this.deseaDocente = value; }

  get today(): Date {
    const now = new Date();
    return new Date(now.getFullYear(), now.getMonth(), now.getDate());
  }
  get minimumClosingDate(): Date {
    if (!this.fechaInicio) throw new Error("Primero selecciona fecha de inicio.");
    const fecha = new Date(this.fechaInicio);
    fecha.setDate(fecha.getDate() + 7);
    return fecha;
  }
  setFechaInicio(value: Date): void {
    this.fechaInicio = new Date(value);
    if (this.fechaCierre && this.fechaCierre < this.minimumClosingDate) {
      this.fechaCierre = null;
    }
  }
  setFechaCierre(value: Date): void { this.fechaCierre = new Date(value); }

  limpiarFormulario(): void {
    this.objetivo = "";
    this.requisitos = "";
    this.roleQuantities = {};
    this.selectedSkills = [];
    this.selectedProjectType = null;
    this.fechaInicio = null;
    this.fechaCierre = null;
    this.deseaDocente = false;
  }

  validate(): string | null {
    if (!this.objetivo.trim()) return "Debes completar el objetivo general.";
    if (Object.keys(this.roleQuantities).length === 0) return "Debes seleccionar al menos un rol.";
    for (const [rol, cantidad] of Object.entries(this.roleQuantities)) {
      if (cantidad <= 0) return `Debes indicar al menos 1 integrante para "${rol}".`;
    }
    if (this.selectedSkills.length === 0) return "Debes seleccionar al menos una habilidad.";
    if (!this.requisitos.trim()) return "Debes completar los requisitos.";
    if (this.selectedProjectType === null) return "Debes seleccionar el tipo de proyecto.";
    if (!this.fechaInicio) return "Debes seleccionar la fecha de inicio.";
    if (!this.fechaCierre) return "Debes seleccionar la fecha de cierre.";
    if (this.fechaInicio < this.today) return "La fecha de inicio no puede ser anterior a hoy.";
    if (this.fechaCierre < this.minimumClosingDate) {
      return "La fecha de cierre debe ser mínimo 7 días después de la fecha de inicio.";
    }
    return null;
  }
}
