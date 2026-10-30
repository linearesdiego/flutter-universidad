import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import '../widgets/ui.dart';
import 'login_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool _isRunning = true;

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    showToast(context, 'Sesión cerrada');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva actividad'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: mapView()),
          appearAnimation(Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 12)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    typeOption(
                      icon: Icons.directions_walk,
                      label: 'Caminar',
                      selected: !_isRunning,
                      onTap: () => setState(() => _isRunning = false),
                    ),
                    const SizedBox(width: 12),
                    typeOption(
                      icon: Icons.directions_run,
                      label: 'Correr',
                      selected: _isRunning,
                      onTap: () => setState(() => _isRunning = true),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    statItem('00:00', 'Tiempo'),
                    statItem('0.00', 'Km'),
                    statItem('--:--', 'Ritmo /km'),
                  ],
                ),
                const SizedBox(height: 24),
                playButton(() {}),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

Widget mapView() {
  return FlutterMap(
    options: const MapOptions(
      initialCenter: LatLng(-34.6037, -58.3816),
      initialZoom: 15,
      interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.running_tracker',
      ),
      const MarkerLayer(
        markers: [
          Marker(
            point: LatLng(-34.6037, -58.3816),
            child: Icon(Icons.my_location, color: AppTheme.primaryColor, size: 32),
          ),
        ],
      ),
    ],
  );
}

Widget typeOption({
  required IconData icon,
  required String label,
  required bool selected,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryColor : AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? Colors.white : AppTheme.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget statItem(String value, String label) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
    ],
  );
}

Widget playButton(VoidCallback onPressed) {
  return SizedBox(
    width: 84,
    height: 84,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: EdgeInsets.zero,
      ),
      child: const Icon(Icons.play_arrow_rounded, size: 52),
    ),
  );
}
