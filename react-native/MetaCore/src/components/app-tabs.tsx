
import { NativeTabs } from 'expo-router/unstable-native-tabs';

import { useTheme } from '@/hooks/use-theme';

export default function AppTabs() {
  const theme = useTheme();

  return (
    <NativeTabs
      backgroundColor={theme.tabBackground}
      indicatorColor={theme.backgroundSelected}
      tintColor={theme.primary}
      iconColor={{
        default: theme.icon,
        selected: theme.primary,
      }}
      labelStyle={{
        default: { color: theme.textSecondary },
        selected: { color: theme.primary },
      }}
    >
      <NativeTabs.Trigger name="index">
        <NativeTabs.Trigger.Label>
          Inicio
        </NativeTabs.Trigger.Label>

        <NativeTabs.Trigger.Icon
          src={require('@/assets/images/tabIcons/home.png')}
          renderingMode="template"
        />
      </NativeTabs.Trigger>

      <NativeTabs.Trigger name="explore">
        <NativeTabs.Trigger.Label>
          Explorar
        </NativeTabs.Trigger.Label>

        <NativeTabs.Trigger.Icon
          src={require('@/assets/images/tabIcons/explore.png')}
          renderingMode="template"
        />
      </NativeTabs.Trigger>
    </NativeTabs>
  );
}
