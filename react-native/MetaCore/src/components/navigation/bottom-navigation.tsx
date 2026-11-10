
import type { ComponentProps } from 'react';

import { router, usePathname } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';

import {
  Pressable,
  StyleSheet,
  Text,
  View,
} from 'react-native';

import { SafeAreaView } from 'react-native-safe-area-context';

import { useTheme } from '@/hooks/use-theme';

// Rutas principales de la aplicación.
type MainTabRoute =
  | '/'
  | '/buscar'
  | '/mis-proyectos'
  | '/perfil';

type NavigationItemProps = {
  href: MainTabRoute;
  label: string;
  icon: ComponentProps<typeof SymbolView>['name'];
  compact?: boolean;
};

// Botón reutilizable de la barra inferior.
function NavigationItem({
  href,
  label,
  icon,
  compact = false,
}: NavigationItemProps) {
  const theme = useTheme();
  const pathname = usePathname();

  // Comprueba si la pestaña está seleccionada.
  const isActive =
    pathname === href ||
    (href !== '/' && pathname.startsWith(`${href}/`));

  const color = isActive
    ? theme.primaryActive
    : theme.text;

  return (
    <Pressable
      accessibilityRole="tab"
      accessibilityLabel={label}
      accessibilityState={{ selected: isActive }}
      onPress={() => router.navigate(href)}
      style={styles.tabItem}
    >
      <SymbolView
        name={icon}
        size={28}
        tintColor={color}
      />

      <Text
        numberOfLines={1}
        adjustsFontSizeToFit
        minimumFontScale={0.8}
        style={[
          styles.tabLabel,
          compact && styles.compactLabel,
          {
            color,
            fontWeight: isActive ? '600' : '400',
          },
        ]}
      >
        {label}
      </Text>
    </Pressable>
  );
}

// Botón central para crear proyectos.
function CreateProjectButton() {
  const theme = useTheme();
  const pathname = usePathname();

  const isActive = pathname === '/crear';

  return (
    <Pressable
      accessibilityRole="tab"
      accessibilityLabel="Crear proyecto"
      accessibilityState={{ selected: isActive }}
      onPress={() => router.navigate('/crear')}
      style={styles.createContainer}
    >
      <LinearGradient
        colors={[theme.accent, theme.primaryActive]}
        start={{ x: 0, y: 5 }}
        end={{ x: 0, y: 1 }}
        style={styles.createButton}
      >
        <Text style={styles.plusIcon}>+</Text>
      </LinearGradient>
    </Pressable>
  );
}

// Barra inferior global de MetaCore.
export function BottomNavigation() {
  const theme = useTheme();

  return (
    <SafeAreaView
      edges={['bottom']}
      style={{ backgroundColor: theme.background }}
    >
      <View
        style={[
          styles.navigationBar,
          {
            backgroundColor: theme.tabBackground,
            borderColor: theme.border,
          },
        ]}
      >
        <NavigationItem
          href="/"
          label="Inicio"
          icon={{
            ios: 'house',
            android: 'home',
            web: 'home',
          }}
        />

        <NavigationItem
          href="/buscar"
          label="Buscar"
          icon={{
            ios: 'magnifyingglass',
            android: 'search',
            web: 'search',
          }}
        />

        <CreateProjectButton />

        <NavigationItem
          href="/mis-proyectos"
          label="Mis proyectos"
          compact
          icon={{
            ios: 'person.3.fill',
            android: 'groups',
            web: 'groups',
          }}
        />

        <NavigationItem
          href="/perfil"
          label="Mi perfil"
          icon={{
            ios: 'person.crop.circle',
            android: 'account_circle',
            web: 'account_circle',
          }}
        />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  navigationBar: {
    height: 78,
    marginHorizontal: 16,
    marginTop: 8,
    marginBottom: 12,
    paddingHorizontal: 6,
    borderWidth: 1.5,
    borderRadius: 39,
    flexDirection: 'row',
    alignItems: 'center',

    shadowColor: '#314D95',
    shadowOffset: { width: 0, height: 7 },
    shadowOpacity: 0.12,
    shadowRadius: 12,
    elevation: 6,
  },

  tabItem: {
    flex: 1,
    minWidth: 0,
    height: 72,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
  },

  tabLabel: {
    fontSize: 12,
    textAlign: 'center',
  },

  compactLabel: {
    fontSize: 10,
  },

  createContainer: {
    flex: 1,
    height: 40,
    alignItems: 'center',
    justifyContent: 'center',
  },

  createButton: {
    width: 60,
    height: 60,
    borderRadius: 33,
    alignItems: 'center',
    justifyContent: 'flex-start',
    shadowColor: '#314D95',
    shadowOffset: { width: 0, height: 5 },
    shadowOpacity: 0.18,
    shadowRadius: 9,
    elevation: 5,
  },

  plusIcon: {
    color: '#FFFFFF',
    fontSize: 60,
    lineHeight: 56,
    fontWeight: '500',
    textAlign: 'right',
    
  },
});
