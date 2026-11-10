import { useState } from 'react';
import { router } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { Pressable, ScrollView, StyleSheet, Text, View } from 'react-native';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { ProjectPanel, ProjectTag } from '@/features/projects/components/project-ui';
import { useDemoProjects } from '@/features/projects/context/projects-context';

type Tab = 'enviadas' | 'recibidas';

export default function SolicitudesScreen() {
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { applications, projects, currentUser, answerApplication } = useDemoProjects();
  const [tab, setTab] = useState<Tab>('enviadas');

  const requests = applications.filter(req =>
    tab === 'enviadas'
      ? req.applicantId === currentUser.id
      : projects.some(p => p.id === req.projectId && p.leaderId === currentUser.id));

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={styles.root}>
      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.content}>
        <Text style={[styles.title, { color: theme.text }]}>Solicitudes</Text>
        <View style={styles.tabs}>
          {(['enviadas', 'recibidas'] as const).map(value => (
            <Pressable key={value} accessibilityRole="button"
              accessibilityState={{ selected: tab === value }}
              onPress={() => setTab(value)}
              style={[styles.tab, { backgroundColor: tab === value ? theme.primary : theme.card }]}>
              <Text style={{ color: tab === value ? theme.onPrimary : theme.textSecondary, fontSize: 12 }}>
                Solicitudes {value}
              </Text>
            </Pressable>
          ))}
        </View>
        {requests.length === 0 ? (
          <ProjectPanel>
            <Text style={{ color: theme.text, fontWeight: '600' }}>No tienes solicitudes {tab}.</Text>
            <Text style={{ color: theme.textSecondary }}>Las que envíes desde Buscar aparecerán aquí.</Text>
          </ProjectPanel>
        ) : requests.map(request => {
          const project = projects.find(p => p.id === request.projectId);
          return (
            <ProjectPanel key={request.id}>
              <Text style={{ color: theme.text, fontSize: 17, fontWeight: '700' }}>
                {project?.name ?? 'Proyecto' }
              </Text>
              <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
                {tab === 'enviadas' ? `Líder: ${project?.leader ?? ''}` : `Solicitante: ${request.applicantName}`}
              </Text>
              <Text style={{ color: theme.textSecondary, fontSize: 13 }}>
                Rol deseado: {request.roleName}
              </Text>
              <ProjectTag label={`Estado: ${request.status}`} />
              {tab === 'recibidas' && (
                <>
                  <Text style={{ color: theme.textSecondary, lineHeight: 20 }}>{request.motivation}</Text>
                  {request.status === 'pendiente' && (
                    <View style={styles.actions}>
                      <Pressable onPress={() => answerApplication(request.id, 'rechazada')}
                        style={[styles.action, { borderColor: theme.border }]}>
                        <Text style={{ color: theme.danger }}>Rechazar</Text>
                      </Pressable>
                      <Pressable onPress={() => answerApplication(request.id, 'aceptada')}
                        style={[styles.action, { backgroundColor: theme.primary }]}>
                        <Text style={{ color: theme.onPrimary }}>Aceptar</Text>
                      </Pressable>
                    </View>
                  )}
                </>
              )}
            </ProjectPanel>
          );
        })}
        <Text style={{ color: theme.textSecondary, fontSize: 11 }}>
          Las solicitudes y sus respuestas son de demostración y se reinician al recargar la aplicación.
        </Text>
        <Pressable onPress={() => router.navigate('/buscar')} style={styles.backLink}>
          <Text style={{ color: theme.primary }}>Explorar proyectos</Text>
        </Pressable>
      </ScrollView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  content: { alignSelf: 'center', width: '100%', maxWidth: 640,
    paddingHorizontal: 24, paddingTop: 18, paddingBottom: 30, gap: 18 },
  title: { fontSize: 24, lineHeight: 34, fontWeight: '700' },
  tabs: { flexDirection: 'row', gap: 8 },
  tab: { flex: 1, borderRadius: 16, paddingVertical: 12, alignItems: 'center' },
  actions: { flexDirection: 'row', gap: 12 },
  action: { flex: 1, minHeight: 44, borderWidth: 1, borderColor: 'transparent',
    borderRadius: 14, alignItems: 'center', justifyContent: 'center' },
  backLink: { paddingVertical: 8, alignItems: 'center' },
});
