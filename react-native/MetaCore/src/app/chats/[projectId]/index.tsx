import { useState } from 'react';
import { router, useLocalSearchParams } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';
import { Modal, Pressable, StyleSheet, Text, View } from 'react-native';
import { AppScrollView } from '@/components/ui/app-scroll-view';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { ChatAvatar, ChatBackTitle, ChatButton, ChatPanel } from '@/features/collaboration/components/chat-ui';
import { useCollaboration, type ChatRoom } from '@/features/collaboration/context/collaboration-context';

export default function ProjectChatsScreen() {
  const { projectId } = useLocalSearchParams<{ projectId: string }>();
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { projects, currentUser } = useDemoProjects();
  const { visibleRooms, membersFor, messages, canAccessProject,
    startPrivateChat, deleteGroup } = useCollaboration();
  const [error, setError] = useState('');
  const [deleteTarget, setDeleteTarget] = useState<ChatRoom | null>(null);
  // Solo se muestra un menú desplegable de grupo a la vez.
  const [openMenuId, setOpenMenuId] = useState<string | null>(null);
  const project = projects.find(item => item.id === projectId);
  const accessible = project ? canAccessProject(project.id) : false;
  const members = project ? membersFor(project.id) : [];
  const isLeader = project?.leaderId === currentUser.id;
  const rooms = accessible ? visibleRooms(projectId) : [];
  const groups = rooms.filter(room => room.type === 'group');
  const privates = rooms.filter(room => room.type === 'private');

  function openRoom(roomId: string) {
    setOpenMenuId(null);
    router.push({ pathname: '/chats/[projectId]/[roomId]', params: { projectId, roomId } });
  }

  function openPrivate(memberId: string) {
    const result = startPrivateChat(projectId, memberId);
    if (result.ok) openRoom(result.roomId);
    else setError(result.message);
  }

  function confirmDelete() {
    if (!deleteTarget) return;
    const result = deleteGroup(deleteTarget.id);
    setDeleteTarget(null);
    if (!result.ok) setError(result.message);
  }

  function lastMessage(room: ChatRoom): string {
    const match = messages.filter(message => message.roomId === room.id).at(-1);
    return match?.text ?? 'Comienza la conversación';
  }

  if (!project || !accessible) {
    return <View style={{ flex: 1, padding: 24, backgroundColor: theme.background, gap: 20 }}>
      <Text style={{ color: theme.text }}>No tienes acceso a los chats de este proyecto.</Text>
      <ChatButton label="Volver a Mis proyectos" onPress={() => router.replace('/mis-proyectos')} />
    </View>;
  }

  return (
    <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
      locations={[0, 0.24, 0.6, 1]} style={{ flex: 1 }}>
      <AppScrollView contentContainerStyle={styles.scroll}>
        <View style={styles.content}>
          <ChatBackTitle title="Chats del proyecto" onBack={() => router.replace({ pathname: '/mi-proyecto/[id]', params: { id: projectId } })} />
          <Text style={{ color: theme.textSecondary, fontSize: 13 }}>{project.name}</Text>

          {error ? <Text accessibilityRole="alert" style={{ color: theme.danger }}>{error}</Text> : null}

          <Text style={[styles.heading, { color: theme.text }]}>Chats grupales</Text>
          {isLeader && (
            <ChatButton label="+ Crear chat grupal" onPress={() => router.push({
              pathname: '/chats/[projectId]/grupo', params: { projectId },
            })} />
          )}
          {isLeader && members.length < 3 && (
            <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
              Necesitas al menos tres integrantes en el proyecto para crear un grupo.
            </Text>
          )}
          {groups.length ? groups.map(room => (
            <ChatPanel key={room.id}>
              <View style={styles.groupHeader}>
                {/* Abrir el chat y administrar el grupo son acciones distintas. */}
                <Pressable
                  onPress={() => openRoom(room.id)}
                  accessibilityRole="button"
                  accessibilityLabel={`Abrir grupo ${room.name}`}
                  style={[styles.chatRow, styles.groupOpenButton]}
                >
                  <ChatAvatar name={room.name} group />
                  <View style={{ flex: 1, gap: 5 }}>
                    <Text style={[styles.chatName, { color: theme.text }]}>{room.name}</Text>
                    <Text style={{ color: theme.textSecondary, fontSize: 11 }} numberOfLines={1}>
                      {room.members.length} integrantes · {lastMessage(room)}
                    </Text>
                  </View>
                </Pressable>

                {/* Solo el líder puede abrir el menú de administración. */}
                {isLeader ? (
                  <Pressable
                    accessibilityRole="button"
                    accessibilityLabel={`Opciones del grupo ${room.name}`}
                    accessibilityState={{ expanded: openMenuId === room.id }}
                    onPress={() => setOpenMenuId(current => current === room.id ? null : room.id)}
                    style={[styles.menuTrigger, {
                      backgroundColor: openMenuId === room.id ? theme.backgroundSelected : theme.cardTint,
                    }]}
                  >
                    <SymbolView
                      name={{ ios: 'ellipsis', android: 'more_vert', web: 'more_vert' }}
                      size={23}
                      tintColor={theme.primary}
                    />
                  </Pressable>
                ) : (
                  <SymbolView
                    name={{ ios: 'chevron.right', android: 'chevron_right', web: 'chevron_right' }}
                    tintColor={theme.primary}
                    size={22}
                  />
                )}
              </View>

              {/* Las acciones se muestran solamente al desplegar el menú. */}
              {isLeader && openMenuId === room.id && (
                <View style={[styles.groupMenu, {
                  backgroundColor: theme.cardTint,
                  borderColor: theme.border,
                }]}>
                  <Pressable
                    accessibilityRole="button"
                    accessibilityLabel={`Editar grupo ${room.name}`}
                    onPress={() => {
                      setOpenMenuId(null);
                      router.push({
                        pathname: '/chats/[projectId]/grupo',
                        params: { projectId, roomId: room.id },
                      });
                    }}
                    style={styles.menuOption}
                  >
                    <SymbolView
                      name={{ ios: 'pencil', android: 'edit', web: 'edit' }}
                      size={19}
                      tintColor={theme.primary}
                    />
                    <Text style={[styles.menuText, { color: theme.text }]}>Editar grupo</Text>
                  </Pressable>

                  <View style={[styles.menuDivider, { backgroundColor: theme.border }]} />

                  <Pressable
                    accessibilityRole="button"
                    accessibilityLabel={`Eliminar grupo ${room.name}`}
                    onPress={() => {
                      setOpenMenuId(null);
                      setDeleteTarget(room);
                    }}
                    style={styles.menuOption}
                  >
                    <SymbolView
                      name={{ ios: 'trash', android: 'delete', web: 'delete' }}
                      size={19}
                      tintColor={theme.danger}
                    />
                    <Text style={[styles.menuText, { color: theme.danger }]}>Eliminar grupo</Text>
                  </Pressable>
                </View>
              )}
            </ChatPanel>
          )) : (
            <Text style={{ color: theme.textSecondary, fontSize: 13 }}>
              No hay grupos visibles para ti. El líder puede crear uno con al menos tres integrantes.
            </Text>
          )}

          <Text style={[styles.heading, { color: theme.text }]}>Conversaciones privadas</Text>
          {privates.length > 0 && privates.map(room => {
            const personId = room.members.find(id => id !== currentUser.id);
            const person = members.find(member => member.id === personId);
            return (
              <Pressable key={room.id} accessibilityRole="button"
                onPress={() => openRoom(room.id)}>
                <ChatPanel>
                  <View style={styles.chatRow}>
                    <ChatAvatar name={person?.name ?? room.name} />
                    <View style={{ flex: 1, gap: 5 }}>
                      <Text style={[styles.chatName, { color: theme.text }]}>{person?.name ?? room.name}</Text>
                      <Text style={{ color: theme.textSecondary, fontSize: 12 }} numberOfLines={1}>
                        {lastMessage(room)}
                      </Text>
                    </View>
                    <SymbolView name={{ ios: 'chevron.right', android: 'chevron_right', web: 'chevron_right' }}
                      tintColor={theme.primary} size={22} />
                  </View>
                </ChatPanel>
              </Pressable>
            );
          })}

          <Text style={[styles.heading, { color: theme.text }]}>Hablar con un integrante</Text>
          <ChatPanel>
            {members.filter(member => member.id !== currentUser.id).map(member => (
              <Pressable key={member.id} accessibilityRole="button"
                accessibilityLabel={`Conversar con ${member.name}`}
                onPress={() => openPrivate(member.id)} style={styles.memberRow}>
                <ChatAvatar name={member.name} size={42} />
                <View style={{ flex: 1, gap: 3 }}>
                  <Text style={{ color: theme.text, fontWeight: '600' }}>{member.name}</Text>
                  <Text style={{ color: theme.textSecondary, fontSize: 11 }}>{member.role}</Text>
                </View>
                <SymbolView name={{ ios: 'bubble.left', android: 'chat_bubble_outline', web: 'chat_bubble_outline' }}
                  tintColor={theme.primary} size={23} />
              </Pressable>
            ))}
          </ChatPanel>
        </View>
      </AppScrollView>

      {/* Modal propio: funciona tanto en web como en Android/iOS. */}
      <Modal transparent visible={!!deleteTarget} animationType="fade"
        onRequestClose={() => setDeleteTarget(null)}>
        <View style={styles.modalBackdrop}>
          <View style={[styles.modalCard, { backgroundColor: theme.card, borderColor: theme.border }]}>
            <Text style={[styles.heading, { color: theme.text }]}>Eliminar grupo</Text>
            <Text style={{ color: theme.textSecondary, lineHeight: 22 }}>
              ¿Eliminar «{deleteTarget?.name}»? Se borrarán sus mensajes de demostración.
            </Text>
            <View style={styles.actions}>
              <View style={{ flex: 1 }}><ChatButton label="Cancelar" secondary onPress={() => setDeleteTarget(null)} /></View>
              <View style={{ flex: 1 }}><ChatButton label="Eliminar" onPress={confirmDelete} /></View>
            </View>
          </View>
        </View>
      </Modal>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  scroll: { alignItems: 'center', paddingBottom: 36 },
  content: { width: '100%', maxWidth: 640, paddingTop: 18, paddingHorizontal: 24, gap: 18 },
  heading: { fontWeight: '700', fontSize: 18 },
  chatRow: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  groupHeader: { flexDirection: 'row', alignItems: 'center', gap: 9 },
  groupOpenButton: { flex: 1, minWidth: 0 },
  menuTrigger: { width: 42, height: 42, borderRadius: 14,
    alignItems: 'center', justifyContent: 'center' },
  groupMenu: { alignSelf: 'flex-end', minWidth: 198, padding: 6,
    borderWidth: 1, borderRadius: 16, gap: 3 },
  menuOption: { flexDirection: 'row', alignItems: 'center', gap: 10,
    minHeight: 42, paddingHorizontal: 12, borderRadius: 11 },
  menuDivider: { height: 1, marginHorizontal: 8 },
  menuText: { fontSize: 13, fontWeight: '600' },
  chatName: { fontSize: 15, fontWeight: '700' },
  memberRow: { flexDirection: 'row', gap: 12, alignItems: 'center', paddingVertical: 7 },
  actions: { flexDirection: 'row', alignItems: 'center', gap: 14, justifyContent: 'flex-end' },
  modalBackdrop: { flex: 1, backgroundColor: 'rgba(10,20,45,0.5)',
    justifyContent: 'center', padding: 24 },
  modalCard: { width: '100%', maxWidth: 440, alignSelf: 'center',
    borderWidth: 1, padding: 22, borderRadius: 24, gap: 18 },
});
