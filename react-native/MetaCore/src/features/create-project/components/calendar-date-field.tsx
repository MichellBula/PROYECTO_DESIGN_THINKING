import { useMemo, useState } from 'react';
import { SymbolView } from 'expo-symbols';
import { Modal, Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useTheme } from '@/hooks/use-theme';
import { isoDayNumber } from '../data/create-project-model';

const MONTHS = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
];
const WEEK_DAYS = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];
const LAST_DATE = '2035-12-31';

type Props = {
  label: string;
  value: string | null;
  minDate: string;
  maxDate?: string;
  disabled?: boolean;
  onChange: (iso: string) => void;
};

type CalendarView = 'days' | 'months' | 'years';

function iso(year: number, month: number, day: number): string {
  return `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
}

function displayDate(value: string | null) {
  if (!value) return 'dd  /  mm  /  aaaa';
  const [year, month, day] = value.split('-');
  return `${day} / ${month} / ${year}`;
}

/** Calendario propio en español, inspirado en los almanaques de Figma. */
export function CalendarDateField({
  label, value, minDate, maxDate = LAST_DATE, disabled = false, onChange,
}: Props) {
  const theme = useTheme();
  const [open, setOpen] = useState(false);
  const [view, setView] = useState<CalendarView>('days');
  const initial = value ?? minDate;
  const [year, setYear] = useState(Number(initial.slice(0, 4)));
  const [month, setMonth] = useState(Number(initial.slice(5, 7)) - 1);

  const days = useMemo(() => {
    const firstWeekday = new Date(year, month, 1).getDay();
    const lastDay = new Date(year, month + 1, 0).getDate();
    return Array.from({ length: firstWeekday + lastDay }, (_, index) =>
      index < firstWeekday ? null : index - firstWeekday + 1,
    );
  }, [month, year]);

  function show() {
    if (disabled) return;
    const date = value ?? minDate;
    setYear(Number(date.slice(0, 4)));
    setMonth(Number(date.slice(5, 7)) - 1);
    setView('days');
    setOpen(true);
  }

  function moveMonth(delta: number) {
    const next = new Date(year, month + delta, 1);
    const nextYear = next.getFullYear();
    if (nextYear < Number(minDate.slice(0, 4)) || nextYear > Number(maxDate.slice(0, 4))) return;
    setYear(nextYear);
    setMonth(next.getMonth());
  }

  function choose(day: number) {
    const selected = iso(year, month, day);
    if (isoDayNumber(selected) < isoDayNumber(minDate) || isoDayNumber(selected) > isoDayNumber(maxDate)) return;
    onChange(selected);
    setOpen(false);
  }

  const minYear = Number(minDate.slice(0, 4));
  const maxYear = Number(maxDate.slice(0, 4));
  const years = Array.from({ length: maxYear - minYear + 1 }, (_, i) => minYear + i);

  return (
    <View style={styles.field}>
      <Text style={[styles.label, { color: theme.text }]}>{label}</Text>
      <Pressable disabled={disabled} onPress={show} accessibilityRole="button"
        accessibilityLabel={`Elegir ${label.toLowerCase()}`}
        style={[styles.trigger, { backgroundColor: theme.card, borderColor: theme.border,
          opacity: disabled ? 0.45 : 1 }]}>
        <SymbolView name={{ ios: 'calendar', android: 'calendar_month', web: 'calendar_month' }}
          size={20} tintColor={theme.primary} />
        <Text style={{ flex: 1, color: value ? theme.text : theme.textSecondary, fontSize: 14 }}>
          {displayDate(value)}
        </Text>
        <SymbolView name={{ ios: 'chevron.down', android: 'keyboard_arrow_down', web: 'keyboard_arrow_down' }}
          size={19} tintColor={theme.icon} />
      </Pressable>

      <Modal visible={open} transparent animationType="slide" onRequestClose={() => setOpen(false)}>
        <View style={styles.modalRoot}>
          <Pressable style={styles.backdrop} onPress={() => setOpen(false)} accessibilityLabel="Cerrar calendario" />
          <SafeAreaView edges={['bottom']} style={[styles.sheet, { backgroundColor: theme.backgroundElement }]}>
            <View style={styles.titleRow}>
              <View style={{ flex: 1, gap: 4 }}>
                <Text style={[styles.title, { color: theme.text }]}>{label}</Text>
                <Text style={{ color: theme.textSecondary, fontSize: 12 }}>Selecciona una fecha del calendario</Text>
              </View>
              <Pressable onPress={() => setOpen(false)} accessibilityLabel="Cerrar calendario">
                <SymbolView name={{ ios: 'xmark.circle.fill', android: 'close', web: 'close' }} size={24} tintColor={theme.icon} />
              </Pressable>
            </View>

            <View style={[styles.calendar, { backgroundColor: theme.card, borderColor: theme.border }]}>
              <View style={styles.monthHeader}>
                <Pressable accessibilityLabel="Mes anterior" onPress={() => moveMonth(-1)} style={styles.arrow}>
                  <SymbolView name={{ ios: 'chevron.left', android: 'chevron_left', web: 'chevron_left' }}
                    size={22} tintColor={theme.primary} />
                </Pressable>
                <Pressable accessibilityLabel="Seleccionar mes" onPress={() => setView('months')}
                  style={[styles.monthSelector, { borderColor: theme.border }]}>
                  <Text style={{ color: theme.text, fontWeight: '600' }}>{MONTHS[month]} ▾</Text>
                </Pressable>
                <Pressable accessibilityLabel="Seleccionar año" onPress={() => setView('years')}
                  style={[styles.yearSelector, { borderColor: theme.border }]}>
                  <Text style={{ color: theme.text, fontWeight: '600' }}>{year} ▾</Text>
                </Pressable>
                <Pressable accessibilityLabel="Mes siguiente" onPress={() => moveMonth(1)} style={styles.arrow}>
                  <SymbolView name={{ ios: 'chevron.right', android: 'chevron_right', web: 'chevron_right' }}
                    size={22} tintColor={theme.primary} />
                </Pressable>
              </View>

              {view === 'days' ? (
                <>
                  <View style={styles.weekHeader}>
                    {WEEK_DAYS.map((day, index) => (
                      <Text key={`${day}-${index}`} style={[styles.weekText, { color: theme.textSecondary }]}>{day}</Text>
                    ))}
                  </View>
                  <View style={styles.dayGrid}>
                    {days.map((day, index) => {
                      if (!day) return <View key={`empty-${index}`} style={styles.dayCell} />;
                      const currentIso = iso(year, month, day);
                      const selectable = isoDayNumber(currentIso) >= isoDayNumber(minDate)
                        && isoDayNumber(currentIso) <= isoDayNumber(maxDate);
                      const isSelected = currentIso === value;
                      return (
                        <View key={currentIso} style={styles.dayCell}>
                          <Pressable disabled={!selectable} onPress={() => choose(day)}
                            accessibilityRole="button" accessibilityLabel={`Elegir día ${day}`}
                            style={[styles.dayButton, isSelected && { backgroundColor: theme.primary }]}>
                            <Text style={{ fontSize: 13, color: isSelected ? theme.onPrimary
                              : selectable ? theme.text : theme.textSecondary,
                              opacity: selectable ? 1 : 0.3, fontWeight: isSelected ? '700' : '400' }}>
                              {day}
                            </Text>
                          </Pressable>
                        </View>
                      );
                    })}
                  </View>
                </>
              ) : (
                <ScrollView style={styles.pickerScroll} showsVerticalScrollIndicator={false}>
                  <View style={styles.pickerGrid}>
                    {view === 'months'
                      ? MONTHS.map((name, index) => (
                          <Pressable key={name} onPress={() => { setMonth(index); setView('days'); }}
                            style={[styles.pickerItem, { backgroundColor: index === month
                              ? theme.backgroundSelected : theme.cardTint }]}>
                            <Text style={{ color: index === month ? theme.primary : theme.text,
                              fontSize: 13, fontWeight: '600' }}>{name}</Text>
                          </Pressable>
                        ))
                      : years.map(item => (
                          <Pressable key={item} onPress={() => { setYear(item); setView('days'); }}
                            style={[styles.pickerItem, { backgroundColor: item === year
                              ? theme.backgroundSelected : theme.cardTint }]}>
                            <Text style={{ color: item === year ? theme.primary : theme.text,
                              fontSize: 14, fontWeight: '600' }}>{item}</Text>
                          </Pressable>
                        ))}
                  </View>
                </ScrollView>
              )}
            </View>
            <Pressable onPress={() => setOpen(false)} style={[styles.done, { backgroundColor: theme.primary }]}>
              <Text style={{ color: theme.onPrimary, fontSize: 14, fontWeight: '700' }}>Cerrar</Text>
            </Pressable>
          </SafeAreaView>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  field: { gap: 8 },
  label: { fontSize: 12, fontWeight: '600', lineHeight: 18 },
  trigger: { minHeight: 52, borderWidth: 1, borderRadius: 16, flexDirection: 'row',
    alignItems: 'center', gap: 12, paddingHorizontal: 15 },
  modalRoot: { flex: 1, justifyContent: 'flex-end' },
  backdrop: { ...StyleSheet.absoluteFillObject, backgroundColor: 'rgba(13,25,50,0.36)' },
  sheet: { borderTopLeftRadius: 28, borderTopRightRadius: 28, padding: 20, gap: 16, maxHeight: '88%' },
  titleRow: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  title: { fontSize: 20, fontWeight: '700' },
  calendar: { borderWidth: 1, borderRadius: 22, padding: 12, gap: 12 },
  monthHeader: { flexDirection: 'row', alignItems: 'center', gap: 5, justifyContent: 'space-between' },
  arrow: { width: 30, height: 40, justifyContent: 'center', alignItems: 'center' },
  monthSelector: { flex: 1, minHeight: 36, borderWidth: 1, borderRadius: 9, justifyContent: 'center', paddingHorizontal: 8 },
  yearSelector: { width: 84, minHeight: 36, borderWidth: 1, borderRadius: 9, justifyContent: 'center', alignItems: 'center' },
  weekHeader: { flexDirection: 'row' },
  weekText: { width: '14.2857%', fontSize: 12, textAlign: 'center' },
  dayGrid: { flexDirection: 'row', flexWrap: 'wrap', rowGap: 5 },
  dayCell: { width: '14.2857%', height: 40, justifyContent: 'center', alignItems: 'center' },
  dayButton: { width: 36, height: 36, borderRadius: 18, alignItems: 'center', justifyContent: 'center' },
  pickerScroll: { maxHeight: 300 },
  pickerGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, justifyContent: 'center' },
  pickerItem: { minWidth: '30%', minHeight: 42, borderRadius: 12, padding: 10, alignItems: 'center', justifyContent: 'center' },
  done: { minHeight: 48, borderRadius: 16, alignItems: 'center', justifyContent: 'center' },
});
