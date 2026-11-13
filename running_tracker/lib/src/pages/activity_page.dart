import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/ui.dart';
import 'history_page.dart';
import 'login_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final _mapController = MapController();
  LatLng _position = const LatLng(-31.5375, -68.5257);

  bool _isRunning = true;
  bool _recording = false;
  bool _saving = false;

  final List<LatLng> _route = [];
  double _distanceKm = 0;
  int _seconds = 0;

  Timer? _timer;
  StreamSubscription<Position>? _positionSub;

  @override
  void initState() {
    super.initState();
    _goToMyLocation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _positionSub?.cancel();
    super.dispose();
  }

  Future<bool> _checkPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) showToast(context, 'Activá la ubicación del teléfono', error: true);
      return false;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) showToast(context, 'Necesito permiso de ubicación', error: true);
      return false;
    }
    return true;
  }

  Future<void> _goToMyLocation() async {
    if (!await _checkPermission()) return;
    final p = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() => _position = LatLng(p.latitude, p.longitude));
    if (!_recording) _mapController.move(_position, 17);
  }

  Future<void> _start() async {
    if (!await _checkPermission()) return;

    setState(() {
      _recording = true;
      _route.clear();
      _distanceKm = 0;
      _seconds = 0;
    });

    // En Android 13+ hace falta permiso para mostrar la notificación
    if (isAndroid) await Permission.notification.request();

    // El tiempo se calcula desde la hora de inicio, así no se atrasa
    // si el teléfono pausa la app un rato en segundo plano
    final startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds = DateTime.now().difference(startTime).inSeconds);
    });

    _positionSub = Geolocator.getPositionStream(
      locationSettings: locationSettings(),
    ).listen((p) {
      final point = LatLng(p.latitude, p.longitude);
      setState(() {
        if (_route.isNotEmpty) {
          final last = _route.last;
          _distanceKm += Geolocator.distanceBetween(
                last.latitude, last.longitude, point.latitude, point.longitude) /
              1000;
        }
        _route.add(point);
        _position = point;
      });
    });
  }

  Future<void> _stop() async {
    _timer?.cancel();
    await _positionSub?.cancel();
    if (!mounted) return;
    setState(() => _recording = false);

    if (_route.length < 2) {
      showToast(context, 'Actividad muy corta, no se guardó', error: true);
      setState(() {
        _route.clear();
        _distanceKm = 0;
        _seconds = 0;
      });
      return;
    }

    setState(() => _saving = true);
    try {
      await Supabase.instance.client.from('activities').insert({
        'type': _isRunning ? 'run' : 'walk',
        'distance_km': _distanceKm,
        'duration_seconds': _seconds,
        'calories': calculateCalories(_distanceKm, _isRunning),
        'route': _route.map((p) => [p.latitude, p.longitude]).toList(),
      });
      if (!mounted) return;
      showToast(context, '¡Actividad guardada!');
    } catch (e) {
      if (mounted) showToast(context, 'No se pudo guardar la actividad', error: true);
    }
    if (mounted) setState(() => _saving = false);
  }

  // Botón "Listo": borra el resumen y deja todo en cero para la próxima
  void _reset() {
    setState(() {
      _route.clear();
      _distanceKm = 0;
      _seconds = 0;
    });
    _goToMyLocation();
  }

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
        title: Text(_recording ? 'Grabando...' : 'Nueva actividad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _recording
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HistoryPage()),
                    ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _recording ? null : _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Antes de empezar y al terminar se ve el mapa (con la ruta).
          // Mientras grabás, el mapa se oculta y se ven los datos grandes.
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _recording
                  ? recordingView(_seconds, _distanceKm)
                  : mapView(_mapController, _position, _route),
            ),
          ),
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
                      onTap: _recording ? null : () => setState(() => _isRunning = false),
                    ),
                    const SizedBox(width: 12),
                    typeOption(
                      icon: Icons.directions_run,
                      label: 'Correr',
                      selected: _isRunning,
                      onTap: _recording ? null : () => setState(() => _isRunning = true),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    statItem(formatDuration(_seconds), 'Tiempo'),
                    statItem(formatDistance(_distanceKm), distanceUnit(_distanceKm)),
                    statItem(formatPace(_seconds, _distanceKm), 'Ritmo /km'),
                  ],
                ),
                const SizedBox(height: 24),
                _saving
                    ? const SizedBox(
                        height: 84,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    // Al terminar se muestra el resumen con el botón "Listo"
                    : !_recording && _route.length >= 2
                        ? SizedBox(
                            width: double.infinity,
                            child: loadingButton(
                              text: 'Listo',
                              loading: false,
                              onPressed: _reset,
                            ),
                          )
                        : playButton(_recording, _recording ? _stop : _start),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

bool get isAndroid => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

// En Android el GPS sigue funcionando en segundo plano y se muestra
// una notificación fija mientras se graba la actividad
LocationSettings locationSettings() {
  if (isAndroid) {
    return AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // un punto nuevo cada 5 metros
      foregroundNotificationConfig: const ForegroundNotificationConfig(
        notificationTitle: 'Running Tracker',
        notificationText: 'Grabando tu actividad...',
        enableWakeLock: true,
      ),
    );
  }
  return const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );
}

Widget mapView(MapController controller, LatLng position, List<LatLng> route) {
  return FlutterMap(
    mapController: controller,
    options: MapOptions(
      initialCenter: position,
      initialZoom: 17,
      // Si hay una ruta terminada, el mapa se encuadra para mostrarla entera
      initialCameraFit: route.length >= 2
          ? CameraFit.coordinates(
              coordinates: route,
              padding: const EdgeInsets.all(40),
            )
          : null,
      interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.running_tracker',
        tileBuilder: darkModeTileBuilder, // pinta el mapa en modo oscuro
      ),
      // El mapa falla si se le pasa una línea sin puntos
      if (route.length >= 2)
        PolylineLayer(
          polylines: [
            Polyline(points: route, strokeWidth: 5, color: AppTheme.primaryColor),
          ],
        ),
      if (route.length >= 2) startEndMarkers(route),
      // Mi ubicación solo cuando no hay una ruta terminada en pantalla
      if (route.length < 2)
        MarkerLayer(
        markers: [
          Marker(
            point: position,
            child: const Icon(Icons.my_location, color: AppTheme.primaryColor, size: 28),
          ),
        ],
      ),
    ],
  );
}

Widget recordingView(int seconds, double km) {
  return Container(
    color: AppTheme.backgroundColor,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Tiempo', style: TextStyle(color: AppTheme.textSecondary)),
        Text(
          formatDuration(seconds),
          style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Text(distanceUnit(km), style: const TextStyle(color: AppTheme.textSecondary)),
        Text(
          formatDistance(km),
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    ),
  );
}

Widget typeOption({
  required IconData icon,
  required String label,
  required bool selected,
  required VoidCallback? onTap,
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

Widget playButton(bool recording, VoidCallback onPressed) {
  return SizedBox(
    width: 84,
    height: 84,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: recording ? Colors.red.shade600 : AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        padding: EdgeInsets.zero,
      ),
      child: Icon(
        recording ? Icons.stop_rounded : Icons.play_arrow_rounded,
        size: 52,
      ),
    ),
  );
}
