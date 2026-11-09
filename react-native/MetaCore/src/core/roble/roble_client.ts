import { RobleApiClient } from "roble-client";
import AsyncStorage from "@react-native-async-storage/async-storage";

import { RobleConfig } from "./roble_config";

export class RobleClient {
  static readonly instance = new RobleApiClient({
    baseUrl: RobleConfig.baseUrl,
    contractId: RobleConfig.contractId,
    storage: AsyncStorage,
  });
}