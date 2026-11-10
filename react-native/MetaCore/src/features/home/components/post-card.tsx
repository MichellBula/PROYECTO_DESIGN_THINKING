
import { useState } from 'react';
import { SymbolView } from 'expo-symbols';

import {
  Pressable,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native';

import { useTheme } from '@/hooks/use-theme';
import type {
  HomePost,
  PostCategory,
} from '../data/home-demo';

type PostCardProps = {
  post: HomePost;
  onToggleLike: (id: string) => void;
  onAddComment: (id: string, text: string) => void;
};

// Iconos correspondientes a cada categoría.
const POST_ICONS = {
  videojuegos: {
    ios: 'gamecontroller.fill',
    android: 'sports_esports',
    web: 'sports_esports',
  },
  bienestar: {
    ios: 'heart.fill',
    android: 'favorite',
    web: 'favorite',
  },
  educacion: {
    ios: 'books.vertical.fill',
    android: 'menu_book',
    web: 'menu_book',
  },
} as const;

const CATEGORY_NAMES: Record<PostCategory, string> = {
  videojuegos: 'Videojuegos',
  bienestar: 'Bienestar estudiantil',
  educacion: 'Educación',
};

export function PostCard({
  post,
  onToggleLike,
  onAddComment,
}: PostCardProps) {
  const theme = useTheme();

  const [commentsOpen, setCommentsOpen] = useState(false);
  const [menuOpen, setMenuOpen] = useState(false);
  const [saved, setSaved] = useState(false);
  const [commentText, setCommentText] = useState('');

  function sendComment() {
    const text = commentText.trim();

    if (!text) return;

    onAddComment(post.id, text);
    setCommentText('');
  }

  return (
    <View
      style={[
        styles.card,
        {
          backgroundColor: theme.card,
          borderColor: theme.border,
        },
      ]}
    >
      {/* Autor de la publicación */}
      <View style={styles.authorRow}>
        <View
          style={[
            styles.avatar,
            { backgroundColor: theme.badgeBackground },
          ]}
        >
          <Text
            style={[
              styles.avatarLetter,
              { color: theme.primary },
            ]}
          >
            {post.author.charAt(0).toUpperCase()}
          </Text>
        </View>

        <View style={styles.authorInfo}>
          <Text
            style={[styles.author, { color: theme.text }]}
          >
            {post.author}
          </Text>

          <Text
            numberOfLines={1}
            style={[
              styles.authorSubtitle,
              { color: theme.textSecondary },
            ]}
          >
            {post.authorInfo}
          </Text>
        </View>

        <Pressable
          accessibilityRole="button"
          accessibilityLabel="Opciones de publicación"
          onPress={() => setMenuOpen(!menuOpen)}
        >
          <Text
            style={[
              styles.more,
              { color: theme.textSecondary },
            ]}
          >
            ···
          </Text>
        </Pressable>
      </View>

      {menuOpen && (
        <Pressable
          style={[
            styles.menuOption,
            { backgroundColor: theme.backgroundSelected },
          ]}
          onPress={() => {
            setSaved(!saved);
            setMenuOpen(false);
          }}
        >
          <Text style={{ color: theme.text }}>
            {saved
              ? 'Quitar de guardados'
              : 'Guardar publicación'}
          </Text>
        </Pressable>
      )}

      <Text
        style={[styles.title, { color: theme.text }]}
      >
        {post.title}
      </Text>

      <Text
        style={[
          styles.description,
          { color: theme.textSecondary },
        ]}
      >
        {post.description}
      </Text>

      {/* Imagen de ejemplo sustituida por un icono */}
      <View
        style={[
          styles.visualContainer,
          { backgroundColor: theme.badgeBackground },
        ]}
      >
        <View
          style={[
            styles.visualCircle,
            { backgroundColor: theme.card },
          ]}
        >
          <SymbolView
            name={POST_ICONS[post.category]}
            size={65}
            tintColor={theme.primary}
          />
        </View>

        <Text
          style={[
            styles.categoryText,
            { color: theme.primary },
          ]}
        >
          {CATEGORY_NAMES[post.category]}
        </Text>
      </View>

      {/* Reacciones de la publicación */}
      <View style={styles.actions}>
        <Pressable
          accessibilityRole="button"
          accessibilityLabel={
            post.likedByMe
              ? 'Quitar me gusta'
              : 'Dar me gusta'
          }
          style={styles.actionButton}
          onPress={() => onToggleLike(post.id)}
        >
          <SymbolView
            name={{
              ios: post.likedByMe
                ? 'heart.fill'
                : 'heart',
              android: post.likedByMe
                ? 'favorite'
                : 'favorite_border',
              web: post.likedByMe
                ? 'favorite'
                : 'favorite_border',
            }}
            size={20}
            tintColor={
              post.likedByMe
                ? theme.danger
                : theme.textSecondary
            }
          />

          <Text style={{ color: theme.textSecondary }}>
            {post.likes}
          </Text>
        </Pressable>

        <Pressable
          accessibilityRole="button"
          accessibilityLabel="Ver comentarios"
          style={styles.actionButton}
          onPress={() => setCommentsOpen(!commentsOpen)}
        >
          <SymbolView
            name={{
              ios: 'bubble.left',
              android: 'chat_bubble_outline',
              web: 'chat_bubble_outline',
            }}
            size={20}
            tintColor={theme.textSecondary}
          />

          <Text style={{ color: theme.textSecondary }}>
            {post.comments.length}
          </Text>
        </Pressable>

        <Text
          style={[
            styles.time,
            { color: theme.textSecondary },
          ]}
        >
          {post.timeLabel}
        </Text>
      </View>

      {saved && (
        <Text style={{ color: theme.primary, fontSize: 12 }}>
          Publicación guardada
        </Text>
      )}

      {/* Comentarios locales hasta conectar Roble */}
      {commentsOpen && (
        <View
          style={[
            styles.commentsSection,
            { borderTopColor: theme.border },
          ]}
        >
          <Text
            style={[
              styles.commentsTitle,
              { color: theme.text },
            ]}
          >
            Comentarios
          </Text>

          {post.comments.map((comment) => (
            <View
              key={comment.id}
              style={[
                styles.comment,
                { backgroundColor: theme.cardTint },
              ]}
            >
              <Text
                style={[
                  styles.commentAuthor,
                  { color: theme.text },
                ]}
              >
                {comment.author}
              </Text>

              <Text
                style={{ color: theme.textSecondary }}
              >
                {comment.text}
              </Text>
            </View>
          ))}

          <View style={styles.inputRow}>
            <TextInput
              value={commentText}
              onChangeText={setCommentText}
              placeholder="Escribe un comentario..."
              placeholderTextColor={theme.textSecondary}
              onSubmitEditing={sendComment}
              style={[
                styles.input,
                {
                  backgroundColor: theme.inputBackground,
                  color: theme.text,
                  borderColor: theme.border,
                },
              ]}
            />

            <Pressable
              accessibilityRole="button"
              accessibilityLabel="Enviar comentario"
              style={[
                styles.sendButton,
                { backgroundColor: theme.primary },
              ]}
              onPress={sendComment}
            >
              <SymbolView
                name={{
                  ios: 'arrow.up',
                  android: 'arrow_upward',
                  web: 'arrow_upward',
                }}
                size={19}
                tintColor={theme.onPrimary}
              />
            </Pressable>
          </View>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    borderWidth: 1,
    borderRadius: 24,
    padding: 18,
    gap: 12,
    shadowColor: '#314D95',
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.06,
    shadowRadius: 9,
    elevation: 2,
  },
  authorRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  avatar: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarLetter: {
    fontSize: 18,
    fontWeight: '700',
  },
  authorInfo: {
    flex: 1,
    gap: 2,
  },
  author: {
    fontSize: 14,
    fontWeight: '600',
  },
  authorSubtitle: {
    fontSize: 10,
  },
  more: {
    fontSize: 24,
    fontWeight: '700',
  },
  menuOption: {
    padding: 12,
    borderRadius: 12,
  },
  title: {
    fontSize: 18,
    lineHeight: 25,
    fontWeight: '600',
  },
  description: {
    fontSize: 13,
    lineHeight: 19,
  },
  visualContainer: {
    width: '100%',
    height: 154,
    borderRadius: 15,
    justifyContent: 'center',
    alignItems: 'center',
    gap: 10,
  },
  visualCircle: {
    width: 88,
    height: 88,
    borderRadius: 44,
    justifyContent: 'center',
    alignItems: 'center',
  },
  categoryText: {
    fontSize: 12,
    fontWeight: '600',
  },
  actions: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 18,
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
    paddingVertical: 4,
  },
  time: {
    fontSize: 11,
  },
  commentsSection: {
    borderTopWidth: 1,
    paddingTop: 14,
    gap: 10,
  },
  commentsTitle: {
    fontSize: 14,
    fontWeight: '700',
  },
  comment: {
    padding: 10,
    borderRadius: 12,
    gap: 4,
  },
  commentAuthor: {
    fontSize: 12,
    fontWeight: '700',
  },
  inputRow: {
    flexDirection: 'row',
    gap: 8,
  },
  input: {
    flex: 1,
    borderWidth: 1,
    borderRadius: 14,
    paddingHorizontal: 12,
    paddingVertical: 8,
  },
  sendButton: {
    width: 42,
    height: 42,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
