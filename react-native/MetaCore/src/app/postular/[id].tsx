import { useState } from 'react';
import { router, useLocalSearchParams } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import {
  Modal, Pressable, ScrollView, StyleSheet, Text, TextInput, View,
} from 'react-native';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { isProjectOpen } from '@/features/projects/data/mock-projects';
import { PrimaryProjectButton, ProjectBackTitle, ProjectPanel } from '@/features/projects/components/project-ui';

function ReadOnlyField({ label, value }: { label: string; value: string }) {
  const theme = useTheme();
  return (
    <View style={styles.field}>
      <Text style={[styles.fieldLabel, { color: theme.text }]}>{label}</Text>
      <View style={[styles.readonly, { backgroundColor: theme.card, borderColor: theme.border }]}>
        <Text style={{ color: theme.textSecondary, fontSize: 14 }}>{value}</Text>
      </View>
    </View>
  );
}

export default function PostularScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { projects, currentUser, applications, submitApplication } = useDemoProjects();
  const project = projects.find(item => item.id === id);
  const [selectedRole, setSelectedRole] = useState('');
  const [motivation, setMotivation] = useState('');
  const [rolesOpen, setRolesOpen] = useState(false);
  const [error, setError] = useState('');
  const [sent, setSent] = useState(false);

  if (!project) return (
    <View style={{ flex: 1, backgroundColor: theme.background, padding: 24 }}>
      <ProjectBackTitle title="Solicitud no disponible" />
      <Text style={{ color: theme.text }}>No encontramos el proyecto.</Text>
    </View>
  );

  const alreadyApplied = applications.some(item =>
    item.projectId === project.id && item.applicantId === currentUser.id);
  const canApply = isProjectOpen(project) && project.leaderId !== currentUser.id && !alreadyApplied;
  const selected = project.roles.find(role => role.id === selectedRole);

  function send() {
    if (!canApply) { setError('No puedes enviar una solicitud para esta convocatoria.'); return; }
    const result = submitApplication(project.id, selectedRole, motivation);
    if (!result.ok) { setError(result.message); return; }
    setError('');
    setSent(true);
  }

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={styles.root}>
      <ScrollView showsVerticalScrollIndicator={false} keyboardShouldPersistTaps="handled"
        contentContainerStyle={styles.content}>
        <ProjectBackTitle title="Completar solicitud" />

        {sent ? (
          <ProjectPanel>
            <Text style={[styles.section, { color: theme.text }]}>Solicitud enviada</Text>
            <Text style={{ color: theme.textSecondary, lineHeight: 21 }}>
              Tu solicitud para {project.name} quedó pendiente de respuesta. Es un registro de prueba, todavía sin Roble.
            </Text>
            <PrimaryProjectButton title="Ver mis solicitudes" onPress={() => router.replace('/solicitudes')} />
            <Pressable onPress={() => router.replace('/buscar')} style={styles.textButton}>
              <Text style={{ color: theme.primary }}>Volver a buscar</Text>
            </Pressable>
          </ProjectPanel>
        ) : (
          <>
            <Text style={[styles.section, { color: theme.text }]}>Datos personales</Text>
            <ReadOnlyField label="Nombre completo:" value={currentUser.name} />
            <ReadOnlyField label="Correo electrónico:" value={currentUser.email} />
            <View style={styles.twoColumns}>
              <View style={{ flex: 1 }}><ReadOnlyField label="Carrera:" value={currentUser.career} /></View>
              <View style={{ flex: 1 }}><ReadOnlyField label="Semestre:" value={currentUser.semester} /></View>
            </View>
            <Text style={[styles.section, { color: theme.text }]}>Tu participación</Text>

            <View style={styles.field}>
              <Text style={[styles.fieldLabel, { color: theme.text }]}>Rol deseado:</Text>
              <Pressable accessibilityRole="button" accessibilityLabel="Seleccionar rol"
                disabled={!canApply} onPress={() => setRolesOpen(true)}
                style={[styles.readonly, { backgroundColor: theme.card, borderColor: theme.border }]}>
                <Text style={{ color: selected ? theme.text : theme.textSecondary }}>
                  {selected?.name ?? 'Selecciona el rol al que deseas postularte'}  ▾
                </Text>
              </Pressable>
            </View>

            <View style={styles.field}>
              <Text style={[styles.fieldLabel, { color: theme.text }]}>¿Por qué deseas unirte al proyecto?</Text>
              <TextInput
                value={motivation} onChangeText={setMotivation} multiline maxLength={500}
                editable={canApply} accessibilityLabel="Motivo de postulación"
                placeholder="Me quiero unir porque..."
                placeholderTextColor={theme.textSecondary}
                textAlignVertical="top"
                style={[styles.motivationInput, { color: theme.text, backgroundColor: theme.card, borderColor: theme.border }]}
              />
              <Text style={[styles.counter, { color: theme.textSecondary }]}>{motivation.length}/500</Text>
            </View>

            {!canApply && (
              <ProjectPanel>
                <Text style={{ color: theme.danger }}>
                  {alreadyApplied ? 'Ya tienes una solicitud para este proyecto.'
                    : project.leaderId === currentUser.id ? 'No puedes postularte a tu propio proyecto.'
                      : 'La convocatoria está cerrada.'}
                </Text>
              </ProjectPanel>
            )}
            {!!error && <Text style={{ color: theme.danger }}>{error}</Text>}
            <View style={styles.actions}>
              <Pressable onPress={() => router.back()} style={[styles.cancel, { borderColor: theme.border }]}>
                <Text style={{ color: theme.primary, fontWeight: '600' }}>Cancelar</Text>
              </Pressable>
              <View style={{ flex: 1 }}>
                <PrimaryProjectButton title="Enviar" onPress={send} disabled={!canApply} />
              </View>
            </View>
          </>
        )}
      </ScrollView>

      <Modal visible={rolesOpen} transparent animationType="fade" onRequestClose={() => setRolesOpen(false)}>
        <View style={styles.modalOverlay}>
          <View style={[styles.modalPanel, { backgroundColor: theme.card }]}>
            <Text style={[styles.section, { color: theme.text }]}>¿Qué rol quieres desempeñar?</Text>
            <Text style={{ color: theme.textSecondary }}>Selecciona una opción para continuar</Text>
            {project.roles.filter(role => role.quantity > 0).map(role => (
              <Pressable key={role.id} style={styles.roleRow} onPress={() => {
                setSelectedRole(role.id); setRolesOpen(false);
              }}>
                <Text style={{ color: theme.text }}>{role.name}</Text>
              </Pressable>
            ))}
            <Pressable onPress={() => setRolesOpen(false)} style={styles.textButton}>
              <Text style={{ color: theme.primary }}>Cancelar</Text>
            </Pressable>
          </View>
        </View>
      </Modal>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  content: { alignSelf: 'center', width: '100%', maxWidth: 640,
    paddingHorizontal: 24, paddingTop: 18, paddingBottom: 28, gap: 18 },
  section: { fontSize: 17, fontWeight: '600', lineHeight: 24 },
  field: { gap: 8 },
  fieldLabel: { fontSize: 12, fontWeight: '600' },
  readonly: { minHeight: 52, borderWidth: 1, borderRadius: 16,
    paddingHorizontal: 15, justifyContent: 'center', paddingVertical: 12 },
  twoColumns: { flexDirection: 'row', gap: 12 },
  motivationInput: { minHeight: 100, borderWidth: 1, borderRadius: 16,
    padding: 15, fontSize: 14 },
  counter: { fontSize: 11, textAlign: 'right' },
  actions: { flexDirection: 'row', gap: 12 },
  cancel: { flex: 1, borderWidth: 1, borderRadius: 16, minHeight: 52,
    alignItems: 'center', justifyContent: 'center' },
  modalOverlay: { flex: 1, backgroundColor: 'rgba(16,24,39,0.45)',
    justifyContent: 'flex-end' },
  modalPanel: { borderTopLeftRadius: 26, borderTopRightRadius: 26, padding: 24, gap: 14 },
  roleRow: { paddingVertical: 15 },
  textButton: { paddingVertical: 12, alignItems: 'center' },
});
