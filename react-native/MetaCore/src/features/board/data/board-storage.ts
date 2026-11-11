import AsyncStorage from '@react-native-async-storage/async-storage';
import { MAX_ELEMENTS, MAX_TOTAL_POINTS, validBoardElement, type BoardElement } from './board-model';

// Una clave independiente por proyecto y por conversación grupal.
export function boardStorageKey(projectId: string, roomId: string) {
  return `@metacore/board/v1/${encodeURIComponent(projectId)}/${encodeURIComponent(roomId)}`;
}

export async function readBoard(projectId: string, roomId: string): Promise<BoardElement[]> {
  const raw = await AsyncStorage.getItem(boardStorageKey(projectId, roomId));
  if (!raw) return [];
  const parsed: unknown = JSON.parse(raw);
  if (!parsed || typeof parsed !== 'object') return [];
  const elements = (parsed as { version?: number; elements?: unknown }).elements;
  return Array.isArray(elements) && elements.length <= MAX_ELEMENTS && elements.every(validBoardElement)
    && elements.reduce((sum: number, item: BoardElement) => sum + (item.type === 'stroke' ? item.points.length : 1), 0) <= MAX_TOTAL_POINTS
    ? elements : [];
}

export async function writeBoard(projectId: string, roomId: string, elements: BoardElement[]) {
  await AsyncStorage.setItem(boardStorageKey(projectId, roomId), JSON.stringify({ version: 1, elements }));
}

export async function removeBoard(projectId: string, roomId: string) {
  await AsyncStorage.removeItem(boardStorageKey(projectId, roomId));
}
