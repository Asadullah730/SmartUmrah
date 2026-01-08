// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// class SaiCounter extends StatefulWidget {
//   const SaiCounter({super.key});

//   @override
//   State<SaiCounter> createState() => _SaiCounterState();
// }

// class _SaiCounterState extends State<SaiCounter> {
//   int saiCount = 0;
//   double totalDistance = 0.0; // Distance for current leg (meters)
//   Position? lastPosition;
//   StreamSubscription<Position>? _positionStreamSub;

//   static const double saiDistance = 394; // Safa <-> Marwa distance

//   String statusMessage = "Initializing location...";
//   bool isTracking = false;

//   @override
//   void initState() {
//     super.initState();
//     _startLocationTracking();
//   }

//   @override
//   void dispose() {
//     _positionStreamSub?.cancel();
//     super.dispose();
//   }

//   Future<void> _startLocationTracking() async {
//     setState(() {
//       statusMessage = "Checking location services...";
//     });

//     // 1. Check if location service is enabled
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() {
//         statusMessage = "Location service is disabled. Please enable GPS.";
//       });
//       return;
//     }

//     // 2. Check & request permission
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.denied) {
//       setState(() {
//         statusMessage = "Location permission denied. Cannot track distance.";
//       });
//       return;
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() {
//         statusMessage =
//             "Location permission permanently denied. Enable from settings.";
//       });
//       return;
//     }

//     // 3. Start listening to location updates
//     setState(() {
//       statusMessage = "Tracking started. Start walking...";
//       isTracking = true;
//     });

//     _positionStreamSub =
//         Geolocator.getPositionStream(
//           locationSettings: const LocationSettings(
//             accuracy: LocationAccuracy.best,
//             distanceFilter: 0, // report *all* changes
//           ),
//         ).listen(
//           (Position position) {
//             // For debugging:
//             // print("New position: ${position.latitude}, ${position.longitude}");

//             if (lastPosition != null) {
//               final double distance = Geolocator.distanceBetween(
//                 lastPosition!.latitude,
//                 lastPosition!.longitude,
//                 position.latitude,
//                 position.longitude,
//               );

//               // Ignore tiny/noisy movements less than 0.5m
//               if (distance > 0.5) {
//                 setState(() {
//                   totalDistance += distance;
//                 });

//                 // Check if one Sai leg (394m) completed
//                 if (totalDistance >= saiDistance) {
//                   setState(() {
//                     saiCount++;
//                     totalDistance = 0.0; // reset for next leg
//                     statusMessage = "One round completed! Continue walking...";
//                   });
//                 }
//               }
//             }

//             lastPosition = position;
//           },
//           onError: (error) {
//             setState(() {
//               statusMessage = "Location error: $error";
//             });
//           },
//         );
//   }

//   void _resetCounter() {
//     setState(() {
//       saiCount = 0;
//       totalDistance = 0.0;
//       statusMessage = "Counter reset. Start walking again.";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Sa’i Auto Counter")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "$saiCount / 7 Rounds Completed",
//               style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Text("Current Leg Distance:", style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text(
//               "${totalDistance.toStringAsFixed(2)} m",
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               "One leg completes at 394 meters",
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             const SizedBox(height: 24),
//             Text(
//               statusMessage,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: _resetCounter,
//               child: const Text("Reset Counter"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
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
              "1 step = 2 feet (0.61 m)\nOne leg completes at 394 meters",
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
