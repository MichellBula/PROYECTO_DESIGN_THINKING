import { useCallback, useEffect, useRef, useState } from 'react';
import { MAX_ELEMENTS, MAX_HISTORY, MAX_TOTAL_POINTS, type BoardElement } from '../data/board-model';
import { readBoard, writeBoard } from '../data/board-storage';

type History = { past: BoardElement[][]; present: BoardElement[]; future: BoardElement[][] };
const initial: History = { past: [], present: [], future: [] };

/** Historial por operación, no por cada punto del lápiz. */
export function useBoard(projectId: string, roomId: string) {
  const [history, setHistory] = useState<History>(initial);
  const [loaded, setLoaded] = useState(false);
  const [error, setError] = useState('');
  const saveQueue = useRef<Promise<void>>(Promise.resolve());

  useEffect(() => {
    let active = true;
    setLoaded(false);
    void readBoard(projectId, roomId).then(items => {
      if (active) setHistory({ past: [], present: items, future: [] });
    }).catch(() => {
      if (active) setError('No fue posible recuperar el tablero guardado.');
    }).finally(() => { if (active) setLoaded(true); });
    return () => { active = false; };
  }, [projectId, roomId]);

  // Cada modificación finalizada se escribe en orden, evitando sobrescrituras antiguas.
  useEffect(() => {
    if (!loaded) return;
    saveQueue.current = saveQueue.current.then(() => writeBoard(projectId, roomId, history.present));
    saveQueue.current = saveQueue.current.catch(() => setError('No se pudo guardar el tablero en este dispositivo.'));
  }, [history.present, loaded, projectId, roomId]);

  const commit = useCallback((next: BoardElement[]) => {
    const total = next.reduce((sum, item) => sum + (item.type === 'stroke' ? item.points.length : 1), 0);
    if (next.length > MAX_ELEMENTS || total > MAX_TOTAL_POINTS) {
      setError('Este tablero de prueba alcanzó el límite local de elementos o puntos.');
      return;
    }
    setHistory(old => {
      if (JSON.stringify(next) === JSON.stringify(old.present)) return old;
      return { present: next, past: [...old.past, old.present].slice(-MAX_HISTORY), future: [] };
    });
  }, []);
  const undo = useCallback(() => setHistory(old => {
    if (!old.past.length) return old;
    return { past: old.past.slice(0, -1), present: old.past[old.past.length - 1],
      future: [old.present, ...old.future].slice(0, MAX_HISTORY) };
  }), []);
  const redo = useCallback(() => setHistory(old => {
    if (!old.future.length) return old;
    return { past: [...old.past, old.present].slice(-MAX_HISTORY), present: old.future[0],
      future: old.future.slice(1) };
  }), []);

  return { elements: history.present, commit, undo, redo,
    canUndo: history.past.length > 0, canRedo: history.future.length > 0,
    loaded, error, clearError: () => setError('') };
}
