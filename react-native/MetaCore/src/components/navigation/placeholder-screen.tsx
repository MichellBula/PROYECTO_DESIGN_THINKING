
import { router } from 'expo-router';

import {
  Pressable,
  ScrollView,
  StyleSheet,
  View,
} from 'react-native';

import { ThemedText } from '@/components/themed-text';
import { useTheme } from '@/hooks/use-theme';

type PlaceholderScreenProps = {
  title: string;
  description: string;
  showBack?: boolean;
};

export function PlaceholderScreen({
  title,
  description,
  showBack = false,
}: PlaceholderScreenProps) {
  const theme = useTheme();

  function goBack() {
    if (router.canGoBack()) {
      router.back();
    } else {
      router.replace('/');
    }
  }

  return (
    <ScrollView
      style={{ flex: 1, backgroundColor: theme.background }}
      contentContainerStyle={styles.content}
    >
      <ThemedText type="title">{title}</ThemedText>

      <View
        style={[
          styles.card,
          {
            backgroundColor: theme.card,
            borderColor: theme.border,
          },
        ]}
      >
        <ThemedText themeColor="textSecondary">
          {description}
        </ThemedText>
      </View>

      {showBack && (
        <Pressable
          accessibilityRole="button"
          onPress={goBack}
          style={[
            styles.backButton,
            { backgroundColor: theme.primary },
          ]}
        >
          <ThemedText style={{ color: theme.onPrimary }}>
            Volver
          </ThemedText>
        </Pressable>
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  content: {
    paddingHorizontal: 24,
    paddingTop: 24,
    paddingBottom: 36,
    gap: 20,
  },
  card: {
    borderWidth: 1,
    borderRadius: 24,
    padding: 20,
  },
  backButton: {
    paddingHorizontal: 20,
    paddingVertical: 14,
    borderRadius: 16,
    alignItems: 'center',
    alignSelf: 'flex-start',
  },
});
