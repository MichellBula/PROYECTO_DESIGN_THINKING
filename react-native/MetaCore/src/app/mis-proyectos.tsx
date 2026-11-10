import { useMemo, useState } from 'react';
import { router } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';
import { Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { AppScrollView } from '@/components/ui/app-scroll-view';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { matchesProject, type DemoProject } from '@/features/projects/data/mock-projects';
import { ProjectIcon, ProjectPanel, ProjectTag } from '@/features/projects/components/project-ui';
import { useCollaboration } from '@/features/collaboration/context/collaboration-context';
import { getDemoProgress } from '@/features/collaboration/data/demo-members';

function MyProjectCard({ project, userId, memberRole, memberCount }: {
  project: DemoProject; userId: string; memberRole: string; memberCount: number;
}) {
  const theme = useTheme();
  const progress = getDemoProgress(project.id);
  return (
    <Pressable accessibilityRole="button" accessibilityLabel={`Abrir ${project.name}`}
      onPress={() => router.push({ pathname: '/mi-proyecto/[id]', params: { id: project.id } })}>
      <ProjectPanel>
        <View style={styles.cardHeading}>
          <ProjectIcon project={project} size={54} />
          <View style={{ flex: 1, gap: 3 }}>
            <Text style={[styles.projectName, { color: theme.text }]}>{project.name}</Text>
            <Text style={{ color: theme.textSecondary, fontSize: 11 }}>{project.category}</Text>
          </View>
          <SymbolView name={{ ios: 'chevron.right', android: 'chevron_right', web: 'chevron_right' }}
            size={23} tintColor={theme.primary} />
        </View>
        <ProjectTag label={`${memberCount} integrantes`} />
        <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
          Rol: {project.leaderId === userId ? 'Líder' : memberRole}
        </Text>
        <View style={styles.progressHeader}>
          <Text style={{ color: theme.textSecondary, fontSize: 12 }}>Progreso:</Text>
          <Text style={{ color: theme.primary, fontSize: 12, fontWeight: '700' }}>{progress}%</Text>
        </View>
        <View style={[styles.progressTrack, { backgroundColor: theme.backgroundSelected }]}>
          <View style={[styles.progressFill, { backgroundColor: theme.primary, width: `${progress}%` }]} />
        </View>
      </ProjectPanel>
    </Pressable>
  );
}

export default function MisProyectosScreen() {
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { projects, currentUser } = useDemoProjects();
  const { membersFor } = useCollaboration();
  const [query, setQuery] = useState('');
  const visibleProjects = useMemo(() => projects.filter(project =>
    membersFor(project.id).some(member => member.id === currentUser.id)
    && matchesProject(project, query),
  ), [projects, currentUser.id, query, membersFor]);

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={{ flex: 1 }}>
      <AppScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <View style={styles.content}>
          <Text style={[styles.title, { color: theme.text }]}>Mis proyectos</Text>
          <View style={[styles.searchCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
            <SymbolView name={{ ios: 'magnifyingglass', android: 'search', web: 'search' }}
              size={22} tintColor={theme.primary} />
            <TextInput value={query} onChangeText={setQuery} placeholder="Buscar por nombre o categoría"
              placeholderTextColor={theme.textSecondary} style={[styles.search, { color: theme.text }]}
              accessibilityLabel="Buscar en mis proyectos" />
            {!!query && <Pressable onPress={() => setQuery('')} accessibilityLabel="Limpiar búsqueda">
              <SymbolView name={{ ios: 'xmark.circle.fill', android: 'cancel', web: 'cancel' }}
                size={20} tintColor={theme.icon} />
            </Pressable>}
          </View>
          {visibleProjects.length ? visibleProjects.map(project => (
            <MyProjectCard key={project.id} project={project} userId={currentUser.id}
              memberRole={membersFor(project.id).find(m => m.id === currentUser.id)?.role ?? 'Integrante'}
              memberCount={membersFor(project.id).length} />
          )) : (
            <ProjectPanel>
              <Text style={{ color: theme.textSecondary, textAlign: 'center' }}>
                No encontramos proyectos en los que participes con ese criterio.
              </Text>
            </ProjectPanel>
          )}
        </View>
      </AppScrollView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  scroll: { alignItems: 'center', paddingBottom: 32 },
  content: { width: '100%', maxWidth: 640, paddingHorizontal: 24, paddingTop: 20, gap: 18 },
  title: { fontSize: 24, fontWeight: '700', lineHeight: 34 },
  searchCard: { borderWidth: 1, borderRadius: 24, flexDirection: 'row', alignItems: 'center',
    paddingHorizontal: 16, minHeight: 62, gap: 12 },
  search: { flex: 1, fontSize: 14, paddingVertical: 10 },
  cardHeading: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  projectName: { fontSize: 17, fontWeight: '700' },
  progressHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  progressTrack: { height: 7, borderRadius: 5, overflow: 'hidden' },
  progressFill: { height: '100%', borderRadius: 5 },
});
