import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/ui.dart';
import 'history_page.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key, required this.activity});

  final Map<String, dynamic> activity;

  Future<void> _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar actividad'),
        content: const Text('¿Seguro que querés borrarla?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    try {
      await Supabase.instance.client
          .from('activities')
          .delete()
          .eq('id', activity['id']);
      if (!context.mounted) return;
      showToast(context, 'Actividad borrada');
      Navigator.pop(context, true); // true = se borró, el historial recarga
    } catch (e) {
      if (context.mounted) {
        showToast(context, 'No se pudo borrar', error: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = activity['type'] == 'run';
    final km = (activity['distance_km'] as num).toDouble();
    final seconds = activity['duration_seconds'] as int;
    final date = DateTime.parse(activity['created_at']);
    final route = parseRoute(activity['route']);
    final speed = seconds > 0 ? km / (seconds / 3600) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(isRunning ? 'Carrera' : 'Caminata'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: routeMap(route, interactive: true)),
          appearAnimation(Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatDate(date),
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  '${formatDistance(km)} ${km < 1 ? 'm' : 'km'}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    detailStat(Icons.timer, formatDuration(seconds), 'Tiempo'),
                    detailStat(Icons.speed, formatPace(seconds, km), 'Ritmo /km'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    detailStat(Icons.directions_run, speed.toStringAsFixed(1), 'Km/h promedio'),
                    detailStat(Icons.local_fire_department, '${activity['calories']}', 'Kcal'),
                  ],
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

Widget detailStat(IconData icon, String value, String label) {
  return Expanded(
    child: Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ],
    ),
  );
}
