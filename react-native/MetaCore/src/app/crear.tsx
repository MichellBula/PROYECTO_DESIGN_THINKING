import { useState } from 'react';
import { router } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';
import { Modal, Pressable, StyleSheet, Text, View } from 'react-native';

import { AppScrollView } from '@/components/ui/app-scroll-view';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { CalendarDateField } from '@/features/create-project/components/calendar-date-field';
import { ProjectSection, ProjectTextField } from '@/features/create-project/components/form-field';
import { RoleQuantityDropdown } from '@/features/create-project/components/role-quantity-dropdown';
import { MultiSelectDropdown, SingleSelectDropdown } from '@/features/create-project/components/select-dropdown';
import {
  addCalendarDays, emptyProjectInput, todayIso, validateCreateProject,
} from '@/features/create-project/data/create-project-model';
import {
  projectCategories, projectRoles, projectSkills, projectTypes,
} from '@/features/create-project/data/project-options';

const MAX_DATE = '2035-12-31';
const MAX_START_DATE = '2035-12-24';

export default function CrearProyectoScreen() {
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { createProject } = useDemoProjects();
  const [form, setForm] = useState(emptyProjectInput);
  const [error, setError] = useState<string | null>(null);
  const [publishedName, setPublishedName] = useState<string | null>(null);
  const [confirmationOpen, setConfirmationOpen] = useState(false);

  // Limpia el aviso cuando el usuario corrige un campo.
  function updateField<K extends keyof typeof form>(key: K, value: (typeof form)[K]) {
    setError(null);
    setForm(current => ({ ...current, [key]: value }));
  }

  function changeStartDate(value: string) {
    setError(null);
    setForm(current => ({
      ...current,
      startDate: value,
      closingDate: current.closingDate && current.closingDate >= addCalendarDays(value, 7)
        ? current.closingDate : null,
    }));
  }

  function requestPublication() {
    const validationError = validateCreateProject(form);
    if (validationError) { setError(validationError); return; }
    setConfirmationOpen(true);
  }

  function publishProject() {
    setConfirmationOpen(false);
    const result = createProject(form);
    if (!result.ok) { setError(result.message); return; }
    setPublishedName(form.name.trim());
    setForm(emptyProjectInput());
    setError(null);
  }

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={styles.root}>
      <AppScrollView style={{ flex: 1 }} keyboardShouldPersistTaps="handled"
        contentContainerStyle={styles.scrollContent}>
        <View style={styles.content}>
          <View style={styles.heading}>
            <Pressable onPress={() => router.navigate('/')} accessibilityRole="button"
              accessibilityLabel="Volver al inicio" style={styles.chevron}>
              <SymbolView name={{ ios: 'chevron.left', android: 'chevron_left', web: 'chevron_left' }}
                size={24} tintColor={theme.primary} />
            </Pressable>
            <Text style={[styles.title, { color: theme.text }]}>Nuevo proyecto</Text>
          </View>

          {publishedName ? (
            <View style={[styles.successCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
              <View style={[styles.successIcon, { backgroundColor: theme.badgeBackground }]}>
                <SymbolView name={{ ios: 'checkmark.circle.fill', android: 'check_circle', web: 'check_circle' }}
                  size={54} tintColor={theme.primary} />
              </View>
              <Text style={[styles.successTitle, { color: theme.text }]}>¡Tu proyecto está publicado!</Text>
              <Text style={[styles.successMessage, { color: theme.textSecondary }]}>
                {publishedName} fue creado en los datos de demostración de MetaCore.
                Ahora apareces como líder y puedes revisar el proyecto en Mis proyectos.
              </Text>
              <Pressable onPress={() => router.navigate('/mis-proyectos')}
                style={[styles.primaryButton, { backgroundColor: theme.primary }]}>
                <Text style={[styles.primaryText, { color: theme.onPrimary }]}>Ver Mis proyectos</Text>
              </Pressable>
              <Pressable onPress={() => setPublishedName(null)}
                style={[styles.secondaryButton, { borderColor: theme.border, backgroundColor: theme.cardTint }]}>
                <Text style={{ color: theme.primary, fontWeight: '700' }}>Crear otro proyecto</Text>
              </Pressable>
              <Text style={{ color: theme.textSecondary, fontSize: 11, textAlign: 'center' }}>
                El proyecto se guarda temporalmente en este dispositivo. Aún no está conectado a Roble.
              </Text>
            </View>
          ) : (
            <>
              <Text style={[styles.intro, { color: theme.textSecondary }]}>
                Crea tu proyecto en un solo formulario y encuentra compañeros para desarrollar tu idea.
              </Text>

              <ProjectSection title="Define tu idea">
                <ProjectTextField label="Nombre del proyecto" placeholder="Tu proyecto" value={form.name}
                  maxLength={50} onChangeText={value => updateField('name', value)} />
                <ProjectTextField label="Descripción" placeholder="Mi proyecto se basa en..." value={form.description}
                  maxLength={400} multiline numberOfLines={3}
                  onChangeText={value => updateField('description', value)} />
                <SingleSelectDropdown label="Categoría" hint="Selecciona una categoría"
                  options={projectCategories} value={form.category || null}
                  onChange={value => updateField('category', value)} />
                <View style={[styles.ownerNote, { backgroundColor: theme.badgeBackground }]}>
                  <SymbolView name={{ ios: 'person.crop.circle.badge.checkmark', android: 'verified_user', web: 'verified_user' }}
                    size={18} tintColor={theme.primary} />
                  <Text style={{ flex: 1, color: theme.badgeText, fontSize: 12, lineHeight: 18 }}>
                    El líder del proyecto será automáticamente el usuario que lo crea.
                  </Text>
                </View>
              </ProjectSection>

              <View style={[styles.separator, { borderColor: theme.border }]} />

              <ProjectSection title="Diseña tu equipo">
                <ProjectTextField label="Objetivo general" placeholder="El objetivo de mi proyecto es..."
                  value={form.objective} maxLength={300} multiline numberOfLines={3}
                  onChangeText={value => updateField('objective', value)} />
                <RoleQuantityDropdown roles={projectRoles} quantities={form.roleQuantities}
                  onChange={value => updateField('roleQuantities', value)} />
                <MultiSelectDropdown label="Habilidades necesarias" hint="Selecciona una o más habilidades"
                  options={projectSkills} values={form.skills}
                  onChange={value => updateField('skills', value)} />
                <ProjectTextField label="Requisitos" placeholder="Describe los requisitos del proyecto..."
                  value={form.requirements} maxLength={300} multiline numberOfLines={3}
                  onChangeText={value => updateField('requirements', value)} />
                <SingleSelectDropdown label="Tipo de proyecto" hint="Selecciona un tipo de proyecto"
                  options={projectTypes} value={form.projectType || null}
                  onChange={value => updateField('projectType', value)} />
                <View style={styles.advisorSection}>
                  <Text style={[styles.fieldLabel, { color: theme.text }]}>¿Deseas docente asesor?</Text>
                  <View style={styles.advisorButtons}>
                    {[true, false].map(value => {
                      const selected = form.wantsAdvisor === value;
                      return (
                        <Pressable key={String(value)} onPress={() => updateField('wantsAdvisor', value)}
                          style={[styles.advisorChoice, { backgroundColor: selected ? theme.backgroundSelected : theme.card,
                            borderColor: selected ? theme.primary : theme.border }]}>
                          <Text style={{ color: selected ? theme.primary : theme.text, fontWeight: '600' }}>
                            {value ? 'Sí' : 'No'}
                          </Text>
                        </Pressable>
                      );
                    })}
                  </View>
                </View>
              </ProjectSection>

              <View style={[styles.separator, { borderColor: theme.border }]} />

              <ProjectSection title="Calendario de convocatoria">
                <Text style={{ color: theme.textSecondary, fontSize: 12, lineHeight: 18 }}>
                  El cierre debe ser al menos 7 días después del inicio. Selecciona ambas fechas en el calendario.
                </Text>
                <CalendarDateField label="Inicio de convocatoria" value={form.startDate}
                  minDate={todayIso()} maxDate={MAX_START_DATE} onChange={changeStartDate} />
                <CalendarDateField label="Cierre de convocatoria" value={form.closingDate}
                  minDate={form.startDate ? addCalendarDays(form.startDate, 7) : todayIso()}
                  maxDate={MAX_DATE} disabled={!form.startDate}
                  onChange={value => updateField('closingDate', value)} />
                {!form.startDate && (
                  <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
                    Primero selecciona la fecha de inicio para habilitar el cierre.
                  </Text>
                )}
              </ProjectSection>

              {error && (
                <View style={[styles.errorBox, { borderColor: theme.danger, backgroundColor: theme.card }]}>
                  <Text accessibilityRole="alert" style={{ color: theme.danger, fontSize: 13 }}>{error}</Text>
                </View>
              )}

              {/* Un único envío, sin otra pantalla de detalles o fecha de presentación. */}
              <View style={styles.actions}>
                <Pressable onPress={() => router.navigate('/')}
                  style={[styles.secondaryButton, { backgroundColor: theme.cardTint, borderColor: theme.border }]}>
                  <Text style={{ fontWeight: '700', color: theme.primary }}>Cancelar</Text>
                </Pressable>
                <Pressable onPress={requestPublication}
                  style={[styles.primaryButton, { backgroundColor: theme.primary }]}>
                  <Text style={[styles.primaryText, { color: theme.onPrimary }]}>Publicar</Text>
                </Pressable>
              </View>
            </>
          )}
        </View>
      </AppScrollView>
      {/* Mantiene la confirmación de Flutter, pero sin navegar a otra página. */}
      <Modal transparent animationType="fade" visible={confirmationOpen}
        onRequestClose={() => setConfirmationOpen(false)}>
        <View style={styles.confirmationOverlay}>
          <View style={[styles.confirmationCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
            <Text style={[styles.confirmationTitle, { color: theme.text }]}>Confirmar publicación</Text>
            <Text style={{ color: theme.textSecondary, fontSize: 13, lineHeight: 21 }}>
              ¿Deseas publicar «{form.name.trim()}»? Al confirmar, el proyecto aparecerá
              en Mis proyectos con {Object.values(form.roleQuantities).reduce((sum, count) => sum + count, 0)} vacantes disponibles.
            </Text>
            <View style={styles.actions}>
              <Pressable onPress={() => setConfirmationOpen(false)}
                style={[styles.secondaryButton, { backgroundColor: theme.cardTint, borderColor: theme.border }]}>
                <Text style={{ color: theme.primary, fontWeight: '700' }}>Editar</Text>
              </Pressable>
              <Pressable onPress={publishProject}
                style={[styles.primaryButton, { backgroundColor: theme.primary }]}>
                <Text style={[styles.primaryText, { color: theme.onPrimary }]}>Confirmar</Text>
              </Pressable>
            </View>
          </View>
        </View>
      </Modal>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  scrollContent: { alignItems: 'center', paddingBottom: 38 },
  content: { width: '100%', maxWidth: 640, paddingHorizontal: 24, paddingTop: 18, gap: 24 },
  heading: { flexDirection: 'row', gap: 9, alignItems: 'center' },
  chevron: { minHeight: 40, width: 27, alignItems: 'flex-start', justifyContent: 'center' },
  title: { fontSize: 24, fontWeight: '700', lineHeight: 34 },
  intro: { fontSize: 13, lineHeight: 20, textAlign: 'center' },
  separator: { borderTopWidth: 1 },
  ownerNote: { flexDirection: 'row', gap: 10, alignItems: 'center', padding: 14, borderRadius: 16 },
  advisorSection: { gap: 9 },
  fieldLabel: { fontSize: 12, fontWeight: '600' },
  advisorButtons: { flexDirection: 'row', gap: 12 },
  advisorChoice: { flex: 1, minHeight: 46, borderWidth: 1.5, borderRadius: 16,
    justifyContent: 'center', alignItems: 'center' },
  actions: { flexDirection: 'row', gap: 12, marginTop: 2 },
  primaryButton: { flex: 1, minHeight: 52, borderRadius: 18, alignItems: 'center',
    justifyContent: 'center', paddingHorizontal: 12, shadowColor: '#314D95', shadowOpacity: 0.14,
    shadowOffset: { width: 0, height: 4 }, shadowRadius: 7, elevation: 3 },
  primaryText: { fontSize: 14, fontWeight: '700' },
  secondaryButton: { flex: 1, minHeight: 52, borderWidth: 1, borderRadius: 18,
    alignItems: 'center', justifyContent: 'center', paddingHorizontal: 12 },
  errorBox: { borderWidth: 1, padding: 14, borderRadius: 14 },
  successCard: { borderWidth: 1, borderRadius: 24, padding: 24, gap: 20 },
  successIcon: { width: 88, height: 88, borderRadius: 24, justifyContent: 'center', alignItems: 'center' },
  successTitle: { fontSize: 28, fontWeight: '700', lineHeight: 36 },
  successMessage: { fontSize: 14, lineHeight: 22 },
  confirmationOverlay: { flex: 1, justifyContent: 'center', paddingHorizontal: 24, backgroundColor: 'rgba(13,25,50,0.45)' },
  confirmationCard: { width: '100%', maxWidth: 480, alignSelf: 'center', borderWidth: 1, borderRadius: 24, padding: 22, gap: 20 },
  confirmationTitle: { fontSize: 20, fontWeight: '700' },
});
