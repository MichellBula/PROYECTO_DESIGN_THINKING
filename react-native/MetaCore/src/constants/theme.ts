
/**
 * Sistema de diseño global de MetaCore.
 * Los colores del tema claro están basados en el prototipo de Figma.
 * El tema oscuro es una adaptación de la misma identidad visual.
 */

import '@/global.css';

import { Platform } from 'react-native';

// Colores base de la identidad visual de MetaCore.
export const Palette = {
  primary: '#2454DE',
  primaryActive: '#0040FA',
  brand: '#76B1FF',
  accent: '#00E8D9',

  text: '#192440',
  textSecondary: '#52617B',

  white: '#FFFFFF',
  background: '#F8FBFF',
  backgroundBlue: '#EAF7FF',
  backgroundLavender: '#F4F3FF',
  backgroundCyan: '#E2F5FC',

  surface: '#F8FAFF',
  blueSoft: '#EDF2FF',
  border: '#DFE7F5',

  success: '#138765',
  danger: '#DE2424',
} as const;

// Los mismos nombres de color existen en ambos temas.
export const Colors = {
  light: {
    text: Palette.text,
    textSecondary: Palette.textSecondary,

    background: Palette.background,
    backgroundElement: Palette.white,
    backgroundSelected: Palette.blueSoft,

    primary: Palette.primary,
    primaryActive: Palette.primaryActive,
    onPrimary: Palette.white,
    brand: Palette.brand,
    accent: Palette.accent,

    card: Palette.white,
    cardTint: Palette.surface,
    headerBackground: Palette.background,
    tabBackground: Palette.white,
    inputBackground: Palette.surface,

    border: Palette.border,
    icon: Palette.textSecondary,

    badgeBackground: Palette.blueSoft,
    badgeText: Palette.primary,

    success: Palette.success,
    danger: Palette.danger,
  },

  dark: {
    text: '#F4F7FF',
    textSecondary: '#AFC2DE',

    background: '#101827',
    backgroundElement: '#172236',
    backgroundSelected: '#24385C',

    primary: '#76B1FF',
    primaryActive: '#A9CEFF',
    onPrimary: '#101827',
    brand: '#76B1FF',
    accent: '#00CDBF',

    card: '#172236',
    cardTint: '#1D2C43',
    headerBackground: '#101827',
    tabBackground: '#172236',
    inputBackground: '#203047',

    border: '#334764',
    icon: '#AFC2DE',

    badgeBackground: '#24385C',
    badgeText: '#A9CEFF',

    success: '#55D6A0',
    danger: '#FF7B85',
  },
} as const;

// Colores para los fondos degradados del prototipo.
// Se usarán al diseñar las pantallas.
export const BackgroundGradients = {
  light: [
    Palette.background,
    Palette.backgroundBlue,
    Palette.backgroundLavender,
    Palette.backgroundCyan,
  ],
  dark: [
    '#101827',
    '#172136',
    '#1A1B35',
    '#122C3B',
  ],
} as const;

export type ThemeName = keyof typeof Colors;

export type ThemeColor =
  keyof typeof Colors.light & keyof typeof Colors.dark;

export type AppThemeColors =
  (typeof Colors)[ThemeName];

// Fuentes compatibles con Android, iOS y web.
export const Fonts = Platform.select({
  ios: {
    sans: 'system-ui',
    serif: 'ui-serif',
    rounded: 'ui-rounded',
    mono: 'ui-monospace',
  },
  default: {
    sans: 'normal',
    serif: 'serif',
    rounded: 'normal',
    mono: 'monospace',
  },
  web: {
    sans: 'var(--font-display)',
    serif: 'var(--font-serif)',
    rounded: 'var(--font-rounded)',
    mono: 'var(--font-mono)',
  },
});

// Conservamos los valores originales para evitar
// incompatibilidades con componentes ya existentes.
export const Spacing = {
  half: 2,
  one: 4,
  two: 8,
  three: 16,
  four: 24,
  five: 32,
  six: 64,
} as const;

// Radios reutilizables para tarjetas, botones y etiquetas.
export const Radius = {
  small: 12,
  medium: 16,
  large: 24,
  pill: 999,
} as const;

export const BottomTabInset =
  Platform.select({ ios: 50, android: 80 }) ?? 0;

export const MaxContentWidth = 800;
