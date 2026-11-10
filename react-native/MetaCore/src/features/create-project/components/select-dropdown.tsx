import { useMemo, useState, type ReactNode } from 'react';
import { SymbolView } from 'expo-symbols';
import { Modal, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useTheme } from '@/hooks/use-theme';

type BaseProps = { label: string; hint: string; options: string[] };
type SingleProps = BaseProps & { value: string | null; onChange: (value: string) => void };
type MultiProps = BaseProps & { values: string[]; onChange: (values: string[]) => void };

type OptionsSheetProps = {
  visible: boolean;
  title: string;
  options: string[];
  selected: string[];
  onSelect: (option: string) => void;
  onClose: () => void;
  multiple: boolean;
};

export function DropdownFieldTrigger({ label, value, hint, onPress, children }: {
  label: string; value: string; hint: string; onPress: () => void; children?: ReactNode;
}) {
  const theme = useTheme();
  return (
    <View style={styles.field}>
      <Text style={[styles.label, { color: theme.text }]}>{label}</Text>
      <Pressable accessibilityRole="button" accessibilityLabel={label} onPress={onPress}
        style={[styles.trigger, { backgroundColor: theme.card, borderColor: theme.border }]}>
        <Text style={[styles.value, { color: value ? theme.text : theme.textSecondary }]} numberOfLines={2}>
          {value || hint}
        </Text>
        <SymbolView name={{ ios: 'chevron.down', android: 'keyboard_arrow_down', web: 'keyboard_arrow_down' }}
          size={20} tintColor={theme.textSecondary} />
      </Pressable>
      {children}
    </View>
  );
}

function OptionsSheet({ visible, title, options, selected, onSelect, onClose, multiple }: OptionsSheetProps) {
  const theme = useTheme();
  const [query, setQuery] = useState('');
  const filtered = useMemo(() => options.filter(option =>
    option.toLocaleLowerCase('es').includes(query.trim().toLocaleLowerCase('es'))
  ), [options, query]);

  function close() { setQuery(''); onClose(); }
  function select(option: string) {
    onSelect(option);
    if (!multiple) close();
  }

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={close}>
      <View style={styles.modalRoot}>
        <Pressable style={styles.backdrop} onPress={close} accessibilityLabel="Cerrar selector" />
        <SafeAreaView edges={['bottom']} style={[styles.sheet, { backgroundColor: theme.backgroundElement }]}>
          <View style={styles.sheetHeader}>
            <View style={{ flex: 1, gap: 4 }}>
              <Text style={[styles.sheetTitle, { color: theme.text }]}>{title}</Text>
              <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
                {multiple ? 'Puedes seleccionar varias opciones' : 'Selecciona una opción para continuar'}
              </Text>
            </View>
            <Pressable onPress={close} accessibilityLabel="Cerrar">
              <SymbolView name={{ ios: 'xmark.circle.fill', android: 'close', web: 'close' }}
                size={24} tintColor={theme.icon} />
            </Pressable>
          </View>

          <View style={[styles.search, { backgroundColor: theme.inputBackground, borderColor: theme.border }]}>
            <SymbolView name={{ ios: 'magnifyingglass', android: 'search', web: 'search' }} size={18} tintColor={theme.icon} />
            <TextInput autoCapitalize="none" value={query} onChangeText={setQuery} placeholder="Buscar opción..."
              placeholderTextColor={theme.textSecondary} style={[styles.searchInput, { color: theme.text }]} />
          </View>

          <ScrollView style={styles.results} keyboardShouldPersistTaps="always" showsVerticalScrollIndicator={false}>
            {filtered.length === 0 ? (
              <Text style={[styles.empty, { color: theme.textSecondary }]}>No se encontraron opciones.</Text>
            ) : filtered.map(option => {
              const checked = selected.includes(option);
              return (
                <Pressable key={option} accessibilityRole="checkbox" accessibilityState={{ checked }}
                  onPress={() => select(option)}
                  style={[styles.row, checked && { backgroundColor: theme.backgroundSelected }]}>
                  <Text style={{ flex: 1, fontSize: 14, color: checked ? theme.primary : theme.text,
                    fontWeight: checked ? '600' : '400' }}>{option}</Text>
                  {multiple ? (
                    <SymbolView name={{ ios: checked ? 'checkmark.square.fill' : 'square',
                      android: checked ? 'check_box' : 'check_box_outline_blank',
                      web: checked ? 'check_box' : 'check_box_outline_blank' }}
                      size={23} tintColor={checked ? theme.primary : theme.icon} />
                  ) : checked ? (
                    <SymbolView name={{ ios: 'checkmark', android: 'check', web: 'check' }}
                      size={20} tintColor={theme.primary} />
                  ) : null}
                </Pressable>
              );
            })}
          </ScrollView>
          <Pressable onPress={close} style={[styles.done, { backgroundColor: theme.primary }]}>
            <Text style={{ color: theme.onPrimary, fontWeight: '700', fontSize: 14 }}>Listo</Text>
          </Pressable>
        </SafeAreaView>
      </View>
    </Modal>
  );
}

export function SingleSelectDropdown({ label, hint, options, value, onChange }: SingleProps) {
  const [open, setOpen] = useState(false);
  return (
    <>
      <DropdownFieldTrigger label={label} hint={hint} value={value ?? ''} onPress={() => setOpen(true)} />
      <OptionsSheet visible={open} title={label} options={options} selected={value ? [value] : []}
        onSelect={onChange} onClose={() => setOpen(false)} multiple={false} />
    </>
  );
}

export function MultiSelectDropdown({ label, hint, options, values, onChange }: MultiProps) {
  const [open, setOpen] = useState(false);
  const theme = useTheme();
  function toggle(value: string) {
    onChange(values.includes(value) ? values.filter(item => item !== value) : [...values, value]);
  }
  return (
    <>
      <DropdownFieldTrigger label={label} hint={hint}
        value={values.length ? `${values.length} seleccionadas: ${values.join(', ')}` : ''}
        onPress={() => setOpen(true)}>
        {values.length > 0 && (
          <View style={styles.chips}>
            {values.map(value => (
              <Pressable key={value} accessibilityLabel={`Quitar ${value}`} onPress={() => toggle(value)}
                style={[styles.chip, { backgroundColor: theme.badgeBackground }]}>
                <Text style={{ color: theme.badgeText, fontSize: 11 }}>{value}  ×</Text>
              </Pressable>
            ))}
          </View>
        )}
      </DropdownFieldTrigger>
      <OptionsSheet visible={open} title={label} options={options} selected={values}
        onSelect={toggle} onClose={() => setOpen(false)} multiple />
    </>
  );
}

const styles = StyleSheet.create({
  field: { gap: 8 },
  label: { fontSize: 12, fontWeight: '600', lineHeight: 18 },
  trigger: { minHeight: 52, flexDirection: 'row', alignItems: 'center', gap: 8,
    borderWidth: 1, borderRadius: 16, paddingHorizontal: 15, paddingVertical: 12 },
  value: { flex: 1, fontSize: 14, lineHeight: 20 },
  modalRoot: { flex: 1, justifyContent: 'flex-end' },
  backdrop: { ...StyleSheet.absoluteFillObject, backgroundColor: 'rgba(13,25,50,0.36)' },
  sheet: { borderTopLeftRadius: 28, borderTopRightRadius: 28, padding: 20, gap: 14, maxHeight: '85%' },
  sheetHeader: { flexDirection: 'row', alignItems: 'flex-start', gap: 12 },
  sheetTitle: { fontSize: 20, lineHeight: 28, fontWeight: '700' },
  search: { borderWidth: 1, flexDirection: 'row', alignItems: 'center', gap: 8,
    borderRadius: 16, paddingHorizontal: 12, minHeight: 48 },
  searchInput: { flex: 1, minWidth: 0, fontSize: 14, paddingVertical: 10 },
  results: { flexGrow: 0, maxHeight: 320 },
  row: { flexDirection: 'row', alignItems: 'center', minHeight: 50,
    paddingHorizontal: 12, paddingVertical: 10, borderRadius: 12, gap: 10 },
  empty: { textAlign: 'center', padding: 24 },
  done: { alignItems: 'center', justifyContent: 'center', minHeight: 48, borderRadius: 16 },
  chips: { flexDirection: 'row', flexWrap: 'wrap', gap: 6 },
  chip: { paddingHorizontal: 10, paddingVertical: 7, borderRadius: 12 },
});
