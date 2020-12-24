import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:flutter_ui/project.dart';
import 'package:flutter_ui/recent_projects.dart';
import 'package:flutter_ui/storage.dart';

void main() {
  runApp(new SuperApp(
    store: Storage(),
  ));
}

class SuperApp extends StatefulWidget {
  final Storage store;
  SuperApp({Key key, this.store}) : super(key: key);

  @override
  _SuperAppState createState() => _SuperAppState();
}

class _SuperAppState extends State<SuperApp> {
  RecentProjects _recentProjects;

  @override
  void initState() {
    super.initState();
    _recentProjects = new RecentProjects([]);
    widget.store.readRecentProjects().then((p) {
      setState(() {
        _recentProjects.addProjects(p);
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: new MediaQueryData.fromWindow(ui.window),
        child: new Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(body: buildRow())));
  }

  Row buildRow() {
    return Row(
      children: [buildLogoAndActionColumn(), buildRecentProjectColumn()],
    );
  }

  Expanded buildRecentProjectColumn() {
    return Expanded(
        child: DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Container(
        padding: EdgeInsets.all(10),
        color: Color.fromRGBO(27, 27, 27, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("RECENT PROJECTS"), buildRecentProjectList()],
        ),
      ),
    ));
  }

  Column buildRecentProjectList() {
    return Column(
        children: _recentProjects == null
            ? []
            : _recentProjects
                .getProjects()
                .map((e) => new ActionListItem(
                      title: e.name,
                      subTitle: e.path,
                    ))
                .toList());
  }

  Expanded buildLogoAndActionColumn() {
    return Expanded(
        child: DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Container(
        color: Color.fromRGBO(23, 23, 23, 1),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  child: Center(
                child: Text("Diffy", style: TextStyle(fontSize: 48)),
              )),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new ActionListItem(
                      title: "Open a local repository",
                      subTitle: "Open an existing project on your computer",
                      onPressed: openLocalRepo),
                  new ActionListItem(
                    title: "Clone a remote repository",
                    subTitle: "Clone a remote project from GitHub, BitBucket",
                  ),
                  new ActionListItem(
                    title: "Getting started with Diffy",
                    subTitle: "Learn more about what you can do with Diffy",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  openLocalRepo() async {
    final result = await showOpenPanel(
        allowsMultipleSelection: true, canSelectDirectories: true);
    final path = result.paths.join('\n');
    setState(() {
      _recentProjects.addProject(Project("tmp", path));
    });
    await widget.store.writeRecentProjects(_recentProjects);
  }
}

class ActionListItem extends StatefulWidget {
  final String title;
  final String subTitle;
  final Function onPressed;

  const ActionListItem({Key key, this.title, this.subTitle, this.onPressed})
      : super(key: key);

  @override
  _ActionListItemState createState() {
    return _ActionListItemState();
  }
}

class _ActionListItemState extends State<ActionListItem> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed ?? () => {},
      child: MouseRegion(
          onHover: (event) {
            setState(() {
              hover = true;
            });
          },
          onExit: (event) {
            setState(() {
              hover = false;
            });
          },
          cursor: SystemMouseCursors.alias,
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              color: (hover == null || !hover)
                  ? Colors.transparent
                  : Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title),
                  Text(widget.subTitle, style: TextStyle(color: Colors.white54))
                ],
              ))),
    );
  }
}
