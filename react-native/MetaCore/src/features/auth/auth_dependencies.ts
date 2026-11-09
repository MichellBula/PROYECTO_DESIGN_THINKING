import { RobleClient } from "../../core/roble/roble_client";

import { AuthRemoteDataSourceImpl } from "./data/datasources/auth_remote_data_source_impl";

import { AuthRepositoryImpl } from "./data/repositories/auth_repository_impl";

// Fuente de datos que utiliza Roble.
const authRemoteDataSource = new AuthRemoteDataSourceImpl(
  RobleClient.instance
);

// Repositorio de autenticación.
export const authRepository = new AuthRepositoryImpl(
  authRemoteDataSource
);