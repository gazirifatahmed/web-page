import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final badges = provider.getAllBadges();
    final currentStreak = provider.currentStreak;

    return Scaffold(
      appBar: AppBar(title: const Text('Collect All the Badges!')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          final int requiredDays = badge['days'] as int;
          final bool achieved = currentStreak >= requiredDays ||
              (provider.appUser?.longestStreak ?? 0) >= requiredDays;

          return Card(
            color: achieved ? Colors.amber.withOpacity(0.2) : null,
            child: ListTile(
              leading: Icon(
                achieved ? Icons.emoji_events : Icons.lock,
                color: achieved ? Colors.amber : Colors.grey,
              ),
              title: Text(
                badge['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: achieved ? Colors.amber : null,
                ),
              ),
              subtitle: Text('$requiredDays+ Days'),
              trailing: achieved
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.radio_button_unchecked),
            ),
          );
        },
      ),
    );
  }
}