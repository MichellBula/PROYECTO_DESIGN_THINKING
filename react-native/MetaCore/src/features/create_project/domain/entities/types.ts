export type RegistroRoble = Record<string, unknown>;

export function parseId(value: unknown, description = "identificador"): number {
  if (value === null || value === undefined || !/^\d+$/.test(String(value).trim())) {
    throw new Error(`${description} inválido: ${String(value)}`);
  }
  const id = Number(value);
  if (!Number.isSafeInteger(id)) throw new Error(`${description} inválido: ${String(value)}`);
  return id;
}
