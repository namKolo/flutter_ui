import 'package:flutter_ui/project.dart';

class RecentProjects {
  List<Project> _projects;

  RecentProjects(this._projects);

  addProject(Project p) {
    if (_projects.where((e) => e.path == p.path).isNotEmpty) return;
    _projects.insert(0, p);
  }

  addProjects(List<Project> p) {
    _projects.addAll(p);
  }

  List<Project> getProjects() {
    return _projects ?? [];
  }
}
