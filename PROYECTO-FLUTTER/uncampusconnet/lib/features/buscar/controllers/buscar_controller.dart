import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uncampusconnet/features/buscar/data/information_list.dart';

class BuscarController extends GetxController {
  final searchController = TextEditingController();

  final showAvailable = true.obs;
  final filters = <String>[].obs;

  List<ProjectInfo> get visibleProjects {
    return availableProjects.where((project) {
      final isAvailable = isProjectAvailable(project);

      if (showAvailable.value != isAvailable) {
        return false;
      }

      if (filters.isEmpty) {
        return true;
      }

      final searchableText = [
        project.name,
        project.leader,
        project.area,
        project.description,
        project.keywords,
        ...project.requirements,
        ...project.roles,
      ].join(' ').toLowerCase();

      return filters.every(searchableText.contains);
    }).toList();
  }

  bool isProjectAvailable(ProjectInfo project) {
    final parts = project.closingDate.split('/');

    if (parts.length != 3) {
      return false;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return false;
    }

    final closingDate = DateTime(
      year,
      month,
      day,
      23,
      59,
      59,
    );

    return !DateTime.now().isAfter(closingDate);
  }

  void changeView(bool value) {
    showAvailable.value = value;
  }

  void addFilter() {
    final value = searchController.text.trim().toLowerCase();

    if (value.isEmpty) {
      return;
    }

    if (!filters.contains(value)) {
      filters.add(value);
    }

    searchController.clear();
  }

  void removeFilter(String filter) {
    filters.remove(filter);
  }

  void clearFilters() {
    filters.clear();
    searchController.clear();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
