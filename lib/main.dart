// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_web/material.dart';


import 'package:logging/logging.dart';

import 'session.dart';
import 'vlc.dart';
import 'screen/home.dart';
import 'screen/control.dart';
import 'screen/playlist.dart';


void main() {

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });


  runApp(new MyApp());

//  runApp(new Text('Hello World', textDirection: TextDirection.ltr));
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'VLC Control',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: new MyHomePage(title: 'Flutter Demo Home Page'),
      routes: <String, WidgetBuilder>{
        '/':         (BuildContext context) => new HomePage(title: 'VLC Control'),
        // '/chat': (BuildContext context) => new ChatScreen(),
        ControlScreen.ROUTE: (BuildContext context) => new ControlScreen(),
        '/playlist': (BuildContext context) => new PlaylistScreen()
      },
    );
  }
}

