/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/localization/application/application_feature.dart';
import 'package:flutter_demo/localization/authentication/authentication_feature.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(_MyApp());
}

class _MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext routeContext) {
          final ApplicationFeature localization = ApplicationFeature.of(
            routeContext,
          );

          return _MyHomePage(title: localization.applicationTitle);
        },
        '/login': (BuildContext routeContext) {
          return _LoginPage();
        },
      },
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        ApplicationFeature.delegate,
        AuthenticationFeature.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: ApplicationFeature.supportedLocales,
    );
  }
}

/// My application home page.
class _MyHomePage extends StatefulWidget {
  /// Constructor.
  const _MyHomePage({required this.title, Key? key}) : super(key: key);

  /// Title of the home page.
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }
}

class _MyHomePageState extends State<_MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;

      if (_counter > 5) {
        Navigator.of(context).pushNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationFeature localization = ApplicationFeature.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(localization.homeDescription),
            const Text('Clicked: '),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: localization.incrementButton,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationFeature localization =
        AuthenticationFeature.of(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(initialValue: localization.userNameField),
            const SizedBox(height: 16),
            TextFormField(initialValue: localization.passwordField),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: null,
              child: Text(localization.loginButton),
            ),
          ],
        ),
      ),
    );
  }
}
