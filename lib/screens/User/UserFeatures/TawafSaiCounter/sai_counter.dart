import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SaiCounter extends StatefulWidget {
  const SaiCounter({super.key});

  @override
  State<SaiCounter> createState() => _SaiCounterState();
}

class _SaiCounterState extends State<SaiCounter> {
  int saiCount = 0;
  double totalDistance = 0.0;

  Position? lastPosition;
  StreamSubscription<Position>? _positionStreamSub;

  // ===== Sa'i & Step Settings =====
  static const double saiDistance = 394.0; // meters per leg
  static const double stepLengthMeters = 0.6096; // 2 feet
  static const double minStepDistance = 0.3; // GPS noise filter

  bool isUserMoving = false;
  String statusMessage = "Initializing location...";

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    super.dispose();
  }

  // ===== Location Permission & Stream =====
  Future<void> _startLocationTracking() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        statusMessage = "Please enable location services.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        statusMessage = "Location permission denied.";
      });
      return;
    }

    setState(() {
      statusMessage = "Waiting for movement...";
    });

    _positionStreamSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    ).listen(_onPositionUpdate);
  }

  // ===== Step-Based Distance Calculation =====
  void _onPositionUpdate(Position position) {
    if (lastPosition == null) {
      lastPosition = position;
      return;
    }

    final double distance = Geolocator.distanceBetween(
      lastPosition!.latitude,
      lastPosition!.longitude,
      position.latitude,
      position.longitude,
    );

    // Ignore GPS noise
    if (distance < minStepDistance) return;

    // Convert distance to steps
    int steps = (distance / stepLengthMeters).floor();

    if (steps > 0) {
      setState(() {
        isUserMoving = true;
        statusMessage = "Walking detected. Counting steps...";
        totalDistance += steps * stepLengthMeters;
      });

      // Sa'i leg completed
      if (totalDistance >= saiDistance) {
        setState(() {
          saiCount++;
          totalDistance = 0.0;
          statusMessage = "One Sa’i leg completed!";
        });
      }
    }

    lastPosition = position;
  }

  // ===== Reset =====
  void _resetCounter() {
    setState(() {
      saiCount = 0;
      totalDistance = 0.0;
      isUserMoving = false;
      lastPosition = null;
      statusMessage = "Counter reset. Waiting for movement...";
    });
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sa’i Auto Counter")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$saiCount / 7 Rounds Completed",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text("Current Leg Distance", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            Text(
              "${totalDistance.toStringAsFixed(2)} m",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),
            const Text(
              "One Round completes at 394 meters",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),
            Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isUserMoving ? Colors.green : Colors.orange,
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _resetCounter,
              child: const Text("Reset Counter"),
            ),
          ],
        ),
      ),
    );
  }
}
