import { createContext, useContext, useEffect, useMemo, useRef, useState, type PropsWithChildren } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useDemoProjects } from '@/features/projects/context/projects-context';
import { getProjectMembers, type ProjectMember } from '../data/demo-members';
import { validateGroupMembers } from '../data/chat-rules';
import { removeBoard } from '@/features/board/data/board-storage';

export type ChatRoom = {
  id: string;
  projectId: string;
  type: 'private' | 'group';
  name: string;
  members: string[];
  createdBy: string;
  createdAt: string;
};

export type ChatMessage = {
  id: string;
  roomId: string;
  senderId: string;
  text: string;
  sentAt: string;
};

type Result = { ok: true; roomId: string } | { ok: false; message: string };
type DeleteResult = { ok: true } | { ok: false; message: string };

type CollaborationValue = {
  rooms: ChatRoom[];
  messages: ChatMessage[];
  membersFor: (projectId: string) => ProjectMember[];
  canAccessProject: (projectId: string) => boolean;
  visibleRooms: (projectId: string) => ChatRoom[];
  startPrivateChat: (projectId: string, memberId: string) => Result;
  createGroup: (projectId: string, name: string, selectedIds: string[]) => Result;
  updateGroup: (roomId: string, name: string, selectedIds: string[]) => Result;
  deleteGroup: (roomId: string) => DeleteResult;
  sendMessage: (roomId: string, text: string) => DeleteResult;
};

const STORAGE_KEY = '@metacore/demo-chats-v1';
const CollaborationContext = createContext<CollaborationValue | null>(null);

const initialRooms: ChatRoom[] = [
  {
    id: 'demo-private-maria', projectId: 'mydailypet', type: 'private',
    name: 'María López', members: ['u2', 'demo-user'], createdBy: 'demo-user',
    createdAt: '2026-11-09T16:00:00.000Z',
  },
  {
    id: 'demo-group-pet', projectId: 'mydailypet', type: 'group',
    name: 'Diseño y bienestar', members: ['u2', 'demo-user', 'u-ana'],
    createdBy: 'u2', createdAt: '2026-11-09T16:30:00.000Z',
  },
];

const initialMessages: ChatMessage[] = [
  { id: 'demo-m1', roomId: 'demo-private-maria', senderId: 'u2',
    text: '¡Hola! ¿Cómo va el diseño de MyDailyPet?', sentAt: '2026-11-09T16:01:00.000Z' },
  { id: 'demo-m2', roomId: 'demo-private-maria', senderId: 'demo-user',
    text: '¡Muy bien! Preparé la primera propuesta.', sentAt: '2026-11-09T16:02:00.000Z' },
  { id: 'demo-m3', roomId: 'demo-group-pet', senderId: 'u2',
    text: 'Equipo, revisemos las ideas de la interfaz.', sentAt: '2026-11-09T17:00:00.000Z' },
  { id: 'demo-m4', roomId: 'demo-group-pet', senderId: 'u-ana',
    text: 'Yo puedo preparar el flujo de navegación.', sentAt: '2026-11-09T17:03:00.000Z' },
];

function validRoom(value: unknown): value is ChatRoom {
  if (typeof value !== 'object' || !value) return false;
  const r = value as Partial<ChatRoom>;
  return typeof r.id === 'string' && typeof r.projectId === 'string'
    && (r.type === 'group' || r.type === 'private')
    && typeof r.name === 'string' && Array.isArray(r.members)
    && r.members.every(id => typeof id === 'string')
    && typeof r.createdBy === 'string' && typeof r.createdAt === 'string';
}

function validMessage(value: unknown): value is ChatMessage {
  if (typeof value !== 'object' || !value) return false;
  const m = value as Partial<ChatMessage>;
  return typeof m.id === 'string' && typeof m.roomId === 'string'
    && typeof m.senderId === 'string' && typeof m.text === 'string'
    && typeof m.sentAt === 'string';
}

function newId(prefix: string): string {
  return `${prefix}-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
}

export function CollaborationProvider({ children }: PropsWithChildren) {
  const { projects, applications, currentUser } = useDemoProjects();
  const [rooms, setRooms] = useState<ChatRoom[]>(initialRooms);
  const [messages, setMessages] = useState<ChatMessage[]>(initialMessages);
  const roomsRef = useRef(rooms);
  const [loaded, setLoaded] = useState(false);

  function setRoomsSafe(next: ChatRoom[]) {
    roomsRef.current = next;
    setRooms(next);
  }

  // Se guardan todas las conversaciones en el dispositivo actual.
  useEffect(() => {
    let mounted = true;
    void (async () => {
      try {
        const raw = await AsyncStorage.getItem(STORAGE_KEY);
        if (raw && mounted) {
          const data: unknown = JSON.parse(raw);
          if (typeof data === 'object' && data) {
            const saved = data as { rooms?: unknown; messages?: unknown };
            if (Array.isArray(saved.rooms) && saved.rooms.every(validRoom)) {
              setRoomsSafe(saved.rooms);
            }
            if (Array.isArray(saved.messages) && saved.messages.every(validMessage)) {
              setMessages(saved.messages);
            }
          }
        }
      } catch (error) {
        console.warn('No se pudieron recuperar los chats:', error);
      } finally {
        if (mounted) setLoaded(true);
      }
    })();
    return () => { mounted = false; };
  }, []);

  useEffect(() => {
    if (!loaded) return;
    void AsyncStorage.setItem(STORAGE_KEY, JSON.stringify({ rooms, messages }))
      .catch(error => console.warn('No se pudieron guardar los chats:', error));
  }, [rooms, messages, loaded]);

  function membersFor(projectId: string): ProjectMember[] {
    const project = projects.find(item => item.id === projectId);
    if (!project) return [];
    return getProjectMembers(project, applications, currentUser);
  }

  function canAccessProject(projectId: string): boolean {
    return membersFor(projectId).some(member => member.id === currentUser.id);
  }

  function visibleRooms(projectId: string): ChatRoom[] {
    if (!canAccessProject(projectId)) return [];
    return rooms.filter(room => room.projectId === projectId && room.members.includes(currentUser.id));
  }

  function startPrivateChat(projectId: string, memberId: string): Result {
    const members = membersFor(projectId);
    if (!members.some(m => m.id === currentUser.id)) return { ok: false, message: 'No perteneces a este proyecto.' };
    if (memberId === currentUser.id || !members.some(m => m.id === memberId)) {
      return { ok: false, message: 'Selecciona otro integrante del proyecto.' };
    }
    const existing = roomsRef.current.find(room => room.projectId === projectId && room.type === 'private'
      && room.members.length === 2 && room.members.includes(memberId) && room.members.includes(currentUser.id));
    if (existing) return { ok: true, roomId: existing.id };
    const person = members.find(m => m.id === memberId)!;
    const room: ChatRoom = {
      id: newId('private'), projectId, type: 'private', name: person.name,
      members: [currentUser.id, memberId], createdBy: currentUser.id,
      createdAt: new Date().toISOString(),
    };
    setRoomsSafe([...roomsRef.current, room]);
    return { ok: true, roomId: room.id };
  }

  function validateGroup(projectId: string, name: string, selectedIds: string[]):
      { ok: true; members: string[] } | { ok: false; message: string } {
    const project = projects.find(item => item.id === projectId);
    if (!project) return { ok: false, message: 'Proyecto no encontrado.' };
    if (project.leaderId !== currentUser.id) {
      return { ok: false, message: 'Solo el líder del proyecto puede administrar grupos.' };
    }
    if (name.trim().length < 3 || name.trim().length > 60) {
      return { ok: false, message: 'El nombre debe tener entre 3 y 60 caracteres.' };
    }
    const validated = validateGroupMembers(
      project.leaderId, membersFor(projectId).map(member => member.id), selectedIds,
    );
    if (!validated.ok) return validated;
    return { ok: true, members: validated.memberIds };
  }

  function createGroup(projectId: string, name: string, selectedIds: string[]): Result {
    const validated = validateGroup(projectId, name, selectedIds);
    if (!validated.ok) return validated;
    const room: ChatRoom = {
      id: newId('group'), projectId, type: 'group', name: name.trim(),
      members: validated.members, createdBy: currentUser.id,
      createdAt: new Date().toISOString(),
    };
    setRoomsSafe([...roomsRef.current, room]);
    return { ok: true, roomId: room.id };
  }

  function updateGroup(roomId: string, name: string, selectedIds: string[]): Result {
    const room = roomsRef.current.find(item => item.id === roomId);
    if (!room || room.type !== 'group') return { ok: false, message: 'Grupo no encontrado.' };
    const validated = validateGroup(room.projectId, name, selectedIds);
    if (!validated.ok) return validated;
    setRoomsSafe(roomsRef.current.map(item => item.id !== roomId ? item : {
      ...item, name: name.trim(), members: validated.members,
    }));
    return { ok: true, roomId };
  }

  function deleteGroup(roomId: string): DeleteResult {
    const room = roomsRef.current.find(item => item.id === roomId);
    const project = projects.find(item => item.id === room?.projectId);
    if (!room || room.type !== 'group' || project?.leaderId !== currentUser.id) {
      return { ok: false, message: 'Solo el líder puede eliminar este grupo.' };
    }
    setRoomsSafe(roomsRef.current.filter(item => item.id !== roomId));
    setMessages(current => current.filter(message => message.roomId !== roomId));
    // El tablero pertenece al grupo: eliminarlo impide reabrir datos huérfanos.
    void removeBoard(room.projectId, room.id).catch(error =>
      console.warn('No se pudo eliminar el tablero del grupo:', error));
    return { ok: true };
  }

  function sendMessage(roomId: string, text: string): DeleteResult {
    const room = roomsRef.current.find(item => item.id === roomId);
    if (!room || !room.members.includes(currentUser.id)
      || !canAccessProject(room.projectId)) {
      return { ok: false, message: 'No tienes acceso a esta conversación.' };
    }
    const content = text.trim();
    if (!content || content.length > 1000) {
      return { ok: false, message: 'El mensaje debe tener entre 1 y 1000 caracteres.' };
    }
    setMessages(current => [...current, {
      id: newId('message'), roomId, senderId: currentUser.id,
      text: content, sentAt: new Date().toISOString(),
    }]);
    return { ok: true };
  }

  const value = useMemo<CollaborationValue>(() => ({
    rooms, messages, membersFor, canAccessProject, visibleRooms,
    startPrivateChat, createGroup, updateGroup, deleteGroup, sendMessage,
  }), [rooms, messages, projects, applications, currentUser]);

  return (
    <CollaborationContext.Provider value={value}>
      {loaded ? children : null}
    </CollaborationContext.Provider>
  );
}

export function useCollaboration() {
  const context = useContext(CollaborationContext);
  if (!context) throw new Error('CollaborationProvider debe envolver las pantallas de chats.');
  return context;
}
