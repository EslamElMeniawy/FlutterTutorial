import 'package:flutter/material.dart';

import '../products_manager.dart';
import './products_admin.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('Manage Products'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProductsAdminPage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Easy List'),
        centerTitle: true,
      ),
      body: ProductsManager(),
    );
  }
}
