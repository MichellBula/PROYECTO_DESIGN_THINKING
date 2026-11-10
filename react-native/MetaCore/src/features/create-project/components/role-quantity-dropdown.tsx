import { useMemo, useState } from 'react';
import { SymbolView } from 'expo-symbols';
import { Modal, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useTheme } from '@/hooks/use-theme';
import { DropdownFieldTrigger } from './select-dropdown';

type Props = {
  roles: string[];
  quantities: Record<string, number>;
  onChange: (quantities: Record<string, number>) => void;
};

/** Equivalente al RoleQuantityDropdown de Flutter: 0 elimina el rol, máximo 99. */
export function RoleQuantityDropdown({ roles, quantities, onChange }: Props) {
  const theme = useTheme();
  const [open, setOpen] = useState(false);
  const [query, setQuery] = useState('');
  const selectedRoles = Object.keys(quantities).length;
  const totalPeople = Object.values(quantities).reduce((sum, quantity) => sum + quantity, 0);
  const filtered = useMemo(() => roles.filter(role =>
    role.toLocaleLowerCase('es').includes(query.trim().toLocaleLowerCase('es'))
  ), [roles, query]);

  function change(role: string, delta: number) {
    const nextQuantity = Math.max(0, Math.min(99, (quantities[role] ?? 0) + delta));
    const updated = { ...quantities };
    if (nextQuantity === 0) delete updated[role];
    else updated[role] = nextQuantity;
    onChange(updated);
  }

  function close() { setQuery(''); setOpen(false); }
  const summary = selectedRoles
    ? `${selectedRoles} ${selectedRoles === 1 ? 'rol' : 'roles'} · ${totalPeople} ${totalPeople === 1 ? 'persona' : 'personas'}`
    : '';

  return (
    <>
      <DropdownFieldTrigger label="¿Qué roles necesitas?" hint="Escoge roles y cantidad de personas"
        value={summary} onPress={() => setOpen(true)}>
        {selectedRoles > 0 && (
          <View style={styles.chips}>
            {Object.entries(quantities).map(([role, quantity]) => (
              <View key={role} style={[styles.chip, { backgroundColor: theme.badgeBackground }]}>
                <Text style={{ color: theme.badgeText, fontSize: 11 }}>{role} × {quantity}</Text>
              </View>
            ))}
          </View>
        )}
      </DropdownFieldTrigger>

      <Modal visible={open} transparent animationType="slide" onRequestClose={close}>
        <View style={styles.modalRoot}>
          <Pressable style={styles.backdrop} onPress={close} accessibilityLabel="Cerrar roles" />
          <SafeAreaView edges={['bottom']} style={[styles.sheet, { backgroundColor: theme.backgroundElement }]}>
            <View style={styles.top}>
              <View style={{ flex: 1, gap: 4 }}>
                <Text style={[styles.title, { color: theme.text }]}>Roles del proyecto</Text>
                <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
                  Elige cuántas personas necesitas por rol (máximo 99).
                </Text>
              </View>
              <Pressable onPress={close} accessibilityLabel="Cerrar">
                <SymbolView name={{ ios: 'xmark.circle.fill', android: 'close', web: 'close' }}
                  size={24} tintColor={theme.icon} />
              </Pressable>
            </View>
            <View style={[styles.search, { backgroundColor: theme.inputBackground, borderColor: theme.border }]}>
              <SymbolView name={{ ios: 'magnifyingglass', android: 'search', web: 'search' }} size={18} tintColor={theme.icon} />
              <TextInput value={query} onChangeText={setQuery} placeholder="Buscar rol..." autoCapitalize="none"
                placeholderTextColor={theme.textSecondary} style={[styles.input, { color: theme.text }]} />
            </View>
            <ScrollView style={styles.list} keyboardShouldPersistTaps="always" showsVerticalScrollIndicator={false}>
              {filtered.length === 0 ? (
                <Text style={{ color: theme.textSecondary, padding: 20, textAlign: 'center' }}>No se encontraron roles.</Text>
              ) : filtered.map(role => {
                const quantity = quantities[role] ?? 0;
                return (
                  <View key={role} style={[styles.roleRow,
                    quantity > 0 && { backgroundColor: theme.backgroundSelected }]}>
                    <Text style={{ flex: 1, color: theme.text, fontSize: 13,
                      fontWeight: quantity ? '600' : '400' }}>{role}</Text>
                    <Pressable accessibilityLabel={`Quitar una persona de ${role}`}
                      disabled={quantity === 0} onPress={() => change(role, -1)}
                      style={[styles.step, { borderColor: theme.border, opacity: quantity === 0 ? 0.35 : 1 }]}>
                      <Text style={[styles.stepText, { color: theme.primary }]}>−</Text>
                    </Pressable>
                    <Text style={[styles.quantity, { color: theme.text }]}>{String(quantity).padStart(2, '0')}</Text>
                    <Pressable accessibilityLabel={`Agregar una persona a ${role}`}
                      disabled={quantity >= 99} onPress={() => change(role, 1)}
                      style={[styles.step, { backgroundColor: theme.primary, opacity: quantity >= 99 ? 0.5 : 1 }]}>
                      <Text style={[styles.stepText, { color: theme.onPrimary }]}>+</Text>
                    </Pressable>
                  </View>
                );
              })}
            </ScrollView>
            <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
              {summary || 'Todavía no has seleccionado roles.'}
            </Text>
            <Pressable onPress={close} style={[styles.done, { backgroundColor: theme.primary }]}>
              <Text style={{ color: theme.onPrimary, fontSize: 14, fontWeight: '700' }}>Listo</Text>
            </Pressable>
          </SafeAreaView>
        </View>
      </Modal>
    </>
  );
}

const styles = StyleSheet.create({
  modalRoot: { flex: 1, justifyContent: 'flex-end' },
  backdrop: { ...StyleSheet.absoluteFillObject, backgroundColor: 'rgba(13,25,50,0.36)' },
  sheet: { borderTopLeftRadius: 28, borderTopRightRadius: 28, padding: 20, gap: 14, maxHeight: '85%' },
  top: { flexDirection: 'row', alignItems: 'flex-start', gap: 12 },
  title: { fontSize: 20, lineHeight: 28, fontWeight: '700' },
  search: { borderWidth: 1, borderRadius: 16, minHeight: 48, flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12 },
  input: { flex: 1, minWidth: 0, fontSize: 14, paddingVertical: 10 },
  list: { flexGrow: 0, maxHeight: 330 },
  roleRow: { flexDirection: 'row', alignItems: 'center', minHeight: 54, paddingHorizontal: 10, borderRadius: 12, gap: 8 },
  step: { width: 32, height: 32, borderRadius: 10, borderWidth: 1,
    borderColor: 'transparent', justifyContent: 'center', alignItems: 'center' },
  stepText: { fontSize: 21, lineHeight: 25, fontWeight: '700' },
  quantity: { width: 28, textAlign: 'center', fontSize: 14, fontWeight: '700' },
  chips: { flexDirection: 'row', flexWrap: 'wrap', gap: 6 },
  chip: { paddingHorizontal: 10, paddingVertical: 7, borderRadius: 12 },
  done: { minHeight: 48, borderRadius: 16, alignItems: 'center', justifyContent: 'center' },
});
