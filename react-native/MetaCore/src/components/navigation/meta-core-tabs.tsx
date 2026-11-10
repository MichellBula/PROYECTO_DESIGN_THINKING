
import { Tabs } from 'expo-router';

import { BottomNavigation } from '@/components/navigation/bottom-navigation';

/**
 * Navegación principal de MetaCore.
 * Define las pantallas y utiliza nuestra barra inferior.
 */
export default function MetaCoreTabs() {
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
      }}
      tabBar={() => <BottomNavigation />}
    >
      {/* Pantallas principales */}
      <Tabs.Screen
        name="index"
        options={{
          title: 'Inicio',
        }}
      />

      <Tabs.Screen
        name="buscar"
        options={{
          title: 'Buscar proyectos',
        }}
      />

      <Tabs.Screen
        name="crear"
        options={{
          title: 'Crear proyecto',
        }}
      />

      <Tabs.Screen
        name="mis-proyectos"
        options={{
          title: 'Mis proyectos',
        }}
      />

      <Tabs.Screen
        name="perfil"
        options={{
          title: 'Mi perfil',
        }}
      />

      {/* Pantallas adicionales sin botón en la barra */}
      <Tabs.Screen
        name="solicitudes"
        options={{
          href: null,
        }}
      />

      <Tabs.Screen
        name="configuracion"
        options={{
          href: null,
        }}
      />

      {/* Pantalla original de Expo, oculta temporalmente */}
      <Tabs.Screen
        name="explore"
        options={{
          href: null,
        }}
      />
    </Tabs>
  );
}
