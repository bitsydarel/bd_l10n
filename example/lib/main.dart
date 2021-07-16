/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// TODO: un comment after code generation.
// import 'package:flutter_demo/localization/application/application_feature.dart'; Uncomment after generated code.
// import 'package:flutter_demo/localization/authentication/authentication_feature.dart'; Uncomment after generated code.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          // TODO: uncomment after code generation.
          // final ApplicationFeature localization = ApplicationFeature.of(
          //   routeContext,
          // );

          // return MyHomePage(title: localization.applicationTitle);
          return MyHomePage(title: 'Home tool');
        },
        '/login': (BuildContext routeContext) {
          return LoginPage();
        },
      },
      localizationsDelegates: [
        // TODO: uncomment after code generation.
        // ApplicationFeature.delegate,
        // AuthenticationFeature.delegate,
        ...GlobalMaterialLocalizations.delegates
      ],
      // TODO uncomment after code generation.
      // supportedLocales: ApplicationFeature.supportedLocales,
      supportedLocales: <Locale>[Locale.fromSubtags(languageCode: 'en')],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    required this.title,
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    // TODO: uncomment after code generation.
    // final localization = ApplicationFeature.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TODO uncomment after code generation.
            // Text(localization.homeDescription),
            Text('Clicked: '),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        // TODO: uncomment after code generation.
        // tooltip: localization.incrementButton,
        tooltip: 'Incremented',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: uncomment after code generation.
    // final localization = AuthenticationFeature.of(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: uncomment after code generation and replace.
            // TextFormField(initialValue: localization.userNameField),
            TextFormField(initialValue: 'Enter username'),
            const SizedBox(height: 16),
            // TODO: uncomment after code generation and replace.
            // TextFormField(initialValue: localization.passwordField),
            TextFormField(initialValue: 'Enter password'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: null,
              // TODO: uncomment after code generation and replace.
              // child: Text(localization.loginButton),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
