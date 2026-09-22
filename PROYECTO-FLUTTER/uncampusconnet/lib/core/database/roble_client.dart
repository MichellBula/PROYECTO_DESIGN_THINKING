import 'package:roble/roble.dart';

import 'roble_config.dart';

class RobleClient {
  RobleClient._();

  static final RobleApiDataBase instance =
      RobleApiDataBase(
    config: RobleApiConfig.fromContract(
      baseUrl: RobleConfig.baseUrl,
      contractId: RobleConfig.contractId,
    ),
  );
}