
import { useAppThemeContext } from '@/context/theme-context';

// Devuelve automáticamente los colores del tema activo.
export function useTheme() {
  return useAppThemeContext().colors;
}

// Permite consultar y cambiar la preferencia del tema.
export function useThemeSettings() {
  const {
    mode,
    activeTheme,
    isDark,
    setThemeMode,
  } = useAppThemeContext();

  return {
    mode,
    activeTheme,
    isDark,
    setThemeMode,
  };
}
