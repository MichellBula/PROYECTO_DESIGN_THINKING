
import { router } from 'expo-router';
import { SymbolView } from 'expo-symbols';
import {
  Image,
  Pressable,
  StyleSheet,
  Text,
  View,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

import { useTheme } from '@/hooks/use-theme';

export function AppHeader() {
  const theme = useTheme();

  return (
    <SafeAreaView
      edges={['top']}
      style={{ backgroundColor: theme.headerBackground }}
    >
      <View style={styles.container}>
        {/* Identidad de MetaCore */}
        <View style={styles.brandContainer}>
          <Image
            source={require('@/assets/images/metacore-logo.png')}
            style={styles.logo}
            resizeMode="contain"
            accessibilityLabel="Logo de MetaCore"
          />

          <Text
            style={[styles.brandName, { color: theme.brand }]}
            numberOfLines={1}
          >
            MetaCore
          </Text>
        </View>

        <View style={styles.actions}>
          {/* La campanita abre las solicitudes */}
          <Pressable
            accessibilityRole="button"
            accessibilityLabel="Abrir solicitudes"
            onPress={() => router.push('/solicitudes')}
            style={styles.notificationButton}
          >
            <SymbolView
              name={{
                ios: 'bell',
                android: 'notifications',
                web: 'notifications',
              }}
              size={24}
              tintColor={theme.text}
            />
          </Pressable>

          {/* El selector de tema se agregará después */}
          <Pressable
            accessibilityRole="button"
            accessibilityLabel="Abrir configuración"
            onPress={() => router.push('/configuracion')}
            style={[
              styles.settingsButton,
              { backgroundColor: theme.primary },
            ]}
          >
            <SymbolView
              name={{
                ios: 'gearshape',
                android: 'settings',
                web: 'settings',
              }}
              size={23}
              tintColor={theme.onPrimary}
            />
          </Pressable>
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    height: 76,
    paddingHorizontal: 20,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  brandContainer: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  logo: {
    width: 44,
    height: 40,
  },
  brandName: {
    fontSize: 20,
    fontWeight: '700',
    flexShrink: 1,
  },
  actions: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 14,
  },
  notificationButton: {
    width: 36,
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
  },
  settingsButton: {
    width: 44,
    height: 44,
    borderRadius: 22,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
