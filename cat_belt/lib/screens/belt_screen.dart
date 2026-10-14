import 'package:flutter/material.dart';

import '../services/cat_api.dart';

/// Screen 2: StreamBuilder. A new fact every 5 seconds.
class BeltScreen extends StatefulWidget {
  const BeltScreen({super.key});

  @override
  State<BeltScreen> createState() => _BeltScreenState();
}

class _BeltScreenState extends State<BeltScreen> {
  late final Stream<FactResult> _stream;

  @override
  void initState() {
    super.initState();
    _stream = CatApi().factStream(); // created once
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FactResult>(
      stream: _stream,
      builder: (context, snapshot) {
        // Loading state: nothing has arrived yet.
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final result = snapshot.data!;

        // Error state: stream is still alive, will retry on next tick.
        if (result.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),
                  const SizedBox(height: 12),
                  Text(result.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Trying again in a few seconds...'),
                ],
              ),
            ),
          );
        }

        final fact = result.fact!;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Card(
                key: ValueKey(fact.fact),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.pets, size: 40),
                      const SizedBox(height: 12),
                      Text(fact.fact,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Text('${fact.length} characters',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
