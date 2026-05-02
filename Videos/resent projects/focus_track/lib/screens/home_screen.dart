import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import 'add_relapse_screen.dart';
import 'history_screen.dart';
import 'badges_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _quotes = [
    "Every day is a new beginning.",
    "Stay strong, you're in control.",
    "Discipline is the bridge between goals and accomplishment.",
    "The pain of discipline is far less than the pain of regret.",
    "Your future self will thank you.",
    "Don't count the days, make the days count.",
    "Small progress is still progress.",
    "You are stronger than you think.",
    "Focus on the step in front of you.",
    "The best view comes after the hardest climb.",
    "Self-control is strength. Right thought is mastery.",
    "Be the master of your own destiny.",
    "It's not about perfect, it's about effort.",
    "One day or day one. You decide.",
    "Your only limit is you.",
    "Prove yourself to yourself, not others.",
    "Strength grows in the moments you think you can't go on.",
    "You didn't come this far to only come this far.",
    "The secret of change is to focus all your energy on building the new.",
    "Difficult roads often lead to beautiful destinations.",
    "Believe in yourself and all that you are.",
    "The struggle you're in today is developing the strength you need for tomorrow.",
    "It always seems impossible until it's done.",
    "Don't stop when you're tired. Stop when you're done.",
    "Success is the sum of small efforts repeated day in and day out.",
  ];

  late Timer _quoteTimer;
  String _currentQuote = "Stay strong, you're in control.";

  @override
  void initState() {
    super.initState();
    _startQuoteRotation();
  }

  void _startQuoteRotation() {
    _quoteTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          final randomIndex = DateTime.now().millisecondsSinceEpoch % _quotes.length;
          _currentQuote = _quotes[randomIndex];
        });
      }
    });
  }

  @override
  void dispose() {
    _quoteTimer.cancel();
    super.dispose();
  }

  Future<void> _showStartTimerDialog(BuildContext context) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start timer from?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.play_arrow,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                  title: Text(
                    'Now',
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await provider.resetTimer();   // ✅ টাইমার শুরু, বাটন I Slipped Up হবে
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isActive = provider.isTimerRunning;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'NO FAP!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 22,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(!themeProvider.isDarkMode),
            tooltip: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
          IconButton(
            icon: Icon(Icons.settings, color: isDark ? Colors.white70 : Colors.black54),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          TextButton.icon(
            onPressed: () => provider.signOut(),
            icon: Icon(Icons.logout, color: isDark ? Colors.white70 : Colors.black54),
            label: Text(
              'Logout',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ব্যাজ কার্ড
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    provider.appUser?.currentBadge ?? 'Clown',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      shadows: [Shadow(color: Colors.orangeAccent, blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Current Badge',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // মোটিভেশনাল উক্তি (৫ সেকেন্ড ব্যবধান)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _currentQuote,
                key: ValueKey(_currentQuote),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ডেইজ কাউন্টার
            Text(
              '${provider.currentStreak}',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
                height: 1.0,
              ),
            ),
            Text(
              'Days',
              style: TextStyle(fontSize: 20, color: isDark ? Colors.white54 : Colors.black54),
            ),
            const SizedBox(height: 8),

            // টাইমার
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
                ),
              ),
              child: Text(
                provider.formattedTime,
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ডায়নামিক বাটন
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: !isActive
                  ? _buildGetFocusButton(context)
                  : _buildSlippedUpButton(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgesScreen()));
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Badges'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildGetFocusButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _showStartTimerDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Get Focus',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlippedUpButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRelapseScreen()));
        },
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
        label: const Text(
          'I Slipped Up',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}