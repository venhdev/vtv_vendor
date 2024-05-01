import 'package:flutter/material.dart';

import 'core/presentation/components/app_drawer.dart';
import 'core/presentation/pages/vendor_page.dart';
import 'features/order/presentation/pages/vendor_order_purchase_page.dart';

class VendorApp extends StatelessWidget {
  const VendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    // TODO title here?
      debugShowCheckedModeBanner: false,
      home: AppScaffold(),
    );
  }
}

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const VendorPage(),
    const VendorOrderPurchasePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _appTitle(int index) {
    switch (index) {
      case 0:
        return 'Shop của bạn';
      case 1:
        return '----';
      default:
        throw Exception('Invalid index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appTitle(_selectedIndex)),
        actions: [
          // notification
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          // chat
          const IconButton(
            icon: Icon(Icons.chat),
            onPressed: null,
          ),

          // setting
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
