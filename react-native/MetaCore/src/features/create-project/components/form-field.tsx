import type { PropsWithChildren } from 'react';
import { StyleSheet, Text, TextInput, View, type TextInputProps } from 'react-native';
import { useTheme } from '@/hooks/use-theme';

type FormFieldProps = TextInputProps & {
  label: string;
  value: string;
  onChangeText: (value: string) => void;
  multiline?: boolean;
};

export function ProjectTextField({ label, multiline = false, style, ...props }: FormFieldProps) {
  const theme = useTheme();
  return (
    <View style={styles.field}>
      <Text style={[styles.label, { color: theme.text }]}>{label}</Text>
      <TextInput
        {...props}
        multiline={multiline}
        placeholderTextColor={theme.textSecondary}
        textAlignVertical={multiline ? 'top' : 'center'}
        style={[styles.input, multiline && styles.multiline, {
          color: theme.text,
          backgroundColor: theme.card,
          borderColor: theme.border,
        }, style]}
      />
      {typeof props.maxLength === 'number' && (
        <Text style={[styles.counter, { color: theme.textSecondary }]}>
          {props.value.length}/{props.maxLength}
        </Text>
      )}
    </View>
  );
}

export function ProjectSection({ title, children }: PropsWithChildren<{ title: string }>) {
  const theme = useTheme();
  return (
    <View style={styles.section}>
      <Text style={[styles.sectionTitle, { color: theme.text }]}>{title}</Text>
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  field: { gap: 8 },
  label: { fontSize: 12, lineHeight: 18, fontWeight: '600' },
  input: { borderWidth: 1, borderRadius: 16, paddingHorizontal: 15, paddingVertical: 15, fontSize: 14, minHeight: 52 },
  multiline: { minHeight: 88 },
  counter: { fontSize: 10, textAlign: 'right', marginTop: -4 },
  section: { gap: 18 },
  sectionTitle: { fontSize: 20, lineHeight: 28, fontWeight: '700' },
});
