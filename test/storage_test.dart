import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ui/project.dart';
import 'package:flutter_ui/recent_projects.dart';
import 'package:flutter_ui/storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Storage', () {
    setUpAll(() async {
      // Create a temporary directory.
      final directory = await Directory.systemTemp.createTemp();

      // Mock out the MethodChannel for the path_provider plugin.
      const MethodChannel('plugins.flutter.io/path_provider')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        // If you're getting the apps documents directory, return the path to the
        // temp directory on the test environment instead.
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return directory.path;
        }
        return null;
      });
    });

    test("Storage - Should write and read successfully", () async {
      var storage = new Storage();
      await storage
          .writeRecentProjects(RecentProjects([Project("Nam", "Path")]));
      var recentProjects = await storage.readRecentProjects();
      expect(recentProjects.length, 1);
      expect(recentProjects.first.name, "Nam");
      expect(recentProjects.first.path, "Path");
    });
  });
}
