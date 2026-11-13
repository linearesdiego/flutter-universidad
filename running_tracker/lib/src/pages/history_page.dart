import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'activity_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> _activities = _loadActivities();

  Future<List<Map<String, dynamic>>> _loadActivities() {
    return Supabase.instance.client
        .from('activities')
        .select()
        .order('created_at', ascending: false);
  }

  Future<void> _openDetail(Map<String, dynamic> activity) async {
    final deleted = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityDetailPage(activity: activity),
      ),
    );
    // Si se borró la actividad, recargo la lista
    if (deleted == true) setState(() => _activities = _loadActivities());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _activities,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('No se pudo cargar el historial'));
          }
          final activities = snapshot.data!;
          if (activities.isEmpty) {
            return const Center(
              child: Text(
                'Todavía no tenés actividades',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            itemBuilder: (context, index) => activityCard(
              activities[index],
              () => _openDetail(activities[index]),
            ),
          );
        },
      ),
    );
  }
}

Widget activityCard(Map<String, dynamic> activity, VoidCallback onTap) {
  final isRunning = activity['type'] == 'run';
  final km = (activity['distance_km'] as num).toDouble();
  final seconds = activity['duration_seconds'] as int;
  final date = DateTime.parse(activity['created_at']);
  final route = parseRoute(activity['route']);

  return Card(
    color: AppTheme.surfaceColor,
    margin: const EdgeInsets.only(bottom: 16),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: onTap,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(
            isRunning ? Icons.directions_run : Icons.directions_walk,
            color: AppTheme.primaryColor,
            size: 32,
          ),
          title: Text(
            isRunning ? 'Carrera' : 'Caminata',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            formatDate(date),
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
        // IgnorePointer para que el toque llegue a la tarjeta y no al mapa
        SizedBox(height: 160, child: IgnorePointer(child: routeMap(route))),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              smallStat(formatDistance(km), distanceUnit(km)),
              smallStat(formatDuration(seconds), 'Tiempo'),
              smallStat(formatPace(seconds, km), 'Ritmo /km'),
              smallStat('${activity['calories']}', 'Kcal'),
            ],
          ),
        ),
      ],
      ),
    ),
  );
}

// La ruta viene de Supabase como [[lat, lng], ...]
List<LatLng> parseRoute(dynamic route) {
  return (route as List)
      .map((p) => LatLng((p[0] as num).toDouble(), (p[1] as num).toDouble()))
      .toList();
}

Widget routeMap(List<LatLng> route, {bool interactive = false}) {
  // Sin puntos suficientes no se puede encuadrar el mapa
  if (route.length < 2) {
    return Container(
      color: AppTheme.backgroundColor,
      alignment: Alignment.center,
      child: const Text(
        'Sin ruta registrada',
        style: TextStyle(color: AppTheme.textSecondary),
      ),
    );
  }

  return FlutterMap(
    options: MapOptions(
      initialCameraFit: CameraFit.coordinates(
        coordinates: route,
        padding: const EdgeInsets.all(24),
      ),
      interactionOptions: InteractionOptions(
        flags: interactive
            ? InteractiveFlag.pinchZoom |
                InteractiveFlag.drag |
                InteractiveFlag.scrollWheelZoom
            : InteractiveFlag.none,
      ),
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.running_tracker',
        tileBuilder: darkModeTileBuilder, // pinta el mapa en modo oscuro
      ),
      PolylineLayer(
        polylines: [
          Polyline(points: route, strokeWidth: 4, color: AppTheme.primaryColor),
        ],
      ),
      startEndMarkers(route),
    ],
  );
}

// Como Strava: punto verde donde empezó y punto rojo donde terminó
MarkerLayer startEndMarkers(List<LatLng> route) {
  return MarkerLayer(
    markers: [
      Marker(point: route.first, width: 18, height: 18, child: routeDot(Colors.green)),
      Marker(point: route.last, width: 18, height: 18, child: routeDot(Colors.red)),
    ],
  );
}

Widget routeDot(Color color) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 3),
      boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 4)],
    ),
  );
}

Widget smallStat(String value, String label) {
  return Column(
    children: [
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
    ],
  );
}
