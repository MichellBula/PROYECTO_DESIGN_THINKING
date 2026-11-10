import { useEffect, useState } from 'react';
import { router, useLocalSearchParams } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';
import { Pressable, StyleSheet, Text, TextInput, View } from 'react-native';
import { AppScrollView } from '@/components/ui/app-scroll-view';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { ChatAvatar, ChatBackTitle, ChatButton, ChatPanel } from '@/features/collaboration/components/chat-ui';
import { useCollaboration } from '@/features/collaboration/context/collaboration-context';

export default function GroupEditorScreen() {
  const { projectId, roomId } = useLocalSearchParams<{ projectId: string; roomId?: string }>();
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { projects, currentUser } = useDemoProjects();
  const { rooms, membersFor, createGroup, updateGroup } = useCollaboration();
  const project = projects.find(item => item.id === projectId);
  const editRoom = roomId ? rooms.find(item => item.id === roomId && item.projectId === projectId && item.type === 'group') : null;
  const isLeader = !!project && project.leaderId === currentUser.id;
  const members = project ? membersFor(project.id) : [];
  const candidates = members.filter(member => member.id !== project?.leaderId);
  const [name, setName] = useState('');
  const [selected, setSelected] = useState<string[]>([]);
  const [error, setError] = useState('');

  // Inicializa los campos cuando se abre un grupo existente.
  useEffect(() => {
    setName(editRoom?.name ?? '');
    setSelected(editRoom?.members.filter(id => id !== project?.leaderId) ?? []);
    setError('');
  }, [editRoom?.id, project?.leaderId]);

  function toggleMember(id: string) {
    setError('');
    setSelected(current => current.includes(id)
      ? current.filter(value => value !== id)
      : [...current, id]);
  }

  function saveGroup() {
    if (!project) return;
    const result = editRoom
      ? updateGroup(editRoom.id, name, selected)
      : createGroup(project.id, name, selected);
    if (!result.ok) {
      setError(result.message);
      return;
    }
    router.replace({ pathname: '/chats/[projectId]/[roomId]',
      params: { projectId, roomId: result.roomId } });
  }

  if (!isLeader || (roomId && !editRoom)) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', gap: 20,
        padding: 24, backgroundColor: theme.background }}>
        <Text style={{ color: theme.text }}>
          {isLeader ? 'El grupo solicitado no existe.' : 'Solo el líder del proyecto puede crear o editar grupos.'}
        </Text>
        <ChatButton label="Volver a chats" onPress={() => router.replace({
          pathname: '/chats/[projectId]', params: { projectId },
        })} />
      </View>
    );
  }

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={{ flex: 1 }}>
      <AppScrollView keyboardShouldPersistTaps="handled" contentContainerStyle={styles.scroll}>
        <View style={styles.content}>
          <ChatBackTitle title={editRoom ? 'Editar grupo' : 'Crear grupo'}
            onBack={() => router.replace({ pathname: '/chats/[projectId]', params: { projectId } })} />
          <Text style={{ color: theme.textSecondary, fontSize: 13, lineHeight: 20 }}>
            Elige a los integrantes de {project?.name}. El líder estará siempre incluido.
          </Text>

          <ChatPanel>
            <Text style={[styles.label, { color: theme.text }]}>Nombre del chat grupal</Text>
            <TextInput value={name} onChangeText={value => { setName(value); setError(''); }}
              maxLength={60} placeholder="Ej.: Diseño del prototipo"
              placeholderTextColor={theme.textSecondary}
              accessibilityLabel="Nombre del grupo"
              style={[styles.input, { backgroundColor: theme.inputBackground,
                borderColor: theme.border, color: theme.text }]} />
            <Text style={{ color: theme.textSecondary, fontSize: 11 }}>{name.length}/60 caracteres</Text>
          </ChatPanel>

          <ChatPanel>
            <Text style={[styles.label, { color: theme.text }]}>Integrantes seleccionados</Text>
            <View style={styles.selectHeader}>
              <Text style={{ color: theme.primary, fontWeight: '700' }}>
                {selected.length + 1} de {members.length} · Mínimo 3
              </Text>
              <Pressable accessibilityRole="button"
                onPress={() => setSelected(selected.length === candidates.length
                  ? [] : candidates.map(member => member.id))}>
                <Text style={{ color: theme.primary, fontWeight: '600', fontSize: 12 }}>
                  {selected.length === candidates.length ? 'Quitar todos' : 'Seleccionar todos'}
                </Text>
              </Pressable>
            </View>
            <View style={styles.memberRow}>
              <ChatAvatar name={currentUser.name} size={44} />
              <View style={{ flex: 1, gap: 4 }}>
                <Text style={{ color: theme.text, fontWeight: '700' }}>{currentUser.name}</Text>
                <Text style={{ color: theme.textSecondary, fontSize: 12 }}>Líder · Obligatorio</Text>
              </View>
              <SymbolView name={{ ios: 'checkmark.circle.fill', android: 'check_circle', web: 'check_circle' }}
                size={24} tintColor={theme.primary} />
            </View>
            {candidates.map(member => {
              const checked = selected.includes(member.id);
              return (
                <Pressable accessibilityRole="checkbox" accessibilityState={{ checked }}
                  accessibilityLabel={`Incluir a ${member.name}`} key={member.id}
                  onPress={() => toggleMember(member.id)} style={styles.memberRow}>
                  <ChatAvatar name={member.name} size={44} />
                  <View style={{ flex: 1, gap: 4 }}>
                    <Text style={{ color: theme.text, fontWeight: '600' }}>{member.name}</Text>
                    <Text style={{ color: theme.textSecondary, fontSize: 12 }}>{member.role}</Text>
                  </View>
                  <SymbolView name={{ ios: checked ? 'checkmark.circle.fill' : 'circle',
                    android: checked ? 'check_circle' : 'radio_button_unchecked',
                    web: checked ? 'check_circle' : 'radio_button_unchecked' }}
                    size={24} tintColor={checked ? theme.primary : theme.icon} />
                </Pressable>
              );
            })}
          </ChatPanel>

          {members.length < 3 && (
            <Text style={{ color: theme.textSecondary, lineHeight: 19 }}>
              Este proyecto aún no tiene suficientes integrantes. Debes contar con al menos 2 personas además del líder.
            </Text>
          )}
          {!!error && <Text accessibilityRole="alert" style={{ color: theme.danger }}>{error}</Text>}
          <View style={styles.actions}>
            <View style={{ flex: 1 }}>
              <ChatButton label="Cancelar" secondary onPress={() => router.back()} />
            </View>
            <View style={{ flex: 1 }}>
              <ChatButton label={editRoom ? 'Guardar cambios' : 'Crear grupo'} onPress={saveGroup}
                disabled={selected.length < 2 || members.length < 3 || name.trim().length < 3} />
            </View>
          </View>
        </View>
      </AppScrollView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  scroll: { alignItems: 'center', paddingBottom: 36 },
  content: { width: '100%', maxWidth: 640, paddingHorizontal: 24, paddingTop: 18, gap: 20 },
  label: { fontSize: 15, fontWeight: '700' },
  selectHeader: { flexDirection: 'row', justifyContent: 'space-between', gap: 10, alignItems: 'center' },
  input: { borderWidth: 1, borderRadius: 16, minHeight: 52, paddingHorizontal: 14, fontSize: 14 },
  memberRow: { flexDirection: 'row', gap: 12, alignItems: 'center', paddingVertical: 8 },
  actions: { flexDirection: 'row', gap: 12 },
});
