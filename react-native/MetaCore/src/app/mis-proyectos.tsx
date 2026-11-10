import { router } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { StyleSheet, Text, View } from 'react-native';
import { AppScrollView } from '@/components/ui/app-scroll-view';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { ProjectCard } from '@/features/projects/components/project-card';
import { useDemoProjects } from '@/features/projects/context/projects-context';

// Listado provisional para comprobar proyectos creados antes de migrar Mis proyectos.
export default function MisProyectosScreen() {
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { projects, currentUser } = useDemoProjects();
  const owned = projects.filter(project => project.leaderId === currentUser.id);

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={{ flex: 1 }}>
      <AppScrollView contentContainerStyle={styles.content}>
        <View style={styles.inner}>
          <Text style={[styles.title, { color: theme.text }]}>Mis proyectos</Text>
          <Text style={[styles.intro, { color: theme.textSecondary }]}>
            Estos proyectos pertenecen al usuario de demostración. La pantalla completa de gestión, chat y tablero se implementará después.
          </Text>
          {owned.length ? owned.map(project => (
            <ProjectCard key={project.id} project={project}
              onOpen={() => router.push({ pathname: '/proyecto/[id]', params: { id: project.id } })} />
          )) : (
            <Text style={{ color: theme.textSecondary }}>Todavía no tienes proyectos.</Text>
          )}
        </View>
      </AppScrollView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  content: { alignItems: 'center', paddingBottom: 30 },
  inner: { width: '100%', maxWidth: 640, paddingHorizontal: 24, paddingTop: 20, gap: 18 },
  title: { fontSize: 24, lineHeight: 34, fontWeight: '700' },
  intro: { fontSize: 13, lineHeight: 20 },
});
