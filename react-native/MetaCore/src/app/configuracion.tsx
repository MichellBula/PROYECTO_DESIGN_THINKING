
import type { ComponentProps } from 'react';

import { router } from 'expo-router';
import { LinearGradient } from 'expo-linear-gradient';
import { SymbolView } from 'expo-symbols';

import {
  Pressable,
  StyleSheet,
  Text,
  View,
} from 'react-native';

import { AppScrollView } from '@/components/ui/app-scroll-view';
import { BackgroundGradients } from '@/constants/theme';

import {
  useTheme,
  useThemeSettings,
} from '@/hooks/use-theme';

import type { ThemeMode } from '@/context/theme-context';

// Modelo de las opciones de apariencia.
type ThemeOption = {
  mode: ThemeMode;
  title: string;
  description: string;
  icon: ComponentProps<typeof SymbolView>['name'];
};

// Opciones disponibles para el usuario.
const THEME_OPTIONS: ThemeOption[] = [
  {
    mode: 'light',
    title: 'Modo claro',
    description: 'Utilizar la apariencia clara de MetaCore.',
    icon: {
      ios: 'sun.max.fill',
      android: 'light_mode',
      web: 'light_mode',
    },
  },
  {
    mode: 'dark',
    title: 'Modo oscuro',
    description: 'Utilizar la apariencia oscura de MetaCore.',
    icon: {
      ios: 'moon.stars.fill',
      android: 'dark_mode',
      web: 'dark_mode',
    },
  },
  {
    mode: 'system',
    title: 'Automático',
    description: 'Seguir la configuración de tu dispositivo.',
    icon: {
      ios: 'iphone',
      android: 'settings_brightness',
      web: 'settings_brightness',
    },
  },
];

export default function ConfiguracionScreen() {
  const theme = useTheme();

  const {
    mode,
    activeTheme,
    isDark,
    setThemeMode,
  } = useThemeSettings();

  // Regresa a la pantalla desde la que se abrió Configuración.
  function goBack() {
    if (router.canGoBack()) {
      router.back();
    } else {
      router.replace('/');
    }
  }

  const activeThemeLabel =
    activeTheme === 'dark' ? 'Oscuro' : 'Claro';

  return (
    <LinearGradient
      colors={
        BackgroundGradients[isDark ? 'dark' : 'light']
      }
      locations={[0, 0.24, 0.6, 1]}
      style={styles.container}
    >
      <AppScrollView
        style={styles.scrollView}
        contentContainerStyle={styles.scrollContent}
      >
        <View style={styles.content}>
          {/* Título y navegación de regreso */}
          <View style={styles.headerRow}>
            <Pressable
              accessibilityRole="button"
              accessibilityLabel="Volver"
              onPress={goBack}
              style={styles.backButton}
            >
              <SymbolView
                name={{
                  ios: 'chevron.left',
                  android: 'chevron_left',
                  web: 'chevron_left',
                }}
                size={24}
                tintColor={theme.primary}
              />
            </Pressable>

            <Text
              style={[
                styles.screenTitle,
                { color: theme.text },
              ]}
            >
              Configuración
            </Text>
          </View>

          <Text
            style={[
              styles.intro,
              { color: theme.textSecondary },
            ]}
          >
            Personaliza la apariencia de MetaCore según
            tus preferencias.
          </Text>

          {/* Encabezado del apartado de apariencia */}
          <View style={styles.sectionHeader}>
            <View
              style={[
                styles.sectionIcon,
                {
                  backgroundColor:
                    theme.badgeBackground,
                },
              ]}
            >
              <SymbolView
                name={{
                  ios: 'paintbrush.fill',
                  android: 'palette',
                  web: 'palette',
                }}
                size={22}
                tintColor={theme.primary}
              />
            </View>

            <View style={styles.sectionText}>
              <Text
                style={[
                  styles.sectionTitle,
                  { color: theme.text },
                ]}
              >
                Apariencia
              </Text>

              <Text
                style={[
                  styles.sectionSubtitle,
                  { color: theme.textSecondary },
                ]}
              >
                Elige cómo quieres visualizar la aplicación.
              </Text>
            </View>
          </View>

          {/* Tarjeta con las tres opciones de tema */}
          <View
            style={[
              styles.optionsCard,
              {
                backgroundColor: theme.card,
                borderColor: theme.border,
              },
            ]}
          >
            {THEME_OPTIONS.map((option) => {
              const isSelected = mode === option.mode;

              return (
                <Pressable
                  key={option.mode}
                  accessibilityRole="radio"
                  accessibilityLabel={option.title}
                  accessibilityState={{
                    checked: isSelected,
                  }}
                  onPress={() =>
                    setThemeMode(option.mode)
                  }
                  style={({ pressed }) => [
                    styles.option,
                    {
                      backgroundColor: isSelected
                        ? theme.backgroundSelected
                        : theme.cardTint,
                      borderColor: isSelected
                        ? theme.primary
                        : theme.border,
                      opacity: pressed ? 0.85 : 1,
                    },
                  ]}
                >
                  <View
                    style={[
                      styles.optionIcon,
                      {
                        backgroundColor:
                          theme.badgeBackground,
                      },
                    ]}
                  >
                    <SymbolView
                      name={option.icon}
                      size={23}
                      tintColor={theme.primary}
                    />
                  </View>

                  <View style={styles.optionText}>
                    <Text
                      style={[
                        styles.optionTitle,
                        { color: theme.text },
                      ]}
                    >
                      {option.title}
                    </Text>

                    <Text
                      style={[
                        styles.optionDescription,
                        {
                          color:
                            theme.textSecondary,
                        },
                      ]}
                    >
                      {option.description}
                    </Text>
                  </View>

                  {/* Indicador de selección */}
                  <SymbolView
                    name={{
                      ios: isSelected
                        ? 'checkmark.circle.fill'
                        : 'circle',
                      android: isSelected
                        ? 'check_circle'
                        : 'radio_button_unchecked',
                      web: isSelected
                        ? 'check_circle'
                        : 'radio_button_unchecked',
                    }}
                    size={23}
                    tintColor={
                      isSelected
                        ? theme.primary
                        : theme.icon
                    }
                  />
                </Pressable>
              );
            })}
          </View>

          {/* Información del tema que se está utilizando */}
          <View
            style={[
              styles.statusCard,
              {
                backgroundColor:
                  theme.backgroundSelected,
                borderColor: theme.border,
              },
            ]}
          >
            <SymbolView
              name={{
                ios: 'checkmark.seal.fill',
                android: 'verified',
                web: 'verified',
              }}
              size={24}
              tintColor={theme.primary}
            />

            <View style={styles.statusText}>
              <Text
                style={[
                  styles.statusTitle,
                  { color: theme.text },
                ]}
              >
                Tema activo: {activeThemeLabel}
              </Text>

              <Text
                style={[
                  styles.statusDescription,
                  { color: theme.textSecondary },
                ]}
              >
                Tu preferencia se guarda
                automáticamente en este dispositivo.
              </Text>
            </View>
          </View>
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
    paddingBottom: 32,
  },

  content: {
    width: '100%',
    maxWidth: 640,
    paddingHorizontal: 24,
    paddingTop: 20,
    gap: 22,
  },

  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },

  backButton: {
    width: 28,
    height: 36,
    justifyContent: 'center',
    alignItems: 'center',
  },

  screenTitle: {
    fontSize: 24,
    lineHeight: 34,
    fontWeight: '700',
  },

  intro: {
    fontSize: 14,
    lineHeight: 21,
  },

  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },

  sectionIcon: {
    width: 48,
    height: 48,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },

  sectionText: {
    flex: 1,
    gap: 3,
  },

  sectionTitle: {
    fontSize: 17,
    fontWeight: '700',
  },

  sectionSubtitle: {
    fontSize: 12,
    lineHeight: 18,
  },

  optionsCard: {
    borderWidth: 1,
    borderRadius: 24,
    padding: 16,
    gap: 12,

    shadowColor: '#314D95',
    shadowOffset: {
      width: 0,
      height: 5,
    },
    shadowOpacity: 0.06,
    shadowRadius: 9,
    elevation: 2,
  },

  option: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    borderWidth: 1.5,
    borderRadius: 16,
    padding: 14,
    minHeight: 82,
  },

  optionIcon: {
    width: 44,
    height: 44,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
  },

  optionText: {
    flex: 1,
    gap: 5,
  },

  optionTitle: {
    fontSize: 14,
    fontWeight: '600',
  },

  optionDescription: {
    fontSize: 11,
    lineHeight: 17,
  },

  statusCard: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    borderWidth: 1,
    borderRadius: 18,
    padding: 16,
  },

  statusText: {
    flex: 1,
    gap: 5,
  },

  statusTitle: {
    fontSize: 14,
    fontWeight: '600',
  },

  statusDescription: {
    fontSize: 12,
    lineHeight: 18,
  },
});
