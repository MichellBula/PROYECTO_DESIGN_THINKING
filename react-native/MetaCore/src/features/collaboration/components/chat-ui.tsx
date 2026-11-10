import type { PropsWithChildren } from 'react';
import { router } from 'expo-router';
import { SymbolView } from 'expo-symbols';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useTheme } from '@/hooks/use-theme';

// Piezas compartidas por el listado, el formulario y las conversaciones.
export function ChatPanel({ children }: PropsWithChildren) {
  const theme = useTheme();
  return (
    <View style={[styles.panel, { backgroundColor: theme.card, borderColor: theme.border }]}>
      {children}
    </View>
  );
}

export function ChatAvatar({ name, group = false, size = 48 }: {
  name: string; group?: boolean; size?: number;
}) {
  const theme = useTheme();
  return (
    <View style={{ width: size, height: size, borderRadius: size / 3,
      backgroundColor: theme.badgeBackground, justifyContent: 'center', alignItems: 'center' }}>
      {group ? (
        <SymbolView name={{ ios: 'person.3.fill', android: 'groups', web: 'groups' }}
          tintColor={theme.primary} size={size * 0.52} />
      ) : (
        <Text style={{ color: theme.primary, fontWeight: '700', fontSize: size * 0.42 }}>
          {name.trim().charAt(0).toUpperCase()}
        </Text>
      )}
    </View>
  );
}

export function ChatBackTitle({ title, onBack }: { title: string; onBack: () => void }) {
  const theme = useTheme();
  return (
    <View style={styles.titleRow}>
      <Pressable accessibilityRole="button" accessibilityLabel="Volver"
        onPress={() => router.canGoBack() ? router.back() : onBack()}
        style={styles.back}>
        <SymbolView name={{ ios: 'chevron.left', android: 'chevron_left', web: 'chevron_left' }}
          tintColor={theme.primary} size={23} />
      </Pressable>
      <Text style={[styles.title, { color: theme.text }]} numberOfLines={2}>{title}</Text>
    </View>
  );
}

export function ChatButton({ label, onPress, secondary = false, disabled = false }: {
  label: string; onPress: () => void; secondary?: boolean; disabled?: boolean;
}) {
  const theme = useTheme();
  return (
    <Pressable accessibilityRole="button" accessibilityState={{ disabled }} disabled={disabled}
      onPress={onPress} style={[styles.button, {
        backgroundColor: secondary ? theme.cardTint : (disabled ? theme.backgroundSelected : theme.primary),
        borderColor: secondary ? theme.border : theme.primary,
      }]}>
      <Text style={{ color: secondary || disabled ? theme.primary : theme.onPrimary, fontWeight: '700', textAlign: 'center' }}>
        {label}
      </Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  panel: { padding: 18, borderWidth: 1, borderRadius: 24, gap: 14,
    shadowColor: '#314D95', shadowOpacity: 0.06,
    shadowOffset: { width: 0, height: 5 }, shadowRadius: 9, elevation: 2 },
  titleRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  back: { width: 26, height: 44, justifyContent: 'center' },
  title: { fontSize: 24, lineHeight: 32, fontWeight: '700', flex: 1 },
  button: { minHeight: 50, borderWidth: 1, borderRadius: 16,
    paddingHorizontal: 14, justifyContent: 'center', alignItems: 'center' },
});
