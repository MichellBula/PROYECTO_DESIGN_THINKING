
import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type PropsWithChildren,
} from 'react';

import AsyncStorage from '@react-native-async-storage/async-storage';

import {
  Colors,
  type AppThemeColors,
  type ThemeName,
} from '@/constants/theme';

import { useColorScheme } from '@/hooks/use-color-scheme';

// Preferencia de apariencia que puede elegir el usuario.
export type ThemeMode = 'light' | 'dark' | 'system';

type ThemeContextState = {
  colors: AppThemeColors;
  mode: ThemeMode;
  activeTheme: ThemeName;
  isDark: boolean;
  setThemeMode: (mode: ThemeMode) => void;
};

// Clave utilizada para guardar la elección en el dispositivo.
const THEME_STORAGE_KEY = '@metacore/theme-mode';

const ThemeContext = createContext<
  ThemeContextState | undefined
>(undefined);

// Validamos los valores leídos del almacenamiento.
function isValidThemeMode(
  value: string | null,
): value is ThemeMode {
  return (
    value === 'light' ||
    value === 'dark' ||
    value === 'system'
  );
}

export function MetaCoreThemeProvider({
  children,
}: PropsWithChildren) {
  // Tema configurado en el dispositivo.
  const systemScheme = useColorScheme();

  // Por defecto seguimos la apariencia del sistema.
  const [mode, setMode] = useState<ThemeMode>('system');

  // Controla cuándo se ha recuperado la preferencia.
  const [isReady, setIsReady] = useState(false);

  // Recuperamos el tema guardado al iniciar MetaCore.
  useEffect(() => {
    let isMounted = true;

    async function loadThemePreference() {
      try {
        const storedMode = await AsyncStorage.getItem(
          THEME_STORAGE_KEY,
        );

        if (
          isMounted &&
          isValidThemeMode(storedMode)
        ) {
          setMode(storedMode);
        }
      } catch (error) {
        console.warn(
          'No se pudo cargar el tema guardado:',
          error,
        );
      } finally {
        if (isMounted) {
          setIsReady(true);
        }
      }
    }

    void loadThemePreference();

    return () => {
      isMounted = false;
    };
  }, []);

  // Guarda y aplica una nueva preferencia.
  const setThemeMode = useCallback(
    (newMode: ThemeMode) => {
      setMode(newMode);

      void AsyncStorage.setItem(
        THEME_STORAGE_KEY,
        newMode,
      ).catch((error) => {
        console.warn(
          'No se pudo guardar la preferencia del tema:',
          error,
        );
      });
    },
    [],
  );

  // Determinamos qué paleta se debe utilizar.
  const activeTheme: ThemeName =
    mode === 'system'
      ? systemScheme === 'dark'
        ? 'dark'
        : 'light'
      : mode;

  const colors = Colors[activeTheme];
  const isDark = activeTheme === 'dark';

  // Compartimos los valores con toda la aplicación.
  const value = useMemo<ThemeContextState>(
    () => ({
      colors,
      mode,
      activeTheme,
      isDark,
      setThemeMode,
    }),
    [
      colors,
      mode,
      activeTheme,
      isDark,
      setThemeMode,
    ],
  );

  return (
    <ThemeContext.Provider value={value}>
      {isReady ? children : null}
    </ThemeContext.Provider>
  );
}

// Hook interno para acceder al estado compartido.
export function useAppThemeContext() {
  const context = useContext(ThemeContext);

  if (!context) {
    throw new Error(
      'MetaCoreThemeProvider debe envolver la aplicación.',
    );
  }

  return context;
}
