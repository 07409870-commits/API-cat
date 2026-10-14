import 'package:flutter/material.dart';

import 'screens/belt_screen.dart';
import 'screens/order_screen.dart';

void main() => runApp(const CatBeltApp());

class CatBeltApp extends StatelessWidget {
  const CatBeltApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Belt',
      theme: ThemeData(colorSchemeSeed: Colors.orange, useMaterial3: true),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _titles = ['The Order (Future)', 'The Belt (Stream)'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      // IndexedStack keeps both screens alive so switching tabs
      // doesn't refetch Screen 1 or restart Screen 2's stream.
      body: IndexedStack(
        index: _index,
        children: const [OrderScreen(), BeltScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Order'),
          NavigationDestination(icon: Icon(Icons.stream), label: 'Belt'),
        ],
      ),
    );
  }
}
