import { useCallback, useEffect, useRef, useState } from "react";

import type { Mensaje } from "../data/solicitud_data";

const MENSAJE_INICIAL: Mensaje = {
  texto:
    "Hola!!, me gustó mucho tu solicitud, podríamos agendar una entrevista para conocerte más??",
  isMine: true,
};

// Chat simulado del código Dart original: NO envía mensajes a Roble.
// Scroll y campo de texto se implementarán luego en la pantalla React Native.
export function useChatController(onScrollToBottom?: () => void) {
  const [mensajes, setMensajes] = useState<Mensaje[]>([MENSAJE_INICIAL]);
  const [isTyping, setIsTyping] = useState(false);
  const [texto, setTexto] = useState("");
  const timers = useRef<Array<ReturnType<typeof setTimeout>>>([]);
  const scrollCallback = useRef(onScrollToBottom);
  scrollCallback.current = onScrollToBottom;

  const programar = useCallback((tiempo: number, callback: () => void) => {
    const timer = setTimeout(callback, tiempo);
    timers.current.push(timer);
  }, []);

  const desplazarseAlFinal = useCallback(() => {
    if (!scrollCallback.current) return;
    programar(100, () => scrollCallback.current?.());
  }, [programar]);

  useEffect(() => {
    // Simula la primera respuesta del otro usuario, igual que `onInit` en Dart.
    programar(2000, () => {
      setIsTyping(true);
      desplazarseAlFinal();

      programar(2000, () => {
        setIsTyping(false);
        setMensajes((previos) => [
          ...previos,
          { texto: "Hola! Claro, me encantaría. ¿Cuándo te queda bien?", isMine: false },
        ]);
        desplazarseAlFinal();
      });
    });

    return () => {
      for (const timer of timers.current) clearTimeout(timer);
      timers.current = [];
    };
  }, [programar, desplazarseAlFinal]);

  const sendMessage = useCallback(
    (mensaje?: string): void => {
      const contenido = (mensaje ?? texto).trim();
      if (!contenido) return;

      setMensajes((previos) => [
        ...previos,
        { texto: contenido, isMine: true },
      ]);
      setTexto("");
      desplazarseAlFinal();

      programar(1000, () => {
        setIsTyping(true);
        desplazarseAlFinal();

        programar(2000, () => {
          setIsTyping(false);
          setMensajes((previos) => [
            ...previos,
            { texto: "Perfecto, hablamos pronto 😊", isMine: false },
          ]);
          desplazarseAlFinal();
        });
      });
    },
    [texto, desplazarseAlFinal, programar]
  );

  return { mensajes, isTyping, texto, setTexto, sendMessage };
}
