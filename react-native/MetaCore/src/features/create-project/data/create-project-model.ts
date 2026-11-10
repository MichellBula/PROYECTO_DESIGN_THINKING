/** Modelo preparado para convertirse después en el request de Roble. */
export type CreateProjectInput = {
  name: string;
  description: string;
  category: string;
  objective: string;
  roleQuantities: Record<string, number>;
  skills: string[];
  requirements: string;
  projectType: string;
  startDate: string | null; // YYYY-MM-DD, inicio de convocatoria
  closingDate: string | null; // YYYY-MM-DD, cierre de convocatoria
  wantsAdvisor: boolean;
};

export type CreateProjectResult =
  | { ok: true; projectId: string }
  | { ok: false; message: string };

export function emptyProjectInput(): CreateProjectInput {
  return {
    name: '', description: '', category: '', objective: '',
    roleQuantities: {}, skills: [], requirements: '', projectType: '',
    startDate: null, closingDate: null, wantsAdvisor: false,
  };
}

// Compara días de calendario sin depender de horas ni diferencias de zona.
export function isoDayNumber(iso: string): number {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(iso);
  if (!match) return Number.NaN;
  const year = Number(match[1]);
  const month = Number(match[2]);
  const day = Number(match[3]);
  const date = new Date(Date.UTC(year, month - 1, day));
  if (date.getUTCFullYear() !== year || date.getUTCMonth() !== month - 1 || date.getUTCDate() !== day) {
    return Number.NaN;
  }
  return date.getTime() / 86400000;
}

export function todayIso(): string {
  const date = new Date();
  const yyyy = date.getFullYear();
  const mm = String(date.getMonth() + 1).padStart(2, '0');
  const dd = String(date.getDate()).padStart(2, '0');
  return `${yyyy}-${mm}-${dd}`;
}

export function addCalendarDays(iso: string, days: number): string {
  const dayNumber = isoDayNumber(iso);
  if (!Number.isFinite(dayNumber)) return iso;
  return new Date((dayNumber + days) * 86400000).toISOString().slice(0, 10);
}

export function validateCreateProject(input: CreateProjectInput): string | null {
  if (!input.name.trim() || input.name.trim().length > 50) {
    return 'El nombre es obligatorio y debe tener máximo 50 caracteres.';
  }
  if (!input.description.trim() || input.description.trim().length > 400) {
    return 'Completa la descripción (máximo 400 caracteres).';
  }
  if (!input.category) return 'Selecciona una categoría.';
  if (!input.objective.trim() || input.objective.trim().length > 300) {
    return 'Completa el objetivo general (máximo 300 caracteres).';
  }
  const counts = Object.values(input.roleQuantities);
  if (counts.length === 0 || counts.some(value => !Number.isInteger(value) || value < 1 || value > 99)) {
    return 'Selecciona al menos un rol e indica entre 1 y 99 personas por rol.';
  }
  if (!input.skills.length) return 'Selecciona al menos una habilidad.';
  if (!input.requirements.trim() || input.requirements.trim().length > 300) {
    return 'Completa los requisitos (máximo 300 caracteres).';
  }
  if (!input.projectType) return 'Selecciona un tipo de proyecto.';
  if (!input.startDate) return 'Selecciona el inicio de la convocatoria.';
  if (!input.closingDate) return 'Selecciona el cierre de la convocatoria.';
  const start = isoDayNumber(input.startDate);
  const end = isoDayNumber(input.closingDate);
  if (!Number.isFinite(start) || !Number.isFinite(end)) return 'Las fechas no son válidas.';
  if (start < isoDayNumber(todayIso())) return 'El inicio no puede ser anterior a hoy.';
  if (start > isoDayNumber('2035-12-24')) return 'El inicio debe permitir al menos 7 días antes de 2036.';
  if (end < start + 7) return 'El cierre debe ser al menos 7 días después del inicio.';
  if (end > isoDayNumber('2035-12-31')) return 'El cierre no puede superar el año 2035.';
  return null;
}
