import 'dart:convert';
import 'dart:io';

import 'package:flutter_ui/project.dart';
import 'package:flutter_ui/recent_projects.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/.diffy');
  }

  writeRecentProjects(RecentProjects recentProjects) async {
    final path = await _getLocalFile();
    await (path).writeAsString(jsonEncode(recentProjects.getProjects()));
  }

  readRecentProjects() async {
    final file = await _getLocalFile();
    String jsonStr = await file.readAsString();

    var projectObjJson = jsonDecode(jsonStr) as List;

    List<Project> recentProjects =
        projectObjJson.map((pJson) => Project.fromJson(pJson)).toList();
    return recentProjects;
  }
}
