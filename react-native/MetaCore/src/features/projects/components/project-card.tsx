import { useState } from 'react';
import { Pressable, StyleSheet, Text, View } from 'react-native';
import { useTheme } from '@/hooks/use-theme';
import { formatClosingDate, isProjectOpen, type DemoProject } from '../data/mock-projects';
import { ProjectIcon, ProjectPanel, ProjectTag } from './project-ui';

type Props = { project: DemoProject; onOpen: () => void };

export function ProjectCard({ project, onOpen }: Props) {
  const theme = useTheme();
  const [menuOpen, setMenuOpen] = useState(false);
  const open = isProjectOpen(project);

  return (
    <ProjectPanel>
      <View style={styles.header}>
        <Pressable onPress={onOpen} accessibilityRole="button"
          accessibilityLabel={`Ver detalles de ${project.name}`} style={styles.identity}>
          <ProjectIcon project={project} />
          <View style={{ flex: 1, gap: 5 }}>
            <Text style={[styles.name, { color: theme.text }]} numberOfLines={2}>Nombre: {project.name}</Text>
            <Text style={[styles.leader, { color: theme.textSecondary }]} numberOfLines={1}>Líder: {project.leader}</Text>
          </View>
        </Pressable>
        <Pressable accessibilityRole="button" accessibilityLabel={`Opciones de ${project.name}`}
          onPress={() => setMenuOpen(value => !value)} style={styles.more}>
          <Text style={{ color: theme.textSecondary, fontSize: 22, fontWeight: '700' }}>···</Text>
        </Pressable>
      </View>
      {menuOpen && (
        <Pressable onPress={() => { setMenuOpen(false); onOpen(); }}
          style={[styles.menu, { backgroundColor: theme.backgroundSelected }]}>
          <Text style={{ color: theme.text }}>Ver detalles del proyecto</Text>
        </Pressable>
      )}
      <Pressable onPress={onOpen} accessibilityRole="button" style={styles.tags}>
        <View style={{ flex: 1 }}><ProjectTag label={`Integrantes: ${project.members}`} /></View>
        <View style={{ flex: 1 }}><ProjectTag label={`Vacantes: ${project.vacancies}`} /></View>
      </Pressable>
      <View style={styles.footer}>
        <Text style={{ color: theme.textSecondary, fontSize: 11 }}>
          Fecha cierre: {formatClosingDate(project.closingDate)}
        </Text>
        {!open && <Text style={{ color: theme.primary, fontSize: 11, fontWeight: '700' }}>Inspiración</Text>}
      </View>
    </ProjectPanel>
  );
}

const styles = StyleSheet.create({
  header: { flexDirection: 'row', alignItems: 'flex-start' },
  identity: { flexDirection: 'row', alignItems: 'center', flex: 1, gap: 12 },
  more: { width: 30, height: 34, alignItems: 'center', justifyContent: 'center' },
  name: { fontSize: 16, lineHeight: 22, fontWeight: '600' },
  leader: { fontSize: 11 },
  tags: { flexDirection: 'row', gap: 10 },
  footer: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  menu: { padding: 12, borderRadius: 12 },
});
