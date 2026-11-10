
import {
  ScrollView,
  type ScrollViewProps,
} from 'react-native';

/**
 * Contenedor de desplazamiento reutilizable de MetaCore.
 * Oculta los indicadores y conserva el scroll táctil.
 */
export function AppScrollView({
  children,
  showsVerticalScrollIndicator = false,
  showsHorizontalScrollIndicator = false,
  keyboardShouldPersistTaps = 'handled',
  ...props
}: ScrollViewProps) {
  return (
    <ScrollView
      {...props}
      scrollEnabled={props.scrollEnabled ?? true}
      showsVerticalScrollIndicator={
        showsVerticalScrollIndicator
      }
      showsHorizontalScrollIndicator={
        showsHorizontalScrollIndicator
      }
      keyboardShouldPersistTaps={keyboardShouldPersistTaps}
    >
      {children}
    </ScrollView>
  );
}
