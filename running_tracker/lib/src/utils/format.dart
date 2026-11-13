String _twoDigits(int n) => n.toString().padLeft(2, '0');

// 125 -> 02:05, 3725 -> 1:02:05
String formatDuration(int seconds) {
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = seconds % 60;
  if (h > 0) return '$h:${_twoDigits(m)}:${_twoDigits(s)}';
  return '${_twoDigits(m)}:${_twoDigits(s)}';
}

// Ritmo en minutos por km
String formatPace(int seconds, double km) {
  if (km < 0.01) return '--:--';
  final paceSeconds = (seconds / km).round();
  return '${paceSeconds ~/ 60}:${_twoDigits(paceSeconds % 60)}';
}

String formatDate(DateTime date) {
  final d = date.toLocal();
  return '${_twoDigits(d.day)}/${_twoDigits(d.month)}/${d.year} '
      '${_twoDigits(d.hour)}:${_twoDigits(d.minute)}';
}

// Estimación simple: correr gasta el doble que caminar (persona de 70 kg)
int calculateCalories(double km, bool isRunning) {
  return (km * 70 * (isRunning ? 1.0 : 0.5)).round();
}

// Menos de 1 km se muestra en metros (0.02 km -> "20"), si no en km
String formatDistance(double km) {
  if (km < 1) return '${(km * 1000).round()}';
  return km.toStringAsFixed(2);
}

String distanceUnit(double km) => km < 1 ? 'Metros' : 'Km';
