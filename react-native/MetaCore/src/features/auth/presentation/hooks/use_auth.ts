import { useContext } from "react";

import { SesionContext } from "../context/sesion_context";

export function useAuth() {
  const contexto = useContext(SesionContext);

  if (contexto === null) {
    throw new Error(
      "useAuth debe utilizarse dentro de SesionProvider."
    );
  }

  return contexto;
}