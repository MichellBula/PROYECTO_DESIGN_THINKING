import { useEffect, useRef, useState } from 'react';
import { router, useLocalSearchParams } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';
import { Modal, Platform, Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { useCollaboration } from '@/features/collaboration/context/collaboration-context';
import { BoardCanvas } from '@/features/board/components/board-canvas';
import { BoardToolbar } from '@/features/board/components/board-toolbar';
import { useBoard } from '@/features/board/hooks/use-board';
import {
  changeZoom, duplicateElement, MAX_ELEMENTS, MAX_TOTAL_POINTS, newBoardId,
  resizeElement, rotateElement, type BoardElement, type BoardTool,
  type Point, type Viewport,
} from '@/features/board/data/board-model';

export default function BoardScreen() {
  const { projectId = '', roomId = '' } = useLocalSearchParams<{ projectId: string; roomId: string }>();
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { currentUser, projects } = useDemoProjects();
  const { rooms, canAccessProject } = useCollaboration();
  const room = rooms.find(item => item.id === roomId && item.projectId === projectId);
  const project = projects.find(item => item.id === projectId);
  const allowed = !!project && room?.type === 'group' && room.members.includes(currentUser.id)
    && canAccessProject(projectId);
  const { elements, commit, undo, redo, canUndo, canRedo, loaded, error } = useBoard(projectId, roomId);
  const [tool, setTool] = useState<BoardTool>('pen');
  const [color, setColor] = useState('#2454DE');
  const [brushSize, setBrushSize] = useState(1);
  const [viewport, setViewport] = useState<Viewport>({ x: 130, y: 90, zoom: 1 });
  const canvasSize = useRef({ width: 340, height: 380 });
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [textOpen, setTextOpen] = useState(false);
  const [textDraft, setTextDraft] = useState('');
  const [textPosition, setTextPosition] = useState<Point>({ x: 150, y: 150 });
  const [editingTextId, setEditingTextId] = useState<string | null>(null);
  const [textError, setTextError] = useState('');
  const selected = elements.find(item => item.id === selectedId);

  const back = () => {
    if (router.canGoBack()) router.back();
    else router.replace({ pathname: '/chats/[projectId]/[roomId]', params: { projectId, roomId } });
  };
  const zoomBy = (delta: number) => {
    setViewport(previous => changeZoom(previous, Math.round((previous.zoom + delta) * 10) / 10,
      canvasSize.current.width, canvasSize.current.height));
  };
  const requestNewText = (position: Point) => {
    setEditingTextId(null); setTextPosition(position); setTextDraft(''); setTextError(''); setTextOpen(true);
  };
  const editSelectedText = () => {
    if (!selected || selected.type !== 'text') return;
    setEditingTextId(selected.id); setTextPosition(selected.position);
    setTextDraft(selected.text); setTextError(''); setTextOpen(true);
  };
  const saveText = () => {
    const value = textDraft.trim();
    if (!value) { setTextError('Escribe un texto antes de guardarlo.'); return; }
    if (editingTextId) {
      commit(elements.map(item => item.id === editingTextId && item.type === 'text'
        ? { ...item, text: value, color } : item));
    } else {
      if (elements.length >= MAX_ELEMENTS) { setTextError('Se alcanzó el límite de elementos.'); return; }
      const textItem: BoardElement = {
        id: newBoardId(), type: 'text', text: value, position: textPosition,
        color, fontSize: 22, opacity: 1,
      };
      commit([...elements, textItem]); setSelectedId(textItem.id);
    }
    setTextOpen(false);
    setTool('select');
  };
  // La paleta rápida modifica el color del objeto seleccionado si estamos en selección.
  const changeColor = (next: string) => {
    setColor(next);
    if (tool === 'select' && selectedId) {
      commit(elements.map(item => item.id === selectedId ? { ...item, color: next } : item));
    }
  };
  const transformSelected = (transform: (item: BoardElement) => BoardElement) => {
    if (!selectedId) return;
    commit(elements.map(item => item.id === selectedId ? transform(item) : item));
  };
  const duplicateSelection = () => {
    if (!selected || elements.length >= MAX_ELEMENTS) return;
    const totalPoints = elements.reduce((total, item) => total +
      (item.type === 'stroke' ? item.points.length : 1), 0);
    const addedPoints = selected.type === 'stroke' ? selected.points.length : 1;
    if (totalPoints + addedPoints > MAX_TOTAL_POINTS) return;
    const copy = duplicateElement(selected);
    commit([...elements, copy]);
    setSelectedId(copy.id);
  };
  const deleteSelection = () => {
    if (!selectedId) return;
    commit(elements.filter(item => item.id !== selectedId)); setSelectedId(null);
  };

  // Atajos de escritorio: Ctrl/Cmd+Z, Ctrl/Cmd+Y y Cmd+Shift+Z.
  useEffect(() => {
    if (Platform.OS !== 'web' || typeof document === 'undefined') return;
    const listener = (event: KeyboardEvent) => {
      const el = event.target as HTMLElement | null;
      if (el && ['INPUT', 'TEXTAREA'].includes(el.tagName)) return;
      if (!(event.ctrlKey || event.metaKey)) return;
      const key = event.key.toLowerCase();
      if (key === 'z' && event.shiftKey) { event.preventDefault(); redo(); }
      else if (key === 'z') { event.preventDefault(); undo(); }
      else if (key === 'y') { event.preventDefault(); redo(); }
    };
    document.addEventListener('keydown', listener);
    return () => document.removeEventListener('keydown', listener);
  }, [undo, redo]);

  if (!allowed) {
    return <View style={[styles.center, { backgroundColor: theme.background }]}>
      <Text style={{ color: theme.text, textAlign: 'center' }}>
        Este tablero existe solo para los integrantes del chat grupal.
      </Text>
      <Pressable onPress={back} style={[styles.backFallback, { backgroundColor: theme.primary }]}>
        <Text style={{ color: theme.onPrimary, fontWeight: '700' }}>Volver al chat</Text>
      </Pressable>
    </View>;
  }

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={styles.page}>
      <View style={styles.header}>
        <Pressable onPress={back} accessibilityRole="button" accessibilityLabel="Volver al chat"
          style={styles.backIcon}>
          <SymbolView name={{ ios: 'chevron.left', android: 'chevron_left', web: 'chevron_left' }}
            tintColor={theme.primary} size={25} />
        </Pressable>
        <View style={{ flex: 1 }}>
          <Text style={[styles.headerTitle, { color: theme.text }]} numberOfLines={1}>{room.name}</Text>
          <Text style={{ color: theme.textSecondary, fontSize: 12 }} numberOfLines={1}>
            Tablero de ideas · {room.members.length} integrantes
          </Text>
        </View>
        <View style={[styles.statusDot, { backgroundColor: error ? theme.danger : theme.success }]} />
      </View>
      <View style={[styles.boardCard, { borderColor: theme.border, backgroundColor: theme.card }]}>
        <Text style={[styles.boardLabel, { color: theme.text }]}>Tablero colaborativo</Text>
        <Text style={[styles.boardHint, { color: theme.textSecondary }]}>
          {tool === 'hand' ? 'Arrastra para mover el lienzo.' :
            tool === 'select' ? 'Selecciona para mover, cambiar color, girar, redimensionar o duplicar.' :
            tool === 'text' ? 'Toca el tablero para colocar un texto.' :
            tool === 'eraser' ? 'Toca un trazo o figura para borrarlo.' :
            'Dibuja o arrastra sobre el tablero.'}
        </Text>
        <View style={[styles.canvasFrame, { borderColor: theme.border }]}>
          {loaded ? (
            <BoardCanvas elements={elements} onCommit={commit} tool={tool} color={color}
              brushSize={brushSize} viewport={viewport} onViewportChange={setViewport}
              selectedId={selectedId} onSelect={setSelectedId} onTextRequest={requestNewText}
              onCanvasSize={(width, height) => { canvasSize.current = { width, height }; }} />
          ) : <View style={styles.center}>
            <Text style={{ color: theme.textSecondary }}>Cargando tablero...</Text>
          </View>}
        </View>
        {!!error && <Text accessibilityRole="alert" style={{ color: theme.danger, fontSize: 12 }}>{error}</Text>}
        {elements.length >= MAX_ELEMENTS && (
          <Text style={{ color: theme.danger, fontSize: 12 }}>
            Has llegado al límite de {MAX_ELEMENTS} objetos. Elimina algunos para continuar.
          </Text>
        )}
        <BoardToolbar tool={tool} onToolChange={next => { setTool(next); setSelectedId(null); }}
          color={color} onColorChange={changeColor} brushSize={brushSize} onBrushSizeChange={setBrushSize}
          zoom={viewport.zoom} onZoomIn={() => zoomBy(0.2)} onZoomOut={() => zoomBy(-0.2)}
          onUndo={() => { undo(); setSelectedId(null); }} onRedo={() => { redo(); setSelectedId(null); }}
          canUndo={canUndo} canRedo={canRedo} selected={!!selected}
          editableText={selected?.type === 'text'} onEditText={editSelectedText}
          onDeleteSelection={deleteSelection}
          onScaleUp={() => transformSelected(item => resizeElement(item, 1.2))}
          onScaleDown={() => transformSelected(item => resizeElement(item, 1 / 1.2))}
          onRotateLeft={() => transformSelected(item => rotateElement(item, -15))}
          onRotateRight={() => transformSelected(item => rotateElement(item, 15))}
          onDuplicate={duplicateSelection} />
        <Text style={[styles.footerHint, { color: theme.textSecondary }]}>
          Los cambios se guardan en este dispositivo. No se comparten entre celulares todavía.
        </Text>
      </View>

      <Modal transparent visible={textOpen} animationType="fade" onRequestClose={() => setTextOpen(false)}>
        <View style={styles.modalBackdrop}>
          <View style={[styles.modalCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
            <Text style={[styles.modalTitle, { color: theme.text }]}>
              {editingTextId ? 'Editar texto' : 'Agregar texto'}
            </Text>
            <TextInput multiline autoFocus value={textDraft} maxLength={180}
              onChangeText={setTextDraft} placeholder="Escribe tu idea..."
              placeholderTextColor={theme.textSecondary} accessibilityLabel="Texto del tablero"
              style={[styles.textInput, { color: theme.text, borderColor: theme.border,
                backgroundColor: theme.inputBackground }]} />
            {!!textError && <Text accessibilityRole="alert" style={{ color: theme.danger }}>{textError}</Text>}
            <View style={styles.modalActions}>
              <Pressable accessibilityRole="button" onPress={() => setTextOpen(false)} style={styles.modalAction}>
                <Text style={{ color: theme.textSecondary, fontWeight: '600' }}>Cancelar</Text>
              </Pressable>
              <Pressable accessibilityRole="button" onPress={saveText}
                style={[styles.modalAction, { backgroundColor: theme.primary }]}>
                <Text style={{ color: theme.onPrimary, fontWeight: '700' }}>Guardar</Text>
              </Pressable>
            </View>
          </View>
        </View>
      </Modal>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  page: { flex: 1, paddingHorizontal: 12, paddingTop: 5, paddingBottom: 8 },
  header: { flexDirection: 'row', alignItems: 'center', paddingHorizontal: 4, gap: 9, marginBottom: 10 },
  backIcon: { width: 34, height: 40, alignItems: 'center', justifyContent: 'center' },
  headerTitle: { fontSize: 20, fontWeight: '700' },
  statusDot: { width: 9, height: 9, borderRadius: 5 },
  boardCard: { flex: 1, borderWidth: 1, borderRadius: 20, padding: 9, gap: 7 },
  boardLabel: { fontSize: 14, fontWeight: '700' },
  boardHint: { fontSize: 11, lineHeight: 16 },
  canvasFrame: { flex: 1, minHeight: 180, overflow: 'hidden', borderWidth: 1, borderRadius: 12 },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 18, padding: 24 },
  footerHint: { textAlign: 'center', fontSize: 10, lineHeight: 14 },
  backFallback: { paddingHorizontal: 18, paddingVertical: 14, borderRadius: 14 },
  modalBackdrop: { flex: 1, backgroundColor: 'rgba(4,12,32,0.63)', padding: 24, justifyContent: 'center' },
  modalCard: { maxWidth: 490, alignSelf: 'center', width: '100%', borderRadius: 24, borderWidth: 1, padding: 20, gap: 14 },
  modalTitle: { fontSize: 20, fontWeight: '700' },
  textInput: { borderWidth: 1, borderRadius: 14, minHeight: 100, padding: 12, textAlignVertical: 'top' },
  modalActions: { flexDirection: 'row', justifyContent: 'flex-end', gap: 10 },
  modalAction: { minWidth: 88, paddingHorizontal: 14, paddingVertical: 12, borderRadius: 13, alignItems: 'center' },
});
