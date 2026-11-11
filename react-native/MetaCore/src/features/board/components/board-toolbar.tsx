import { useState, type ComponentProps } from 'react';
import { SymbolView } from 'expo-symbols';
import { Modal, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { useTheme } from '@/hooks/use-theme';
import { hslToHex, isValidHex, type BoardTool, type ShapeKind } from '../data/board-model';

type SymbolName = ComponentProps<typeof SymbolView>['name'];
type ToolEntry = { id: BoardTool; label: string; icon: SymbolName };

const MAIN_TOOLS: ToolEntry[] = [
  { id: 'select', label: 'Seleccionar', icon: { ios: 'cursorarrow', android: 'near_me', web: 'near_me' } },
  { id: 'hand', label: 'Mover lienzo', icon: { ios: 'hand.draw', android: 'pan_tool', web: 'pan_tool' } },
  { id: 'pen', label: 'Lápiz', icon: { ios: 'pencil.tip', android: 'edit', web: 'edit' } },
  { id: 'marker', label: 'Marcador', icon: { ios: 'pencil', android: 'border_color', web: 'border_color' } },
  { id: 'highlighter', label: 'Resaltador', icon: { ios: 'highlighter', android: 'brush', web: 'brush' } },
  { id: 'text', label: 'Texto', icon: { ios: 'textformat', android: 'text_fields', web: 'text_fields' } },
  { id: 'eraser', label: 'Borrar', icon: { ios: 'eraser', android: 'auto_fix_off', web: 'auto_fix_off' } },
];

const SHAPES: { id: ShapeKind; label: string; icon: SymbolName }[] = [
  { id: 'rectangle', label: 'Rectángulo', icon: { ios: 'square', android: 'crop_square', web: 'crop_square' } },
  { id: 'ellipse', label: 'Círculo', icon: { ios: 'circle', android: 'radio_button_unchecked', web: 'radio_button_unchecked' } },
  { id: 'triangle', label: 'Triángulo', icon: { ios: 'triangle', android: 'change_history', web: 'change_history' } },
  { id: 'line', label: 'Línea', icon: { ios: 'line.diagonal', android: 'horizontal_rule', web: 'horizontal_rule' } },
  { id: 'arrow', label: 'Flecha', icon: { ios: 'arrow.up.right', android: 'north_east', web: 'north_east' } },
  { id: 'curve', label: 'Curva', icon: { ios: 'point.topleft.down.curvedto.point.bottomright.up', android: 'show_chart', web: 'show_chart' } },
  { id: 'star', label: 'Estrella', icon: { ios: 'star', android: 'star_border', web: 'star_border' } },
];

const QUICK_COLORS = [
  '#192440', '#FFFFFF', '#2454DE', '#76B1FF', '#00E8D9',
  '#27AE60', '#F5C542', '#FF8C42', '#E84555', '#B05CDD', '#6B7280',
];
const SHADES = [
  { saturation: 0.95, lightness: 0.52 },
  { saturation: 0.75, lightness: 0.72 },
  { saturation: 0.85, lightness: 0.3 },
];
const HUES = Array.from({ length: 20 }, (_, i) => i * 18);

function IconAction({ icon, label, onPress, disabled = false }: {
  icon: SymbolName; label: string; onPress: () => void; disabled?: boolean;
}) {
  const theme = useTheme();
  return <Pressable accessibilityRole="button" accessibilityLabel={label} disabled={disabled}
    onPress={onPress} style={[styles.actionButton, {
      backgroundColor: theme.cardTint, opacity: disabled ? 0.35 : 1,
    }]}>
    <SymbolView name={icon} size={20} tintColor={theme.primary} />
  </Pressable>;
}

export function BoardToolbar({ tool, onToolChange, color, onColorChange,
  brushSize, onBrushSizeChange, zoom, onZoomIn, onZoomOut, onUndo, onRedo,
  canUndo, canRedo, selected, editableText, onEditText, onDeleteSelection,
  onScaleUp, onScaleDown, onRotateLeft, onRotateRight, onDuplicate,
}: {
  tool: BoardTool; onToolChange: (tool: BoardTool) => void;
  color: string; onColorChange: (color: string) => void;
  brushSize: number; onBrushSizeChange: (size: number) => void;
  zoom: number; onZoomIn: () => void; onZoomOut: () => void;
  onUndo: () => void; onRedo: () => void; canUndo: boolean; canRedo: boolean;
  selected: boolean; editableText: boolean; onEditText: () => void; onDeleteSelection: () => void;
  onScaleUp: () => void; onScaleDown: () => void;
  onRotateLeft: () => void; onRotateRight: () => void; onDuplicate: () => void;
}) {
  const theme = useTheme();
  const [shapeOpen, setShapeOpen] = useState(false);
  const [colorOpen, setColorOpen] = useState(false);
  const [hexDraft, setHexDraft] = useState(color);
  const [colorError, setColorError] = useState('');
  const activeShape = SHAPES.some(entry => entry.id === tool);

  function openColorPicker() { setHexDraft(color); setColorError(''); setColorOpen(true); }
  function applyHex() {
    const normalized = hexDraft.trim().toUpperCase();
    if (!isValidHex(normalized)) { setColorError('Escribe un color hexadecimal como #2454DE.'); return; }
    onColorChange(normalized); setColorError(''); setColorOpen(false);
  }

  return (
    <View style={[styles.panel, { backgroundColor: theme.card, borderColor: theme.border }]}>
      {/* Las opciones se deslizan horizontalmente en pantallas pequeñas. */}
      <ScrollView horizontal showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.toolScroller} keyboardShouldPersistTaps="always">
        {MAIN_TOOLS.map(entry => (
          <Pressable key={entry.id} accessibilityRole="button" accessibilityLabel={entry.label}
            accessibilityState={{ selected: tool === entry.id }}
            onPress={() => { setShapeOpen(false); onToolChange(entry.id); }}
            style={[styles.toolItem, {
              backgroundColor: tool === entry.id ? theme.backgroundSelected : 'transparent',
            }]}>
            <SymbolView name={entry.icon} size={23} tintColor={tool === entry.id ? theme.primary : theme.icon} />
            <Text style={[styles.toolLabel, { color: tool === entry.id ? theme.primary : theme.textSecondary }]}>{entry.label}</Text>
          </Pressable>
        ))}
        <Pressable accessibilityRole="button" accessibilityLabel="Desplegar figuras"
          accessibilityState={{ expanded: shapeOpen }} onPress={() => setShapeOpen(value => !value)}
          style={[styles.toolItem, { backgroundColor: activeShape || shapeOpen ? theme.backgroundSelected : 'transparent' }]}>
          <SymbolView name={{ ios: 'square.on.circle', android: 'category', web: 'category' }}
            size={23} tintColor={activeShape || shapeOpen ? theme.primary : theme.icon} />
          <Text style={[styles.toolLabel, { color: activeShape || shapeOpen ? theme.primary : theme.textSecondary }]}>Figuras ▾</Text>
        </Pressable>
      </ScrollView>

      {shapeOpen && (
        <ScrollView horizontal showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.shapeScroller} keyboardShouldPersistTaps="always">
          {SHAPES.map(shape => (
            <Pressable key={shape.id} accessibilityRole="button" accessibilityLabel={`Dibujar ${shape.label}`}
              onPress={() => { onToolChange(shape.id); setShapeOpen(false); }}
              style={[styles.shapeChip, {
                backgroundColor: tool === shape.id ? theme.backgroundSelected : theme.cardTint,
                borderColor: tool === shape.id ? theme.primary : theme.border,
              }]}>
              <SymbolView name={shape.icon} size={20} tintColor={theme.primary} />
              <Text style={[styles.smallLabel, { color: theme.text }]}>{shape.label}</Text>
            </Pressable>
          ))}
        </ScrollView>
      )}

      {/* Paleta rápida independiente de la paleta avanzada. */}
      <ScrollView horizontal showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.swatches} keyboardShouldPersistTaps="always">
        <Text style={[styles.smallLabel, { color: theme.textSecondary, alignSelf: 'center' }]}>Colores</Text>
        {QUICK_COLORS.map(sample => (
          <Pressable key={sample} accessibilityRole="button" accessibilityLabel={`Color ${sample}`}
            onPress={() => onColorChange(sample)}
            style={[styles.swatch, {
              backgroundColor: sample,
              borderColor: sample.toUpperCase() === color.toUpperCase() ? theme.primary : theme.border,
              borderWidth: sample.toUpperCase() === color.toUpperCase() ? 3 : 1,
            }]} />
        ))}
        <IconAction label="Abrir paleta completa" onPress={openColorPicker}
          icon={{ ios: 'paintpalette', android: 'palette', web: 'palette' }} />
      </ScrollView>

      <ScrollView horizontal showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.options} keyboardShouldPersistTaps="always">
        <Text style={[styles.smallLabel, { color: theme.textSecondary }]}>Grosor</Text>
        <IconAction icon={{ ios: 'minus', android: 'remove', web: 'remove' }} label="Reducir grosor"
          onPress={() => onBrushSizeChange(Math.max(1, brushSize - 1))} disabled={brushSize <= 1} />
        <Text style={[styles.number, { color: theme.text }]}>{brushSize}</Text>
        <IconAction icon={{ ios: 'plus', android: 'add', web: 'add' }} label="Aumentar grosor"
          onPress={() => onBrushSizeChange(Math.min(5, brushSize + 1))} disabled={brushSize >= 5} />
        <View style={[styles.separator, { backgroundColor: theme.border }]} />
        <IconAction icon={{ ios: 'minus.magnifyingglass', android: 'zoom_out', web: 'zoom_out' }} label="Alejar tablero"
          onPress={onZoomOut} disabled={zoom <= 0.5} />
        <Text style={[styles.number, { color: theme.text, minWidth: 45 }]}>{Math.round(zoom * 100)}%</Text>
        <IconAction icon={{ ios: 'plus.magnifyingglass', android: 'zoom_in', web: 'zoom_in' }} label="Acercar tablero"
          onPress={onZoomIn} disabled={zoom >= 3} />
        <View style={[styles.separator, { backgroundColor: theme.border }]} />
        <IconAction icon={{ ios: 'arrow.uturn.backward', android: 'undo', web: 'undo' }} label="Deshacer"
          onPress={onUndo} disabled={!canUndo} />
        <IconAction icon={{ ios: 'arrow.uturn.forward', android: 'redo', web: 'redo' }} label="Rehacer"
          onPress={onRedo} disabled={!canRedo} />
      </ScrollView>

      {selected && (
        <ScrollView horizontal showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.options} keyboardShouldPersistTaps="always">
          <Text style={[styles.smallLabel, { color: theme.textSecondary }]}>Seleccionado</Text>
          <IconAction icon={{ ios: 'minus.circle', android: 'remove_circle_outline', web: 'remove_circle_outline' }}
            label="Reducir tamaño del elemento" onPress={onScaleDown} />
          <IconAction icon={{ ios: 'plus.circle', android: 'add_circle_outline', web: 'add_circle_outline' }}
            label="Aumentar tamaño del elemento" onPress={onScaleUp} />
          <IconAction icon={{ ios: 'rotate.left', android: 'rotate_left', web: 'rotate_left' }}
            label="Girar 15 grados a la izquierda" onPress={onRotateLeft} />
          <IconAction icon={{ ios: 'rotate.right', android: 'rotate_right', web: 'rotate_right' }}
            label="Girar 15 grados a la derecha" onPress={onRotateRight} />
          <IconAction icon={{ ios: 'doc.on.doc', android: 'content_copy', web: 'content_copy' }}
            label="Duplicar elemento seleccionado" onPress={onDuplicate} />
          {editableText && <IconAction icon={{ ios: 'square.and.pencil', android: 'edit', web: 'edit' }}
            label="Editar texto seleccionado" onPress={onEditText} />}
          <IconAction icon={{ ios: 'trash', android: 'delete', web: 'delete' }}
            label="Eliminar elemento seleccionado" onPress={onDeleteSelection} />
        </ScrollView>
      )}

      <Modal visible={colorOpen} transparent animationType="fade" onRequestClose={() => setColorOpen(false)}>
        <View style={styles.backdrop}>
          <View style={[styles.colorModal, { backgroundColor: theme.card, borderColor: theme.border }]}>
            <Text style={[styles.colorTitle, { color: theme.text }]}>Paleta de colores</Text>
            <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
              Selecciona un tono o escribe un color hexadecimal personalizado.
            </Text>
            <ScrollView style={{ maxHeight: 290 }} showsVerticalScrollIndicator={false}>
              {SHADES.map((shade, row) => (
                <View key={row} style={styles.colorRow}>
                  {HUES.map(hue => {
                    const sample = hslToHex(hue, shade.saturation, shade.lightness);
                    return <Pressable key={hue} accessibilityRole="button" accessibilityLabel={`Elegir ${sample}`}
                      onPress={() => { onColorChange(sample); setHexDraft(sample); setColorError(''); }}
                      style={[styles.colorCell, { backgroundColor: sample,
                        borderColor: color === sample ? theme.text : theme.border }]} />;
                  })}
                </View>
              ))}
              <View style={styles.colorRow}>
                {['#FFFFFF', '#E2E8F0', '#9CA3AF', '#64748B', '#000000', '#192440'].map(sample => (
                  <Pressable key={sample} accessibilityRole="button" onPress={() => {
                    onColorChange(sample); setHexDraft(sample); setColorError('');
                  }} style={[styles.colorCell, { backgroundColor: sample, borderColor: theme.border }]} />
                ))}
              </View>
            </ScrollView>
            <View style={[styles.hexField, { borderColor: theme.border, backgroundColor: theme.inputBackground }]}>
              <View style={[styles.preview, { backgroundColor: isValidHex(hexDraft) ? hexDraft : color }]} />
              <TextInput value={hexDraft} onChangeText={setHexDraft} maxLength={7}
                autoCapitalize="characters" autoCorrect={false} accessibilityLabel="Color hexadecimal"
                placeholder="#2454DE" placeholderTextColor={theme.textSecondary}
                style={{ flex: 1, color: theme.text, fontSize: 15 }} onSubmitEditing={applyHex} />
            </View>
            {!!colorError && <Text accessibilityRole="alert" style={{ color: theme.danger }}>{colorError}</Text>}
            <View style={styles.dialogActions}>
              <Pressable onPress={() => setColorOpen(false)} style={styles.dialogAction}>
                <Text style={{ color: theme.textSecondary, fontWeight: '600' }}>Cerrar</Text>
              </Pressable>
              <Pressable onPress={applyHex} style={[styles.dialogAction, { backgroundColor: theme.primary }]}>
                <Text style={{ color: theme.onPrimary, fontWeight: '700' }}>Aplicar</Text>
              </Pressable>
            </View>
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  panel: { borderWidth: 1, borderRadius: 18, padding: 7, gap: 5 },
  toolScroller: { gap: 4, paddingVertical: 2, paddingRight: 10, alignItems: 'center' },
  toolItem: { width: 72, borderRadius: 12, alignItems: 'center', justifyContent: 'center', paddingVertical: 6, gap: 3 },
  toolLabel: { fontSize: 10, fontWeight: '600' },
  shapeScroller: { gap: 6, paddingVertical: 5, paddingRight: 12, alignItems: 'center' },
  shapeChip: { borderWidth: 1, borderRadius: 11, paddingHorizontal: 10, height: 38,
    flexDirection: 'row', alignItems: 'center', gap: 5 },
  swatches: { gap: 8, alignItems: 'center', paddingVertical: 5, paddingRight: 12 },
  swatch: { width: 29, height: 29, borderRadius: 15 },
  options: { alignItems: 'center', gap: 5, flexDirection: 'row', paddingVertical: 4, paddingRight: 12 },
  actionButton: { width: 34, height: 34, borderRadius: 10, alignItems: 'center', justifyContent: 'center' },
  separator: { width: 1, height: 24, marginHorizontal: 7 },
  smallLabel: { fontSize: 11, fontWeight: '600' },
  number: { fontWeight: '700', fontSize: 12, minWidth: 18, textAlign: 'center' },
  backdrop: { flex: 1, backgroundColor: 'rgba(4,12,32,0.65)', justifyContent: 'center', padding: 18 },
  colorModal: { width: '100%', maxWidth: 490, alignSelf: 'center', borderWidth: 1, borderRadius: 24, padding: 18, gap: 12 },
  colorTitle: { fontWeight: '700', fontSize: 20 },
  colorRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 3, marginBottom: 8 },
  colorCell: { width: 26, height: 26, borderWidth: 1, borderRadius: 7 },
  hexField: { flexDirection: 'row', alignItems: 'center', gap: 12, borderWidth: 1, borderRadius: 14, padding: 9 },
  preview: { width: 32, height: 32, borderRadius: 10, borderWidth: 1, borderColor: '#CDD6E4' },
  dialogActions: { flexDirection: 'row', justifyContent: 'flex-end', gap: 10 },
  dialogAction: { minWidth: 90, paddingVertical: 12, paddingHorizontal: 14, borderRadius: 12, alignItems: 'center' },
});
