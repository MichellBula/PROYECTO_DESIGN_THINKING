// Entidad de dominio. No depende de React ni del SDK de Roble.
export class Usuario {
  constructor(
    public readonly idUsuario: number,
    public readonly nombreUsuario: string,
    public readonly correoInstitucional: string,
    public readonly carrera: string,
    public readonly semestre: number,
    public readonly idAutenticador: string,
    // null indica que todavía no tiene proyectos.
    public readonly numeroProyectos: number | null = null,
    // null indica que todavía no tiene proyectos calificados.
    public readonly calificacionUsuario: number | null = null
  ) {}
}

export interface CrearUsuarioParams {
  nombreUsuario: string;
  correoInstitucional: string;
  carrera: string;
  semestre: number;
  idAutenticador: string;
}
