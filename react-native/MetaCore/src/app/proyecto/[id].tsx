import { router, useLocalSearchParams } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { formatClosingDate, isProjectOpen } from '@/features/projects/data/mock-projects';
import {
  PrimaryProjectButton, ProjectBackTitle, ProjectIcon, ProjectPanel, ProjectTag,
} from '@/features/projects/components/project-ui';

export default function ProyectoDisponibleScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { projects, currentUser, applications } = useDemoProjects();
  const project = projects.find(item => item.id === id);

  if (!project) return (
    <View style={[styles.root, { backgroundColor: theme.background, padding: 24 }]}>
      <ProjectBackTitle title="Proyecto no encontrado" />
      <Text style={{ color: theme.textSecondary }}>No pudimos encontrar este proyecto de ejemplo.</Text>
    </View>
  );

  const open = isProjectOpen(project);
  const own = project.leaderId === currentUser.id;
  const existing = applications.find(item => item.projectId === project.id && item.applicantId === currentUser.id);
  const canApply = open && !own && !existing;
  const buttonText = !open ? 'Convocatoria cerrada' : own ? 'Eres líder de este proyecto'
    : existing ? `Solicitud ${existing.status}` : 'Postularse';

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={styles.root}>
      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.content}>
        <ProjectBackTitle title={open ? 'Proyecto disponible' : 'Proyecto de inspiración'} />

        <ProjectPanel style={{ padding: 22 }}>
          <View style={styles.identity}>
            <ProjectIcon project={project} size={72} />
            <View style={{ flex: 1, gap: 6 }}>
              <Text style={[styles.projectName, { color: theme.text }]}>{project.name}</Text>
              <Text style={{ color: theme.textSecondary, fontSize: 12 }}>{project.category}</Text>
            </View>
          </View>
          <Text style={{ color: theme.textSecondary, fontSize: 12 }}>Líder: {project.leader}</Text>
          <View style={styles.badges}>
            <ProjectTag label={`${project.members} integrantes`} />
            <ProjectTag label={`${project.vacancies} vacantes`} accent />
          </View>
        </ProjectPanel>

        <Text style={[styles.section, { color: theme.text }]}>Roles disponibles:</Text>
        <View style={styles.tags}>
          {project.roles.map(role => <ProjectTag key={role.id}
            label={`${role.name} (${role.quantity})`} />)}
        </View>

        <ProjectPanel>
          <Text style={[styles.section, { color: theme.text }]}>Descripción:</Text>
          <Text style={[styles.body, { color: theme.textSecondary }]}>{project.description}</Text>
        </ProjectPanel>

        <ProjectPanel>
          <Text style={[styles.section, { color: theme.text }]}>Requisitos:</Text>
          {project.requirements.map(req => (
            <Text key={req} style={[styles.body, { color: theme.textSecondary }]}>•  {req}</Text>
          ))}
        </ProjectPanel>

        <ProjectPanel>
          <Text style={[styles.section, { color: theme.text }]}>Habilidades relacionadas:</Text>
          <View style={styles.tags}>{project.skills.map(skill => <ProjectTag key={skill} label={skill} />)}</View>
          <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
            Cierre de convocatoria: {formatClosingDate(project.closingDate)}
          </Text>
        </ProjectPanel>
      </ScrollView>

      {/* Acción fija en la parte inferior; la barra de pestañas está oculta. */}
      <View style={[styles.footer, { backgroundColor: theme.background, borderColor: theme.border }]}>
        <PrimaryProjectButton title={buttonText} disabled={!canApply}
          onPress={() => router.push({ pathname: '/postular/[id]', params: { id: project.id } })} />
      </View>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  content: { alignSelf: 'center', width: '100%', maxWidth: 640,
    paddingHorizontal: 24, paddingTop: 18, paddingBottom: 30, gap: 18 },
  identity: { flexDirection: 'row', alignItems: 'center', gap: 16 },
  projectName: { fontSize: 23, lineHeight: 31, fontWeight: '700' },
  badges: { flexDirection: 'row', gap: 10, flexWrap: 'wrap' },
  section: { fontSize: 16, lineHeight: 22, fontWeight: '600' },
  body: { fontSize: 14, lineHeight: 20 },
  tags: { flexDirection: 'row', flexWrap: 'wrap', gap: 10 },
  footer: { paddingVertical: 14, paddingHorizontal: 24, borderTopWidth: 1 },
});
