import '@/global.css';
import { useMemo } from 'react';
import {
  DarkTheme, DefaultTheme, Stack,
  ThemeProvider as NavigationThemeProvider, usePathname,
} from 'expo-router';
import * as SplashScreen from 'expo-splash-screen';
import { StatusBar } from 'expo-status-bar';
import { View } from 'react-native';
import { AnimatedSplashOverlay } from '@/components/animated-icon';
import { AppHeader } from '@/components/navigation/app-header';
import { BottomNavigation } from '@/components/navigation/bottom-navigation';
import { MetaCoreThemeProvider, useAppThemeContext } from '@/context/theme-context';
import { DemoProjectsProvider } from '@/features/projects/context/projects-context';
import { CollaborationProvider } from '@/features/collaboration/context/collaboration-context';

void SplashScreen.preventAutoHideAsync();

function AppContent() {
  const { colors, isDark } = useAppThemeContext();
  const pathname = usePathname();

  // El detalle de Mis proyectos mantiene la barra; los chats no.
  // Buscar proyectos y postulación conservan la navegación del Paso 4.
  const hideBottomNavigation =
    pathname.startsWith('/proyecto/') ||
    pathname.startsWith('/postular/') ||
    pathname.startsWith('/chats/');

  const navigationTheme = useMemo(() => {
    const base = isDark ? DarkTheme : DefaultTheme;
    return {
      ...base,
      colors: {
        ...base.colors,
        primary: colors.primary,
        background: colors.background,
        card: colors.card,
        text: colors.text,
        border: colors.border,
        notification: colors.accent,
      },
    };
  }, [colors, isDark]);

  return (
    <NavigationThemeProvider value={navigationTheme}>
      <StatusBar style={isDark ? 'light' : 'dark'} />
      <View style={{ flex: 1, backgroundColor: colors.background }}>
        <AppHeader />
        <Stack screenOptions={{ headerShown: false }} />
        {!hideBottomNavigation && <BottomNavigation />}
      </View>
      <AnimatedSplashOverlay />
    </NavigationThemeProvider>
  );
}

export default function RootLayout() {
  return (
    <MetaCoreThemeProvider>
      <DemoProjectsProvider>
        <CollaborationProvider>
          <AppContent />
        </CollaborationProvider>
      </DemoProjectsProvider>
    </MetaCoreThemeProvider>
  );
}
