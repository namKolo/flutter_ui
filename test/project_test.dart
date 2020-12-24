import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/project.dart';

void main() {
  test("test to check Project", () {
    // Arrange
    var project = Project("Nam", "D:/Path");
    expect(project.name, "Nam");
    expect(project.path, "D:/Path");
    expect(project.toJson().toString(), "{name: Nam, path: D:/Path}");
  });

  test("Should parse to Project successfully", () {
    var jsonStr = "{\"name\": \"Nam\", \"path\": \"Path\"}";
    var project = Project.fromJson(jsonDecode(jsonStr) as Map);
    expect(project.name, "Nam");
  });
}
