export class RobleConfig {
  static readonly baseUrl: string =
    process.env.EXPO_PUBLIC_ROBLE_BASE_URL ??
    "https://roble-api.test-openlab.uninorte.edu.co";

  static readonly contractId: string =
    process.env.EXPO_PUBLIC_ROBLE_CONTRACT_ID ?? "";
}