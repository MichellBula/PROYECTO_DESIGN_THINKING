import { useState } from 'react';
import { router, useLocalSearchParams } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { AppScrollView } from '@/components/ui/app-scroll-view';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { formatClosingDate } from '@/features/projects/data/mock-projects';
import { ProjectIcon, ProjectPanel, ProjectTag } from '@/features/projects/components/project-ui';
import { getDemoEvents, getDemoProgress } from '@/features/collaboration/data/demo-members';
import { useCollaboration } from '@/features/collaboration/context/collaboration-context';
import { ChatBackTitle, ChatButton } from '@/features/collaboration/components/chat-ui';

type Panel = 'participantes' | 'eventos' | 'avances' | null;

export default function MiProyectoDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { projects, currentUser } = useDemoProjects();
  const { membersFor, canAccessProject } = useCollaboration();
  const [panel, setPanel] = useState<Panel>(null);
  const project = projects.find(item => item.id === id);

  if (!project || !canAccessProject(id)) {
    return (
      <View style={[styles.empty, { backgroundColor: theme.background }]}>
        <Text style={{ color: theme.text, fontWeight: '700' }}>Proyecto no disponible</Text>
        <ChatButton label="Volver a Mis proyectos" onPress={() => router.replace('/mis-proyectos')} />
      </View>
    );
  }

  const members = membersFor(project.id);
  const progress = getDemoProgress(project.id);
  const myRole = members.find(member => member.id === currentUser.id)?.role ?? 'Integrante';
  const events = getDemoEvents(project.id);

  function choosePanel(next: Exclude<Panel, null>) {
    setPanel(current => current === next ? null : next);
  }

  return (
    <View style={{ flex: 1 }}>
      <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
        locations={[0, 0.24, 0.6, 1]} style={{ flex: 1 }}>
        <AppScrollView contentContainerStyle={styles.scroll}>
          <View style={styles.content}>
            <ChatBackTitle title="Mis proyectos" onBack={() => router.replace('/mis-proyectos')} />

            <ProjectPanel>
              <View style={styles.identity}>
                <ProjectIcon project={project} size={72} />
                <View style={{ flex: 1, gap: 6 }}>
                  <Text style={[styles.name, { color: theme.text }]}>{project.name}</Text>
                  <Text style={[styles.secondary, { color: theme.textSecondary }]}>{project.category}</Text>
                </View>
              </View>
              <Text style={[styles.secondary, { color: theme.textSecondary }]}>Líder: {project.leader}</Text>
              <View style={styles.tags}>
                <ProjectTag label={`${members.length} integrantes`} />
                <ProjectTag label={`${project.vacancies} vacantes`} accent />
              </View>
              <Text style={[styles.secondary, { color: theme.textSecondary }]}>Tu rol: {myRole}</Text>
            </ProjectPanel>

            <View style={styles.section}>
              <Text style={[styles.heading, { color: theme.text }]}>Roles disponibles:</Text>
              {project.roles.length ? project.roles.map(role => (
                <ProjectTag key={role.id} label={`${role.name} · ${role.quantity}`} />
              )) : <Text style={{ color: theme.textSecondary }}>Sin roles registrados.</Text>}
            </View>

            <ProjectPanel>
              <Text style={[styles.heading, { color: theme.text }]}>Descripción:</Text>
              <Text style={[styles.body, { color: theme.textSecondary }]}>{project.description}</Text>
            </ProjectPanel>

            {project.objective && (
              <ProjectPanel>
                <Text style={[styles.heading, { color: theme.text }]}>Objetivo general:</Text>
                <Text style={[styles.body, { color: theme.textSecondary }]}>{project.objective}</Text>
              </ProjectPanel>
            )}

            <ProjectPanel>
              <Text style={[styles.heading, { color: theme.text }]}>Requisitos:</Text>
              {project.requirements.map((req, index) => (
                <Text key={`${index}-${req}`} style={[styles.body, { color: theme.textSecondary }]}>• {req}</Text>
              ))}
            </ProjectPanel>

            <View style={[styles.datePanel, {
              backgroundColor: theme.backgroundSelected, borderColor: theme.border,
            }]}>
              <Text style={[styles.secondary, { color: theme.textSecondary }]}>Fecha de cierre convocatoria:</Text>
              <Text style={{ color: theme.primary, fontSize: 22, fontWeight: '700' }}>
                {formatClosingDate(project.closingDate)}
              </Text>
            </View>

            <ProjectPanel>
              <Text style={[styles.heading, { color: theme.text }]}>Opciones del proyecto:</Text>
              <ChatButton label="Lista de participantes" secondary onPress={() => choosePanel('participantes')} />
              <ChatButton label="Eventos" secondary onPress={() => choosePanel('eventos')} />
              <ChatButton label="Avances" secondary onPress={() => choosePanel('avances')} />
            </ProjectPanel>

            {panel && (
              <ProjectPanel>
                <Text style={[styles.heading, { color: theme.text }]}>
                  {panel === 'participantes' ? 'Participantes del proyecto' :
                    panel === 'eventos' ? 'Eventos del proyecto' : 'Avances del proyecto'}
                </Text>
                {panel === 'participantes' && members.map(member => (
                  <View key={member.id} style={[styles.member, { borderBottomColor: theme.border }]}>
                    <Text style={{ color: theme.text, flex: 1, fontWeight: '600' }}>{member.name}</Text>
                    <Text style={{ color: theme.textSecondary, fontSize: 12 }}>{member.role}</Text>
                  </View>
                ))}
                {panel === 'eventos' && events.map(event => (
                  <View key={event.id} style={{ gap: 3 }}>
                    <Text style={{ color: theme.text, fontWeight: '600' }}>{event.title}</Text>
                    <Text style={{ color: theme.textSecondary, fontSize: 12 }}>{event.date}</Text>
                  </View>
                ))}
                {panel === 'avances' && (
                  <>
                    <Text style={{ color: theme.textSecondary }}>
                      Progreso de demostración: {progress}%
                    </Text>
                    <View style={[styles.track, { backgroundColor: theme.backgroundSelected }]}>
                      <View style={{ width: `${progress}%`, height: '100%',
                        backgroundColor: theme.primary, borderRadius: 8 }} />
                    </View>
                    <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
                      El registro de nuevos avances se conectará en la siguiente fase.
                    </Text>
                  </>
                )}
              </ProjectPanel>
            )}
          </View>
        </AppScrollView>
      </LinearGradient>

      {/* Botón flotante fijo a la derecha y fuera del ScrollView. */}
      <Pressable
        accessibilityRole="button"
        accessibilityLabel="Abrir chats del proyecto"
        onPress={() => router.push({
          pathname: '/chats/[projectId]',
          params: { projectId: project.id },
        })}
        style={[styles.fab, {
          backgroundColor: theme.primary,
          borderColor: theme.onPrimary,
        }]}
      >
        <SymbolView
          name={{ ios: 'bubble.left.and.bubble.right.fill', android: 'forum', web: 'forum' }}
          size={25}
          tintColor={theme.onPrimary}
        />
        <Text style={[styles.fabLabel, { color: theme.onPrimary }]}>Chats</Text>
      </Pressable>
    </View>
  );
}

const styles = StyleSheet.create({
  scroll: { alignItems: 'center', paddingBottom: 116 },
  content: { width: '100%', maxWidth: 640, paddingHorizontal: 24, paddingTop: 14, gap: 19 },
  empty: { flex: 1, padding: 24, justifyContent: 'center', gap: 20 },
  identity: { flexDirection: 'row', alignItems: 'center', gap: 16 },
  name: { fontSize: 22, fontWeight: '700' },
  heading: { fontSize: 17, fontWeight: '700' },
  secondary: { fontSize: 12, lineHeight: 19 },
  body: { fontSize: 14, lineHeight: 22 },
  tags: { flexDirection: 'row', flexWrap: 'wrap', gap: 10 },
  section: { gap: 10 },
  datePanel: { borderWidth: 1, borderRadius: 24, padding: 18, gap: 7 },
  member: { flexDirection: 'row', gap: 10, alignItems: 'center', justifyContent: 'space-between',
    paddingVertical: 12, borderBottomWidth: 1 },
  track: { width: '100%', height: 9, borderRadius: 8, overflow: 'hidden' },
  fab: {
    position: 'absolute',
    right: 24,
    bottom: 18,
    height: 58,
    minWidth: 122,
    paddingHorizontal: 18,
    borderWidth: 1,
    borderRadius: 29,
    flexDirection: 'row',
    gap: 9,
    alignItems: 'center',
    justifyContent: 'center',
    shadowColor: '#2454DE',
    shadowOpacity: 0.3,
    shadowOffset: { width: 0, height: 5 },
    shadowRadius: 10,
    elevation: 8,
  },
  fabLabel: { fontSize: 15, fontWeight: '700' },
});
