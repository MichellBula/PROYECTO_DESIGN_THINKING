import '../entities/create_project_request.dart';
import '../../data/datasources/create_project_complete_remote_datasource.dart';

class CreateCompleteProject {
  final CreateProjectCompleteRemoteDatasource datasource;

  CreateCompleteProject({CreateProjectCompleteRemoteDatasource? datasource})
    : datasource = datasource ?? CreateProjectCompleteRemoteDatasource();

  Future<Map<String, dynamic>> call(CreateProjectRequest request) async {
    return await datasource.crearProyectoCompleto(request);
  }
}
