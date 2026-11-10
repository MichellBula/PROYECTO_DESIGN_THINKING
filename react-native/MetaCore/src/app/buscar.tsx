import { useMemo, useState } from 'react';
import { router } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';
import { Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { ProjectCard } from '@/features/projects/components/project-card';
import { ProjectPanel } from '@/features/projects/components/project-ui';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { isProjectOpen, matchesProject } from '@/features/projects/data/mock-projects';

type SearchTab = 'disponibles' | 'inspiracion';

export default function BuscarScreen() {
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { projects } = useDemoProjects();
  const [tab, setTab] = useState<SearchTab>('disponibles');
  const [query, setQuery] = useState('');
  const [filters, setFilters] = useState<string[]>([]);

  function addFilter() {
    const clean = query.trim();
    if (clean && !filters.some(item => item.toLowerCase() === clean.toLowerCase())) {
      setFilters(items => [...items, clean]);
    }
    setQuery('');
  }

  const visibleProjects = useMemo(() => projects.filter(project => {
    const available = isProjectOpen(project);
    return (tab === 'disponibles' ? available : !available) &&
      filters.every(filter => matchesProject(project, filter)) &&
      (!query.trim() || matchesProject(project, query));
  }), [projects, filters, query, tab]);

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={styles.root}>
      <ScrollView showsVerticalScrollIndicator={false} keyboardShouldPersistTaps="handled"
        contentContainerStyle={styles.content}>
        <Text style={[styles.title, { color: theme.text }]}>¡Encuentra proyectos disponibles!</Text>

        {/* Igual que Flutter: alternar convocatorias e inspiración. */}
        <View style={[styles.tabs, { backgroundColor: theme.backgroundSelected }]}>
          {(['disponibles', 'inspiracion'] as const).map(item => (
            <Pressable key={item} accessibilityRole="button" accessibilityState={{ selected: tab === item }}
              onPress={() => { setTab(item); setQuery(''); setFilters([]); }}
              style={[styles.tab, tab === item && { backgroundColor: theme.primary }]}>
              <Text style={{ color: tab === item ? theme.onPrimary : theme.textSecondary,
                fontWeight: '600', fontSize: 12 }}>
                {item === 'disponibles' ? 'Disponibles' : 'Inspiración'}
              </Text>
            </Pressable>
          ))}
        </View>

        <ProjectPanel style={{ padding: 16 }}>
          <View style={[styles.searchBar, { backgroundColor: theme.badgeBackground }]}>
            <TextInput
              value={query} onChangeText={setQuery} onSubmitEditing={addFilter}
              placeholder="Buscar por categoría, rol o nombre"
              placeholderTextColor={theme.textSecondary}
              accessibilityLabel="Buscar proyectos"
              returnKeyType="search"
              style={[styles.searchInput, { color: theme.text }]}
            />
            <Pressable accessibilityRole="button" accessibilityLabel="Agregar filtro"
              onPress={addFilter} style={styles.searchButton}>
              <SymbolView name={{ ios: 'magnifyingglass', android: 'search', web: 'search' }}
                size={22} tintColor={theme.primary} />
            </Pressable>
          </View>
        </ProjectPanel>

        {filters.length > 0 && (
          <View style={styles.filters}>
            {filters.map(filter => (
              <Pressable key={filter} accessibilityRole="button"
                accessibilityLabel={`Quitar filtro ${filter}`}
                onPress={() => setFilters(items => items.filter(item => item !== filter))}
                style={[styles.chip, { backgroundColor: theme.badgeBackground }]}>
                <Text style={{ color: theme.primary, fontSize: 11 }}>{filter}  ×</Text>
              </Pressable>
            ))}
            <Pressable onPress={() => { setFilters([]); setQuery(''); }} style={styles.chip}>
              <Text style={{ color: theme.primary, fontSize: 11 }}>Limpiar</Text>
            </Pressable>
          </View>
        )}

        <View style={styles.headingRow}>
          <Text style={[styles.heading, { color: theme.text }]}>
            {tab === 'disponibles' ? 'Grupos disponibles:' : 'Proyectos anteriores:'}
          </Text>
          <Text style={[styles.counter, { color: theme.primary }]}>{visibleProjects.length}</Text>
        </View>

        {visibleProjects.length ? visibleProjects.map(project => (
          <ProjectCard key={project.id} project={project}
            onOpen={() => router.push({ pathname: '/proyecto/[id]', params: { id: project.id } })} />
        )) : (
          <ProjectPanel>
            <Text style={{ color: theme.text, fontWeight: '600' }}>Sin resultados</Text>
            <Text style={{ color: theme.textSecondary }}>
              {tab === 'disponibles' ? 'No encontramos convocatorias con esos filtros.'
                : 'Todavía no hay proyectos anteriores con esos filtros.'}
            </Text>
          </ProjectPanel>
        )}
      </ScrollView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1 },
  content: { width: '100%', maxWidth: 640, alignSelf: 'center', paddingHorizontal: 24,
    paddingTop: 18, paddingBottom: 30, gap: 18 },
  title: { fontSize: 24, lineHeight: 34, fontWeight: '700' },
  tabs: { flexDirection: 'row', borderRadius: 20, padding: 4, gap: 4 },
  tab: { flex: 1, minHeight: 40, justifyContent: 'center', alignItems: 'center', borderRadius: 16 },
  searchBar: { flexDirection: 'row', minHeight: 46, borderRadius: 28, alignItems: 'center' },
  searchInput: { flex: 1, minWidth: 0, paddingLeft: 16, paddingVertical: 12, fontSize: 13 },
  searchButton: { width: 46, height: 46, alignItems: 'center', justifyContent: 'center' },
  filters: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  chip: { paddingHorizontal: 12, paddingVertical: 8, borderRadius: 12 },
  headingRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  heading: { fontSize: 16, fontWeight: '600' },
  counter: { fontSize: 16, fontWeight: '700' },
});
