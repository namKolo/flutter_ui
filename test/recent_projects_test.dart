import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/project.dart';
import 'package:flutter_ui/recent_projects.dart';

void main() {
  test("Recent Projects - Add project should work correctly", () {
    var recentProjects = RecentProjects([]);
    recentProjects.addProject(Project("Nam", "D:/Path"));
    expect(recentProjects.getProjects().length, 1);
  });
  test("Recent Projects - Add projects should be okay", () {
    var recentProjects = RecentProjects([]);
    recentProjects
        .addProjects([Project("Nam", "D:/Path"), Project("Nam 1", "D:/Path1")]);
    expect(recentProjects.getProjects().length, 2);
  });

  test("Recent Projects - Add project should not add duplicating projects", () {
    var recentProjects = RecentProjects([]);
    recentProjects.addProject(Project("Nam", "D:/Path"));
    recentProjects.addProject(Project("Nam1", "D:/Path"));
    expect(recentProjects.getProjects().length, 1);
  });
}
