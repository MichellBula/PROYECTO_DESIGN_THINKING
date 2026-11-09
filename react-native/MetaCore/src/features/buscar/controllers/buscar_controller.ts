import { useCallback, useEffect, useMemo, useState } from "react";

import { BuscarRemoteDatasource } from "../data/buscar_remote_datasource";
import type { ProjectInfo } from "../data/project_info";

// Equivalente a GetxController en React; se usa dentro de componentes.
export function useBuscarController(datasource: BuscarRemoteDatasource) {
  const [searchText, setSearchText] = useState("");
  const [showAvailable, setShowAvailable] = useState(true);
  const [filters, setFilters] = useState<string[]>([]);
  const [projects, setProjects] = useState<ProjectInfo[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState("");

  const loadProjects = useCallback(async (): Promise<void> => {
    setIsLoading(true);
    setErrorMessage("");

    console.log("[BUSCAR_CONTROLLER] Cargando proyectos...");
    try {
      const result = await datasource.getProjects();
      setProjects(result);
      console.log(
        "[BUSCAR_CONTROLLER] Proyectos cargados:",
        result.length
      );
    } catch (error) {
      setErrorMessage("No fue posible cargar los proyectos.");
      console.error("[BUSCAR_CONTROLLER] Error cargando proyectos:", error);
    } finally {
      setIsLoading(false);
      console.log("[BUSCAR_CONTROLLER] Consulta finalizada.");
    }
  }, [datasource]);

  // Equivalente a onInit: el hook realiza la carga al montarse.
  useEffect(() => {
    void loadProjects();
  }, [loadProjects]);

  const isProjectAvailable = useCallback(
    (project: ProjectInfo): boolean => {
      const parts = project.closingDate.split("/");
      if (parts.length !== 3) return false;

      const [day, month, year] = parts.map(Number);
      if (
        !Number.isInteger(day) ||
        !Number.isInteger(month) ||
        !Number.isInteger(year) ||
        day < 1 || month < 1 || month > 12
      ) {
        return false;
      }

      const closingDate = new Date(year, month - 1, day, 23, 59, 59);
      if (
        closingDate.getFullYear() !== year ||
        closingDate.getMonth() !== month - 1 ||
        closingDate.getDate() !== day
      ) {
        return false;
      }

      return Date.now() <= closingDate.getTime();
    },
    []
  );

  const visibleProjects = useMemo(
    () =>
      projects.filter((project) => {
        if (showAvailable !== isProjectAvailable(project)) return false;
        if (filters.length === 0) return true;

        const searchableText = [
          project.name,
          project.leader,
          project.area,
          project.description,
          project.keywords,
          ...project.requirements,
          ...project.roles,
        ].join(" ").toLowerCase();

        return filters.every((filter) =>
          searchableText.includes(filter)
        );
      }),
    [projects, showAvailable, filters, isProjectAvailable]
  );

  const changeView = useCallback((value: boolean): void => {
    setShowAvailable(value);
  }, []);

  const addFilter = useCallback((): void => {
    const value = searchText.trim().toLowerCase();
    if (!value) return;

    setFilters((current) =>
      current.includes(value) ? current : [...current, value]
    );
    setSearchText("");
  }, [searchText]);

  const removeFilter = useCallback((filter: string): void => {
    setFilters((current) =>
      current.filter((item) => item !== filter)
    );
  }, []);

  const clearFilters = useCallback((): void => {
    setFilters([]);
    setSearchText("");
  }, []);

  return {
    searchText,
    setSearchText,
    showAvailable,
    filters,
    projects,
    isLoading,
    errorMessage,
    visibleProjects,
    isProjectAvailable,
    changeView,
    addFilter,
    removeFilter,
    clearFilters,
    loadProjects,
    refreshProjects: loadProjects,
  };
}
