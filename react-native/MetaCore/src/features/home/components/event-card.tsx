
import { SymbolView } from 'expo-symbols';
import { StyleSheet, Text, View } from 'react-native';

import { useTheme } from '@/hooks/use-theme';
import type { HomeEvent } from '../data/home-demo';

type EventCardProps = {
  event: HomeEvent;
};

export function EventCard({ event }: EventCardProps) {
  const theme = useTheme();

  const icon =
    event.kind === 'avance'
      ? {
          ios: 'calendar',
          android: 'event',
          web: 'event',
        } as const
      : event.kind === 'reunion'
        ? {
            ios: 'person',
            android: 'person',
            web: 'person',
          } as const
        : {
            ios: 'doc.text',
            android: 'description',
            web: 'description',
          } as const;

  const typeLabel =
    event.kind === 'avance'
      ? 'Avance'
      : event.kind === 'reunion'
        ? 'Reunión'
        : 'Tarea';

  return (
    <View style={styles.row}>
      <View
        style={[
          styles.iconBox,
          { backgroundColor: theme.badgeBackground },
        ]}
      >
        <SymbolView
          name={icon}
          size={22}
          tintColor={theme.primary}
        />
      </View>

      <View style={styles.details}>
        <Text
          style={[styles.title, { color: theme.text }]}
        >
          {event.title}
        </Text>

        <Text
          style={[styles.date, { color: theme.primary }]}
        >
          {event.dateLabel}
        </Text>

        <View style={styles.metaRow}>
          <Text
            numberOfLines={1}
            style={[
              styles.meta,
              { color: theme.textSecondary },
            ]}
          >
            {event.projectName}
          </Text>

          <Text
            style={[
              styles.meta,
              { color: theme.textSecondary },
            ]}
          >
            {typeLabel}
          </Text>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  iconBox: {
    width: 48,
    height: 48,
    borderRadius: 15,
    alignItems: 'center',
    justifyContent: 'center',
  },
  details: {
    flex: 1,
    gap: 3,
  },
  title: {
    fontSize: 14,
    lineHeight: 20,
    fontWeight: '600',
  },
  date: {
    fontSize: 11,
    lineHeight: 16,
    fontWeight: '500',
  },
  metaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  meta: {
    flex: 1,
    fontSize: 10,
    lineHeight: 14,
  },
});
