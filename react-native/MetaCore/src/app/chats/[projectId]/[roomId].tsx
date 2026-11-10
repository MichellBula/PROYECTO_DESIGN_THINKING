import { useMemo, useRef, useState } from 'react';
import { router, useLocalSearchParams } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';
import { KeyboardAvoidingView, Platform, Pressable, ScrollView, StyleSheet,
  Text, TextInput, View } from 'react-native';
import { BackgroundGradients } from '@/constants/theme';
import { useTheme, useThemeSettings } from '@/hooks/use-theme';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { ChatAvatar, ChatBackTitle, ChatButton } from '@/features/collaboration/components/chat-ui';
import { useCollaboration } from '@/features/collaboration/context/collaboration-context';

export default function ConversationScreen() {
  const { projectId, roomId } = useLocalSearchParams<{ projectId: string; roomId: string }>();
  const theme = useTheme();
  const { isDark } = useThemeSettings();
  const { projects, currentUser } = useDemoProjects();
  const { rooms, messages, membersFor, sendMessage, canAccessProject } = useCollaboration();
  const [draft, setDraft] = useState('');
  const [error, setError] = useState('');
  const listRef = useRef<ScrollView>(null);
  const project = projects.find(item => item.id === projectId);
  const room = rooms.find(item => item.id === roomId && item.projectId === projectId);
  const allowed = !!project && !!room && room.members.includes(currentUser.id)
    && canAccessProject(projectId);
  const members = project ? membersFor(project.id) : [];
  const roomMessages = useMemo(() => messages.filter(message => message.roomId === roomId)
    .sort((a, b) => a.sentAt.localeCompare(b.sentAt)), [messages, roomId]);
  const isLeader = project?.leaderId === currentUser.id;
  const peer = room?.type === 'private'
    ? members.find(member => member.id === room.members.find(id => id !== currentUser.id)) : null;
  const title = room?.type === 'private' ? (peer?.name ?? room?.name) : room?.name;

  function submit() {
    if (!room) return;
    const result = sendMessage(room.id, draft);
    if (result.ok) { setDraft(''); setError(''); }
    else setError(result.message);
  }

  if (!allowed || !room) {
    return (
      <View style={{ flex: 1, padding: 24, backgroundColor: theme.background, gap: 20 }}>
        <Text style={{ color: theme.text }}>No tienes acceso a esta conversación o ya fue eliminada.</Text>
        <ChatButton label="Volver a chats" onPress={() => router.replace({
          pathname: '/chats/[projectId]', params: { projectId },
        })} />
      </View>
    );
  }

  return (
    <KeyboardAvoidingView style={{ flex: 1 }} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <LinearGradient colors={BackgroundGradients[isDark ? 'dark' : 'light']}
        locations={[0, 0.24, 0.6, 1]} style={{ flex: 1 }}>
        <View style={styles.header}>
          <ChatBackTitle title={title ?? 'Chat'} onBack={() => router.replace({ pathname: '/chats/[projectId]', params: { projectId } })} />
          <View style={styles.subtitleRow}>
            <ChatAvatar name={title ?? '?'} group={room.type === 'group'} size={37} />
            <View style={{ flex: 1, gap: 2 }}>
              <Text style={{ color: theme.textSecondary, fontSize: 12 }}>
                {room.type === 'group' ? `${room.members.length} integrantes` : 'Chat privado'} · {project?.name}
              </Text>
            </View>
            {room.type === 'group' && isLeader && (
              <Pressable accessibilityRole="button" accessibilityLabel="Editar grupo"
                onPress={() => router.push({ pathname: '/chats/[projectId]/grupo',
                  params: { projectId, roomId } })} style={styles.editButton}>
                <SymbolView name={{ ios: 'pencil', android: 'edit', web: 'edit' }}
                  tintColor={theme.primary} size={22} />
              </Pressable>
            )}
          </View>
        </View>

        <ScrollView ref={listRef} style={{ flex: 1 }} contentContainerStyle={styles.messages}
          showsVerticalScrollIndicator={false}
          onContentSizeChange={() => listRef.current?.scrollToEnd({ animated: true })}>
          {roomMessages.length === 0 && (
            <Text style={{ color: theme.textSecondary, textAlign: 'center', marginTop: 50 }}>
              Todavía no hay mensajes. ¡Inicia la conversación!
            </Text>
          )}
          {roomMessages.map(message => {
            const mine = message.senderId === currentUser.id;
            const sender = members.find(member => member.id === message.senderId)?.name ?? 'Integrante';
            const time = new Date(message.sentAt).toLocaleTimeString('es-CO', {
              hour: '2-digit', minute: '2-digit',
            });
            return (
              <View key={message.id} style={[styles.messageRow, { justifyContent: mine ? 'flex-end' : 'flex-start' }]}>
                <View style={[styles.bubble, {
                  backgroundColor: mine ? theme.primary : theme.card,
                  borderColor: mine ? theme.primary : theme.border,
                }]}>
                  {room.type === 'group' && !mine && (
                    <Text style={{ color: theme.primary, fontSize: 11, fontWeight: '700' }}>{sender}</Text>
                  )}
                  <Text style={{ color: mine ? theme.onPrimary : theme.text, fontSize: 14, lineHeight: 21 }}>
                    {message.text}
                  </Text>
                  <Text style={{ color: mine ? theme.onPrimary : theme.textSecondary,
                    opacity: 0.78, alignSelf: 'flex-end', fontSize: 10 }}>{time}</Text>
                </View>
              </View>
            );
          })}
        </ScrollView>

        {!!error && <Text accessibilityRole="alert" style={{ color: theme.danger,
          paddingHorizontal: 20 }}>{error}</Text>}
        <View style={[styles.composer, { backgroundColor: theme.card, borderTopColor: theme.border }]}>
          <TextInput value={draft} onChangeText={setDraft} maxLength={1000}
            multiline placeholder="Escribe un mensaje..." placeholderTextColor={theme.textSecondary}
            accessibilityLabel="Mensaje" style={[styles.input, {
              backgroundColor: theme.inputBackground, borderColor: theme.border, color: theme.text,
            }]} />
          <Pressable accessibilityRole="button" accessibilityLabel="Enviar mensaje"
            disabled={!draft.trim()} onPress={submit} style={[styles.sendButton, {
              backgroundColor: draft.trim() ? theme.primary : theme.backgroundSelected,
            }]}>
            <SymbolView name={{ ios: 'arrow.up', android: 'arrow_upward', web: 'arrow_upward' }}
              size={22} tintColor={draft.trim() ? theme.onPrimary : theme.icon} />
          </Pressable>
        </View>
      </LinearGradient>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  header: { paddingHorizontal: 22, paddingTop: 10, paddingBottom: 14, gap: 8 },
  subtitleRow: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  editButton: { padding: 9 },
  messages: { paddingHorizontal: 18, paddingVertical: 20, gap: 13, flexGrow: 1 },
  messageRow: { flexDirection: 'row' },
  bubble: { borderWidth: 1, padding: 12, borderRadius: 20, gap: 6, maxWidth: '84%' },
  composer: { flexDirection: 'row', alignItems: 'flex-end', paddingHorizontal: 14,
    paddingVertical: 10, gap: 10, borderTopWidth: 1 },
  input: { flex: 1, borderWidth: 1, borderRadius: 20, paddingHorizontal: 14,
    paddingVertical: 11, maxHeight: 110, fontSize: 14 },
  sendButton: { width: 44, height: 44, borderRadius: 22, alignItems: 'center', justifyContent: 'center' },
});
