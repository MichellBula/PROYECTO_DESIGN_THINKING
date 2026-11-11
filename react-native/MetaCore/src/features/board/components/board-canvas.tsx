import { useMemo, useRef, useState } from 'react';
import { PanResponder, StyleSheet, View, type LayoutChangeEvent } from 'react-native';
import Svg, { Circle, Defs, Ellipse, G, Line, Path, Pattern, Polygon, Rect, Text as SvgText, TSpan } from 'react-native-svg';
import {
  BOARD_HEIGHT, BOARD_WIDTH, MAX_POINTS_PER_STROKE, applyViewport,
  curveControl, elementBounds, elementTransform, hitTest, newBoardId, screenToWorld, starPoints, translateElement,
  type BoardElement, type BoardTool, type Point, type ShapeKind, type Viewport,
} from '../data/board-model';

type Props = {
  elements: BoardElement[];
  onCommit: (elements: BoardElement[]) => void;
  tool: BoardTool;
  color: string;
  brushSize: number;
  viewport: Viewport;
  onViewportChange: (next: Viewport) => void;
  selectedId: string | null;
  onSelect: (id: string | null) => void;
  onTextRequest: (position: Point) => void;
  onCanvasSize: (width: number, height: number) => void;
};

type Interaction = {
  start: Point;
  startView: Viewport;
  original?: BoardElement;
  mode: BoardTool;
};

function BoardMark({ item, active = false }: { item: BoardElement; active?: boolean }) {
  const stroke = item.color;
  if (item.type === 'stroke') {
    if (item.points.length === 1) return <Circle cx={item.points[0].x} cy={item.points[0].y}
      r={Math.max(item.size / 2, 2)} fill={stroke} opacity={item.opacity} />;
    const d = item.points.map((p, index) => `${index ? 'L' : 'M'}${p.x} ${p.y}`).join(' ');
    return <Path d={d} fill="none" stroke={stroke} strokeWidth={item.size}
      strokeLinecap="round" strokeLinejoin="round" opacity={item.opacity} />;
  }
  if (item.type === 'text') {
    const lines = item.text.split('\n');
    return <SvgText x={item.position.x} y={item.position.y} fontSize={item.fontSize}
      fontWeight={active ? 'bold' : 'normal'} fill={stroke} opacity={item.opacity}>
      {lines.map((line, i) => <TSpan key={i} x={item.position.x} dy={i ? item.fontSize * 1.2 : 0}>{line}</TSpan>)}
    </SvgText>;
  }
  const { start, end, shape, size, opacity } = item;
  const x = Math.min(start.x, end.x); const y = Math.min(start.y, end.y);
  const w = Math.abs(end.x - start.x); const h = Math.abs(end.y - start.y);
  const common = { stroke, strokeWidth: size, opacity, fill: 'none' as const };
  if (shape === 'rectangle') return <Rect x={x} y={y} width={w} height={h} rx={2} {...common} />;
  if (shape === 'ellipse') return <Ellipse cx={x + w / 2} cy={y + h / 2} rx={w / 2} ry={h / 2} {...common} />;
  if (shape === 'triangle') return <Polygon points={`${x + w / 2},${y} ${x + w},${y + h} ${x},${y + h}`} {...common} />;
  if (shape === 'star') return <Polygon points={starPoints(start, end).map(p => `${p.x},${p.y}`).join(' ')} {...common} />;
  if (shape === 'curve') {
    const control = curveControl(start, end);
    return <Path d={`M ${start.x} ${start.y} Q ${control.x} ${control.y} ${end.x} ${end.y}`}
      strokeLinecap="round" {...common} />;
  }
  if (shape === 'arrow') {
    const angle = Math.atan2(end.y - start.y, end.x - start.x);
    const headLength = Math.max(12, size * 5);
    const left = { x: end.x - headLength * Math.cos(angle - Math.PI / 6),
      y: end.y - headLength * Math.sin(angle - Math.PI / 6) };
    const right = { x: end.x - headLength * Math.cos(angle + Math.PI / 6),
      y: end.y - headLength * Math.sin(angle + Math.PI / 6) };
    return <G>
      <Line x1={start.x} y1={start.y} x2={end.x} y2={end.y} {...common} />
      <Path d={`M ${left.x} ${left.y} L ${end.x} ${end.y} L ${right.x} ${right.y}`}
        strokeLinecap="round" strokeLinejoin="round" {...common} />
    </G>;
  }
  return <Line x1={start.x} y1={start.y} x2={end.x} y2={end.y} {...common} />;
}

function Outline({ item }: { item: BoardElement }) {
  const { x, y, width, height } = elementBounds(item);
  return <Rect x={x - 8} y={y - 8} width={width + 16} height={height + 16}
    stroke="#2454DE" strokeWidth={1.5} strokeDasharray="6,5" fill="none" />;
}

/** Superficie interactiva: el gesto completo se registra como una sola acción deshacible. */
export function BoardCanvas({ elements, onCommit, tool, color, brushSize, viewport,
  onViewportChange, selectedId, onSelect, onTextRequest, onCanvasSize }: Props) {
  const [dimensions, setDimensions] = useState({ width: 340, height: 380 });
  const [draft, setDraft] = useState<BoardElement | null>(null);
  const draftRef = useRef<BoardElement | null>(null);
  const interactionRef = useRef<Interaction | null>(null);
  const latest = useRef({ elements, onCommit, tool, color, brushSize, viewport,
    onViewportChange, selectedId, onSelect, onTextRequest, dimensions });
  latest.current = { elements, onCommit, tool, color, brushSize, viewport,
    onViewportChange, selectedId, onSelect, onTextRequest, dimensions };

  function updateDraft(next: BoardElement | null) {
    draftRef.current = next;
    setDraft(next);
  }

  const responder = useMemo(() => PanResponder.create({
    onStartShouldSetPanResponder: () => true,
    onMoveShouldSetPanResponder: () => true,
    onPanResponderTerminationRequest: () => false,
    onPanResponderGrant: event => {
      const s = latest.current;
      const world = screenToWorld({ x: event.nativeEvent.locationX, y: event.nativeEvent.locationY }, s.viewport);
      interactionRef.current = { start: world, startView: s.viewport, mode: s.tool };
      if (s.tool === 'hand') return;
      if (s.tool === 'text') { s.onTextRequest(world); return; }
      if (s.tool === 'eraser') {
        const hit = hitTest(s.elements, world, 16 / s.viewport.zoom);
        if (hit) s.onCommit(s.elements.filter(item => item.id !== hit.id));
        return;
      }
      if (s.tool === 'select') {
        const hit = hitTest(s.elements, world, 15 / s.viewport.zoom);
        s.onSelect(hit?.id ?? null);
        if (hit) interactionRef.current.original = hit;
        return;
      }
      if (s.tool === 'pen' || s.tool === 'marker' || s.tool === 'highlighter') {
        const widths = { pen: 3, marker: 7, highlighter: 18 };
        updateDraft({ id: newBoardId(), type: 'stroke', brush: s.tool,
          color: s.color, size: widths[s.tool] * s.brushSize,
          opacity: s.tool === 'highlighter' ? 0.32 : 1, points: [world] });
      } else {
        updateDraft({ id: newBoardId(), type: 'shape', shape: s.tool as ShapeKind,
          start: world, end: world, color: s.color, size: 3 * s.brushSize, opacity: 1 });
      }
    },
    onPanResponderMove: (event, gesture) => {
      const s = latest.current;
      const state = interactionRef.current;
      if (!state) return;
      if (state.mode === 'hand') {
        s.onViewportChange(applyViewport({ ...state.startView,
          x: state.startView.x - gesture.dx / state.startView.zoom,
          y: state.startView.y - gesture.dy / state.startView.zoom,
        }, s.dimensions.width, s.dimensions.height));
        return;
      }
      const world = screenToWorld({ x: event.nativeEvent.locationX, y: event.nativeEvent.locationY }, s.viewport);
      if (state.mode === 'select' && state.original) {
        const translated = translateElement(state.original, world.x - state.start.x, world.y - state.start.y);
        updateDraft(translated);
        return;
      }
      const current = draftRef.current;
      if (!current) return;
      if (current.type === 'stroke') {
        if (current.points.length >= MAX_POINTS_PER_STROKE) return;
        const previous = current.points[current.points.length - 1];
        if (Math.hypot(world.x - previous.x, world.y - previous.y) >= 2 / s.viewport.zoom) {
          updateDraft({ ...current, points: [...current.points, world] });
        }
      } else if (current.type === 'shape') updateDraft({ ...current, end: world });
    },
    onPanResponderRelease: () => {
      const s = latest.current; const state = interactionRef.current;
      const current = draftRef.current;
      if (state?.mode === 'select' && state.original && current) {
        s.onCommit(s.elements.map(item => item.id === current.id ? current : item));
      } else if (current && current.type === 'stroke') {
        s.onCommit([...s.elements, current]);
      } else if (current && current.type === 'shape') {
        if (Math.hypot(current.end.x - current.start.x, current.end.y - current.start.y) >= 5) {
          s.onCommit([...s.elements, current]);
        }
      }
      updateDraft(null); interactionRef.current = null;
    },
    onPanResponderTerminate: () => { updateDraft(null); interactionRef.current = null; },
  }), []);

  function onLayout(event: LayoutChangeEvent) {
    const { width, height } = event.nativeEvent.layout;
    if (width && height) {
      setDimensions({ width, height });
      onCanvasSize(width, height);
    }
  }
  const selectedItem = elements.find(item => item.id === selectedId);
  return (
    <View onLayout={onLayout} style={styles.canvas} {...responder.panHandlers}>
      <Svg style={StyleSheet.absoluteFill} pointerEvents="none"
        viewBox={`${viewport.x} ${viewport.y} ${dimensions.width / viewport.zoom} ${dimensions.height / viewport.zoom}`}
        preserveAspectRatio="none">
        <Defs>
          <Pattern id="boardDotGrid" x={0} y={0} width={32} height={32} patternUnits="userSpaceOnUse">
            <Circle cx={1} cy={1} r={1} fill="#D8E2F2" />
          </Pattern>
        </Defs>
        <Rect width={BOARD_WIDTH} height={BOARD_HEIGHT} fill="#FFFFFF" />
        <Rect width={BOARD_WIDTH} height={BOARD_HEIGHT} fill="url(#boardDotGrid)" />
        {elements.map(item => (
          draft?.id === item.id ? null : (
            <G key={item.id} transform={elementTransform(item)}>
              <BoardMark item={item} active={item.id === selectedId} />
            </G>
          )
        ))}
        {selectedItem && <G transform={elementTransform(draft?.id === selectedItem.id ? draft : selectedItem)}><Outline item={draft?.id === selectedItem.id ? draft : selectedItem} /></G>}
        {draft && <G transform={elementTransform(draft)}><BoardMark item={draft} active /></G>}
      </Svg>
    </View>
  );
}

const styles = StyleSheet.create({ canvas: { flex: 1, overflow: 'hidden', backgroundColor: '#FFFFFF' } });
