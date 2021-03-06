import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';

import './pages/auth.dart';
import './pages/products.dart';
import './pages/products_admin.dart';
import './pages/product.dart';
import './scoped-models/main.dart';
import './models/product.dart';
import './widgets/helpers/custom_route.dart';

import './shared/global_config.dart';
import './shared/adaptive_theme.dart';

void main() {
  MapView.setApiKey(apiKey);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;
  final _platformChannel = MethodChannel('flutter-course.com/battery');

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;

    try {
      final int result = await _platformChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level is: $result%.';
    } catch (error) {
      batteryLevel = 'Failed to get battery level.';
    }

    print(batteryLevel);
  }

  @override
  void initState() {
    _model.autoAuthenticate();

    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });

    _getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: getAdaptiveTheme(context),
        //home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>
              _isAuthenticated ? ProductsPage(_model) : AuthPage(),
          '/admin': (BuildContext context) =>
              _isAuthenticated ? ProductsAdminPage(_model) : AuthPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }

          final List<String> pathElements = settings.name.split('/');

          if (pathElements[0] != '') {
            return null;
          }

          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];

            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });

            return CustomRoute<bool>(
              builder: (BuildContext context) =>
                  _isAuthenticated ? ProductPage(product) : AuthPage(),
            );
          }

          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  _isAuthenticated ? ProductsPage(_model) : AuthPage());
        },
      ),
    );
  }
}
