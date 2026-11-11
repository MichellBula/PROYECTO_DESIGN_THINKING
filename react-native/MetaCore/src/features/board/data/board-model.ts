/** Modelo serializable de la pizarra. Escala y rotación son opcionales para abrir tableros antiguos. */
export const BOARD_WIDTH = 1600;
export const BOARD_HEIGHT = 1200;
export const MAX_ELEMENTS = 400;
export const MAX_POINTS_PER_STROKE = 1800;
export const MAX_TOTAL_POINTS = 18000;
export const MAX_HISTORY = 50;

export type Point = { x: number; y: number };
export type Brush = 'pen' | 'marker' | 'highlighter';
export type ShapeKind = 'rectangle' | 'ellipse' | 'triangle' | 'line' | 'arrow' | 'curve' | 'star';
export type BoardTool = 'select' | 'hand' | Brush | ShapeKind | 'text' | 'eraser';
export type Transform = { rotation?: number; scale?: number };
export type BoardElement =
  | ({ id: string; type: 'stroke'; brush: Brush; points: Point[]; color: string; size: number; opacity: number } & Transform)
  | ({ id: string; type: 'shape'; shape: ShapeKind; start: Point; end: Point; color: string; size: number; opacity: number } & Transform)
  | ({ id: string; type: 'text'; position: Point; text: string; color: string; fontSize: number; opacity: number } & Transform);

export type Viewport = { x: number; y: number; zoom: number };
export type Bounds = { x: number; y: number; width: number; height: number };

export function newBoardId() {
  return `item-${Date.now()}-${Math.random().toString(36).slice(2, 9)}`;
}
export const clamp = (value: number, min: number, max: number) => Math.max(min, Math.min(max, value));
export const clampPoint = (p: Point): Point => ({
  x: clamp(p.x, 0, BOARD_WIDTH), y: clamp(p.y, 0, BOARD_HEIGHT),
});

export function applyViewport(view: Viewport, width: number, height: number): Viewport {
  const zoom = clamp(view.zoom, 0.5, 3);
  return {
    zoom,
    x: clamp(view.x, 0, Math.max(0, BOARD_WIDTH - width / zoom)),
    y: clamp(view.y, 0, Math.max(0, BOARD_HEIGHT - height / zoom)),
  };
}

export function screenToWorld(screen: Point, view: Viewport): Point {
  return clampPoint({ x: view.x + screen.x / view.zoom, y: view.y + screen.y / view.zoom });
}

export function changeZoom(view: Viewport, nextZoom: number, width: number, height: number) {
  const zoom = clamp(nextZoom, 0.5, 3);
  const centerX = view.x + width / (2 * view.zoom);
  const centerY = view.y + height / (2 * view.zoom);
  return applyViewport({ x: centerX - width / (2 * zoom), y: centerY - height / (2 * zoom), zoom }, width, height);
}

export function translateElement(item: BoardElement, dx: number, dy: number): BoardElement {
  if (item.type === 'stroke') {
    return { ...item, points: item.points.map(p => clampPoint({ x: p.x + dx, y: p.y + dy })) };
  }
  if (item.type === 'shape') {
    return { ...item, start: clampPoint({ x: item.start.x + dx, y: item.start.y + dy }),
      end: clampPoint({ x: item.end.x + dx, y: item.end.y + dy }) };
  }
  return { ...item, position: clampPoint({ x: item.position.x + dx, y: item.position.y + dy }) };
}

/** Punto de control único para una curva cuadrática ligeramente arqueada. */
export function curveControl(start: Point, end: Point): Point {
  const dx = end.x - start.x;
  const dy = end.y - start.y;
  return { x: (start.x + end.x) / 2 - dy * 0.3,
    y: (start.y + end.y) / 2 + dx * 0.3 };
}

export function starPoints(start: Point, end: Point): Point[] {
  const cx = (start.x + end.x) / 2;
  const cy = (start.y + end.y) / 2;
  const rx = Math.abs(end.x - start.x) / 2;
  const ry = Math.abs(end.y - start.y) / 2;
  return Array.from({ length: 10 }, (_, i) => {
    const angle = -Math.PI / 2 + i * Math.PI / 5;
    const factor = i % 2 === 0 ? 1 : 0.43;
    return { x: cx + Math.cos(angle) * rx * factor,
      y: cy + Math.sin(angle) * ry * factor };
  });
}

export function elementBounds(item: BoardElement): Bounds {
  if (item.type === 'stroke') {
    const xs = item.points.map(p => p.x), ys = item.points.map(p => p.y);
    const x = Math.min(...xs), y = Math.min(...ys);
    return { x, y, width: Math.max(...xs) - x, height: Math.max(...ys) - y };
  }
  if (item.type === 'text') {
    const lines = item.text.split('\n');
    const width = Math.min(650, Math.max(30, ...lines.map(line => line.length * item.fontSize * 0.6)));
    return { x: item.position.x, y: item.position.y - item.fontSize,
      width, height: Math.max(item.fontSize, item.fontSize * (1 + (lines.length - 1) * 1.2)) };
  }
  const points = item.shape === 'curve'
    ? [item.start, item.end, curveControl(item.start, item.end)]
    : [item.start, item.end];
  const xs = points.map(p => p.x), ys = points.map(p => p.y);
  const x = Math.min(...xs), y = Math.min(...ys);
  return { x, y, width: Math.max(...xs) - x, height: Math.max(...ys) - y };
}

export function elementCenter(item: BoardElement): Point {
  const bounds = elementBounds(item);
  return { x: bounds.x + bounds.width / 2, y: bounds.y + bounds.height / 2 };
}

/** Transformación aplicada a SVG, alrededor del centro de cada elemento. */
export function elementTransform(item: BoardElement): string {
  const { x, y } = elementCenter(item);
  return `translate(${x} ${y}) rotate(${item.rotation ?? 0}) scale(${item.scale ?? 1}) translate(${-x} ${-y})`;
}

/** Devuelve la coordenada original antes de escalar y rotar. */
export function inverseElementPoint(point: Point, item: BoardElement): Point {
  const center = elementCenter(item);
  const angle = -(item.rotation ?? 0) * Math.PI / 180;
  const scale = item.scale ?? 1;
  const dx = point.x - center.x;
  const dy = point.y - center.y;
  return {
    x: center.x + (dx * Math.cos(angle) - dy * Math.sin(angle)) / scale,
    y: center.y + (dx * Math.sin(angle) + dy * Math.cos(angle)) / scale,
  };
}

export function resizeElement(item: BoardElement, factor: number): BoardElement {
  return { ...item, scale: Math.round(clamp((item.scale ?? 1) * factor, 0.25, 4) * 100) / 100 };
}

export function rotateElement(item: BoardElement, degrees: number): BoardElement {
  const next = ((item.rotation ?? 0) + degrees) % 360;
  return { ...item, rotation: next < 0 ? next + 360 : next };
}

export function duplicateElement(item: BoardElement): BoardElement {
  return translateElement({ ...item, id: newBoardId() }, 28, 28);
}

function distanceToSegment(p: Point, a: Point, b: Point): number {
  const dx = b.x - a.x, dy = b.y - a.y;
  const len2 = dx * dx + dy * dy;
  const t = len2 ? clamp(((p.x - a.x) * dx + (p.y - a.y) * dy) / len2, 0, 1) : 0;
  return Math.hypot(p.x - (a.x + t * dx), p.y - (a.y + t * dy));
}

function quadraticAt(start: Point, control: Point, end: Point, t: number): Point {
  const a = (1 - t) * (1 - t), b = 2 * (1 - t) * t, c = t * t;
  return { x: a * start.x + b * control.x + c * end.x,
    y: a * start.y + b * control.y + c * end.y };
}

/** Hit testing conoce las transformaciones y las nuevas figuras. */
export function hitTest(items: BoardElement[], point: Point, tolerance = 15): BoardElement | null {
  for (let i = items.length - 1; i >= 0; i--) {
    const item = items[i];
    const local = inverseElementPoint(point, item);
    const hitTolerance = tolerance / (item.scale ?? 1);
    if (item.type === 'text') {
      const b = elementBounds(item);
      if (local.x >= b.x - hitTolerance && local.x <= b.x + b.width + hitTolerance &&
        local.y >= b.y - hitTolerance && local.y <= b.y + b.height + hitTolerance) return item;
    } else if (item.type === 'stroke') {
      if (item.points.length === 1 && Math.hypot(local.x - item.points[0].x, local.y - item.points[0].y) < hitTolerance + item.size / 2) return item;
      for (let j = 1; j < item.points.length; j++) {
        if (distanceToSegment(local, item.points[j - 1], item.points[j]) <= hitTolerance + item.size / 2) return item;
      }
    } else if (item.shape === 'line' || item.shape === 'arrow') {
      if (distanceToSegment(local, item.start, item.end) <= hitTolerance + item.size / 2) return item;
    } else if (item.shape === 'curve') {
      const control = curveControl(item.start, item.end);
      let previous = item.start;
      for (let step = 1; step <= 24; step++) {
        const next = quadraticAt(item.start, control, item.end, step / 24);
        if (distanceToSegment(local, previous, next) <= hitTolerance + item.size / 2) return item;
        previous = next;
      }
    } else {
      const b = elementBounds(item);
      if (local.x >= b.x - hitTolerance && local.x <= b.x + b.width + hitTolerance &&
        local.y >= b.y - hitTolerance && local.y <= b.y + b.height + hitTolerance) return item;
    }
  }
  return null;
}

export function isValidHex(value: string): boolean { return /^#[\da-fA-F]{6}$/.test(value); }
export function rgbToHex(r: number, g: number, b: number): string {
  return `#${[r, g, b].map(n => clamp(Math.round(n), 0, 255).toString(16).padStart(2, '0')).join('')}`.toUpperCase();
}
export function hslToHex(h: number, s: number, l: number) {
  const a = s * Math.min(l, 1 - l);
  const f = (n: number) => {
    const k = (n + h / 30) % 12;
    return 255 * (l - a * Math.max(-1, Math.min(k - 3, 9 - k, 1)));
  };
  return rgbToHex(f(0), f(8), f(4));
}

export function validBoardElement(value: unknown): value is BoardElement {
  if (!value || typeof value !== 'object') return false;
  const obj = value as Record<string, unknown>;
  if (typeof obj.id !== 'string' || typeof obj.color !== 'string' || !isValidHex(obj.color)
    || typeof obj.opacity !== 'number' || !Number.isFinite(obj.opacity)
    || obj.opacity < 0 || obj.opacity > 1) return false;
  if (obj.rotation !== undefined && (typeof obj.rotation !== 'number' || !Number.isFinite(obj.rotation)
    || obj.rotation < 0 || obj.rotation >= 360)) return false;
  if (obj.scale !== undefined && (typeof obj.scale !== 'number' || !Number.isFinite(obj.scale)
    || obj.scale < 0.25 || obj.scale > 4)) return false;
  const validPoint = (p: unknown): p is Point => {
    if (!p || typeof p !== 'object') return false;
    const v = p as Record<string, unknown>;
    return typeof v.x === 'number' && Number.isFinite(v.x)
      && typeof v.y === 'number' && Number.isFinite(v.y);
  };
  if (obj.type === 'stroke') {
    return (obj.brush === 'pen' || obj.brush === 'marker' || obj.brush === 'highlighter')
      && typeof obj.size === 'number' && obj.size > 0 && obj.size <= 200
      && Array.isArray(obj.points) && obj.points.length > 0
      && obj.points.length <= MAX_POINTS_PER_STROKE && obj.points.every(validPoint);
  }
  if (obj.type === 'shape') {
    return ['rectangle', 'ellipse', 'triangle', 'line', 'arrow', 'curve', 'star'].includes(obj.shape as string)
      && typeof obj.size === 'number' && obj.size > 0 && obj.size <= 200
      && validPoint(obj.start) && validPoint(obj.end);
  }
  if (obj.type === 'text') {
    return typeof obj.text === 'string' && obj.text.length > 0 && obj.text.length <= 300
      && typeof obj.fontSize === 'number' && obj.fontSize >= 4 && obj.fontSize <= 100
      && validPoint(obj.position);
  }
  return false;
}
