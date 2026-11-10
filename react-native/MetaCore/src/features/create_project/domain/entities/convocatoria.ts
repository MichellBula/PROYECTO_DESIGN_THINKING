export class Convocatoria {
  constructor(
    public readonly idProyecto: number,
    public readonly fechaInicio: Date,
    public readonly fechaFinal: Date,
    public readonly estado: boolean,
    public readonly fechaLimiteDeAbandono: Date | null
  ) {}
}
