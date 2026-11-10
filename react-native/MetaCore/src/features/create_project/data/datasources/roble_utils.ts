import type { RobleApiClient } from "roble-client";
import type { RegistroRoble } from "../../domain/entities/types";
import { parseId } from "../../domain/entities/types";

export async function nextId(roble: RobleApiClient, tabla: string, campo: string): Promise<number> {
  const rows = await roble.read(tabla);
  let maxId = 0;
  for (const row of rows) {
    try { maxId = Math.max(maxId, parseId(row[campo])); } catch { /* fila inválida */ }
  }
  return maxId + 1;
}

export async function firstRow(
  roble: RobleApiClient, tabla: string, filtro: RegistroRoble
): Promise<RegistroRoble | null> {
  const rows = await roble.read(tabla, filtro);
  return rows.length ? { ...rows[0] } : null;
}
