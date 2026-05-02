import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final relapses = provider.relapses;

    return Scaffold(
      appBar: AppBar(title: const Text('Review Your Progress')),
      body: relapses.isEmpty
          ? const Center(child: Text('No relapses recorded yet!'))
          : ListView.builder(
              itemCount: relapses.length,
              itemBuilder: (context, index) {
                final r = relapses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text('Advanced - ${r.daysAchieved} Days'),
                    subtitle: Text(r.reason),
                    trailing: Text(
                      '${r.timestamp.day}/${r.timestamp.month}/${r.timestamp.year}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}