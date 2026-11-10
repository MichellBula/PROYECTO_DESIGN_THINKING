import type { PropsWithChildren } from 'react';
import { router } from 'expo-router';
import { SymbolView } from 'expo-symbols';
import {
  Pressable, StyleSheet, Text, View, type StyleProp, type ViewStyle,
} from 'react-native';
import { useTheme } from '@/hooks/use-theme';
import type { DemoProject } from '../data/mock-projects';

const projectIcons = {
  fish: { ios: 'fish.fill', android: 'water', web: 'water' },
  pets: { ios: 'pawprint.fill', android: 'pets', web: 'pets' },
  transport: { ios: 'car.fill', android: 'directions_car', web: 'directions_car' },
  eco: { ios: 'leaf.fill', android: 'eco', web: 'eco' },
  study: { ios: 'book.closed.fill', android: 'school', web: 'school' },
} as const;

export function ProjectIcon({ project, size = 52 }: { project: DemoProject; size?: number }) {
  const theme = useTheme();
  return (
    <View style={{ width: size, height: size, borderRadius: Math.round(size / 3),
      backgroundColor: theme.badgeBackground, alignItems: 'center', justifyContent: 'center' }}>
      <SymbolView name={projectIcons[project.icon]} size={size * 0.58} tintColor={theme.primary} />
    </View>
  );
}

export function ProjectPanel({ children, style }: PropsWithChildren<{ style?: StyleProp<ViewStyle> }>) {
  const theme = useTheme();
  return <View style={[styles.panel, { backgroundColor: theme.card, borderColor: theme.border }, style]}>{children}</View>;
}

export function ProjectTag({ label, accent = false }: { label: string; accent?: boolean }) {
  const theme = useTheme();
  return (
    <View style={[styles.tag, { backgroundColor: accent ? theme.backgroundSelected : theme.badgeBackground }]}>
      <Text style={{ color: theme.badgeText, fontSize: 11, fontWeight: '500' }}>{label}</Text>
    </View>
  );
}

export function ProjectBackTitle({ title }: { title: string }) {
  const theme = useTheme();
  return (
    <View style={styles.backRow}>
      <Pressable accessibilityLabel="Regresar" accessibilityRole="button"
        onPress={() => router.canGoBack() ? router.back() : router.replace('/buscar')}
        style={styles.backButton}>
        <SymbolView name={{ ios: 'chevron.left', android: 'chevron_left', web: 'chevron_left' }}
          tintColor={theme.primary} size={24} />
      </Pressable>
      <Text style={[styles.heading, { color: theme.text }]} numberOfLines={2}>{title}</Text>
    </View>
  );
}

export function PrimaryProjectButton({ title, onPress, disabled = false }: {
  title: string; onPress: () => void; disabled?: boolean;
}) {
  const theme = useTheme();
  return (
    <Pressable accessibilityRole="button" accessibilityState={{ disabled }}
      disabled={disabled} onPress={onPress}
      style={[styles.primaryButton, { backgroundColor: disabled ? theme.backgroundSelected : theme.primary }]}>
      <Text style={{ color: disabled ? theme.textSecondary : theme.onPrimary, fontWeight: '700' }}>{title}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  panel: { borderWidth: 1, borderRadius: 24, padding: 18, gap: 12,
    shadowColor: '#314D95', shadowOpacity: 0.06, shadowRadius: 9,
    shadowOffset: { width: 0, height: 5 }, elevation: 2 },
  tag: { borderRadius: 12, paddingHorizontal: 10, paddingVertical: 7,
    alignSelf: 'flex-start', maxWidth: '100%' },
  backRow: { flexDirection: 'row', gap: 8, alignItems: 'center', marginBottom: 8 },
  backButton: { width: 26, height: 44, alignItems: 'flex-start', justifyContent: 'center' },
  heading: { flex: 1, fontSize: 24, lineHeight: 32, fontWeight: '700' },
  primaryButton: { minHeight: 52, borderRadius: 16, justifyContent: 'center', alignItems: 'center' },
});
