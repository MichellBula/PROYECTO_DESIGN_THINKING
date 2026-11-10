// Reglas puras, independientes de React y del proveedor de datos.
export type GroupMembersResult =
  | { ok: true; memberIds: string[] }
  | { ok: false; message: string };

export function validateGroupMembers(
  leaderId: string,
  availableIds: string[],
  selectedIds: string[],
): GroupMembersResult {
  const available = new Set(availableIds);
  const memberIds = Array.from(new Set([leaderId, ...selectedIds]));

  if (memberIds.some(id => !available.has(id))) {
    return { ok: false, message: 'Solo puedes incluir integrantes del proyecto.' };
  }
  if (memberIds.length < 3) {
    return { ok: false, message: 'El grupo debe tener al líder y al menos otros 2 integrantes.' };
  }
  return { ok: true, memberIds };
}
