import 'package:flutter/material.dart';

import '../models/breed.dart';
import '../services/cat_api.dart';

/// Screen 1: FutureBuilder. Fetches once; Retry creates a new Future.
class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _api = CatApi();
  late Future<List<Breed>> _future;

  @override
  void initState() {
    super.initState();
    // Created ONCE here, not in build(), so rebuilds never refetch.
    _future = _api.fetchBreeds();
  }

  void _retry() {
    setState(() {
      _future = _api.fetchBreeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Breed>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48),
                  const SizedBox(height: 12),
                  Text('${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        final breeds = snapshot.data ?? [];
        if (breeds.isEmpty) {
          return const Center(child: Text('No breeds found.'));
        }
        return ListView.separated(
          itemCount: breeds.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final b = breeds[i];
            return ListTile(
              leading: CircleAvatar(child: Text(b.name[0])),
              title: Text(b.name),
              subtitle: Text('${b.country} • ${b.coat} • ${b.pattern}'),
            );
          },
        );
      },
    );
  }
}
