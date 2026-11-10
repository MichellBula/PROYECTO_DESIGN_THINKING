
import { useState } from 'react';
import { LinearGradient } from 'expo-linear-gradient';

import {
  Pressable,
  StyleSheet,
  Text,
  View,
} from 'react-native';

import { AppScrollView } from '@/components/ui/app-scroll-view';
import { BackgroundGradients } from '@/constants/theme';

import { EventCard } from '@/features/home/components/event-card';
import { PostCard } from '@/features/home/components/post-card';

import {
  demoEvents,
  demoPosts,
  type HomePost,
} from '@/features/home/data/home-demo';

import {
  useTheme,
  useThemeSettings,
} from '@/hooks/use-theme';

export default function HomeScreen() {
  const theme = useTheme();
  const { isDark } = useThemeSettings();

  const [showAllEvents, setShowAllEvents] = useState(false);
  const [posts, setPosts] = useState<HomePost[]>(demoPosts);

  // Interacciones locales hasta conectar Roble.
  function toggleLike(id: string) {
    setPosts((current) =>
      current.map((post) => {
        if (post.id !== id) return post;

        const likedByMe = !post.likedByMe;

        return {
          ...post,
          likedByMe,
          likes: Math.max(
            0,
            post.likes + (likedByMe ? 1 : -1),
          ),
        };
      }),
    );
  }

  function addComment(postId: string, text: string) {
    const message = text.trim();

    if (!message) return;

    setPosts((current) =>
      current.map((post) =>
        post.id === postId
          ? {
              ...post,
              comments: [
                ...post.comments,
                {
                  id: `${postId}-${Date.now()}`,
                  author: 'Tú',
                  text: message,
                },
              ],
            }
          : post,
      ),
    );
  }

  const visibleEvents = showAllEvents
    ? demoEvents
    : demoEvents.slice(0, 3);

  return (
    <LinearGradient
      colors={
        BackgroundGradients[isDark ? 'dark' : 'light']
      }
      locations={[0, 0.24, 0.6, 1]}
      style={styles.container}
    >
      {/* Desplazamiento sin barra visible */}
      <AppScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
      >
        <View style={styles.content}>
          {/* Bienvenida */}
          <View style={styles.welcome}>
            <Text
              style={[
                styles.greeting,
                { color: theme.text },
              ]}
            >
              Hola, Alejandra!
            </Text>

            <Text
              style={[
                styles.subtitle,
                { color: theme.textSecondary },
              ]}
            >
              ¿Qué deseas hacer hoy?
            </Text>
          </View>

          {/* Próximos eventos */}
          <View style={styles.sectionHeading}>
            <Text
              style={[
                styles.sectionTitle,
                { color: theme.text },
              ]}
            >
              Eventos próximos:
            </Text>

            <Pressable
              accessibilityRole="button"
              onPress={() =>
                setShowAllEvents((value) => !value)
              }
            >
              <Text
                style={[
                  styles.seeAll,
                  { color: theme.primary },
                ]}
              >
                {showAllEvents
                  ? 'Ver menos'
                  : 'Ver todos'}
              </Text>
            </Pressable>
          </View>

          <View
            style={[
              styles.eventsCard,
              {
                backgroundColor: theme.card,
                borderColor: theme.border,
              },
            ]}
          >
            {visibleEvents.map((event) => (
              <EventCard
                key={event.id}
                event={event}
              />
            ))}
          </View>

          {/* Publicaciones */}
          <Text
            style={[
              styles.postsHeading,
              { color: theme.text },
            ]}
          >
            Publicaciones:
          </Text>

          {posts.map((post) => (
            <PostCard
              key={post.id}
              post={post}
              onToggleLike={toggleLike}
              onAddComment={addComment}
            />
          ))}
        </View>
      </AppScrollView>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },

  scrollView: {
    flex: 1,
  },

  scrollContent: {
    alignItems: 'center',
    paddingBottom: 24,
  },

  content: {
    width: '100%',
    maxWidth: 640,
    paddingHorizontal: 24,
    paddingTop: 16,
    gap: 20,
  },

  welcome: {
    gap: 5,
  },

  greeting: {
    fontSize: 32,
    lineHeight: 45,
    fontWeight: '700',
  },

  subtitle: {
    fontSize: 14,
    lineHeight: 20,
  },

  sectionHeading: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },

  sectionTitle: {
    fontSize: 17,
    lineHeight: 24,
    fontWeight: '600',
  },

  seeAll: {
    fontSize: 12,
    fontWeight: '600',
  },

  eventsCard: {
    gap: 14,
    padding: 16,
    borderWidth: 1,
    borderRadius: 24,
    shadowColor: '#314D95',
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.06,
    shadowRadius: 9,
    elevation: 2,
  },

  postsHeading: {
    fontSize: 18,
    lineHeight: 25,
    fontWeight: '700',
  },
});
