import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'main_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(40.416775, -3.703790);
  LatLng? _currentLocation;
  bool _isSatellite = false;
  bool _loadingLocation = false;

  // Marcadores de ejemplo (mascotas cercanas)
  final List<Map<String, dynamic>> _petMarkers = [
    {
      'id': 'marker_1',
      'position': const LatLng(40.416775, -3.703790),
      'name': 'Toby',
      'breed': 'Labrador • 2 años',
      'color': AppColors.primaryBlue,
    },
    {
      'id': 'marker_2',
      'position': const LatLng(40.420, -3.710),
      'name': 'Luna',
      'breed': 'Husky • 1 año',
      'color': Colors.pinkAccent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() => _loadingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _center = _currentLocation!;
        });
        _mapController.move(_center, 15.0);
      }
    } catch (e) {
      debugPrint('Error obteniendo ubicación: $e');
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  void _goToCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 16.0);
    } else {
      _determinePosition();
    }
  }

  void _showPetDetails(Map<String, dynamic> pet) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: (pet['color'] as Color).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.pets, color: pet['color'] as Color, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textMainDark : AppColors.textMainLight,
                        ),
                      ),
                      Text(
                        pet['breed'],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: isDark ? AppColors.textSubDark : AppColors.textSubLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text('VER PERFIL COMPLETO',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // MAPA OPENSTREETMAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 14.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.happy_patitas',
              ),

              // Marcador ubicación actual
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),

              // Marcadores mascotas
              MarkerLayer(
                markers: _petMarkers.map((pet) {
                  return Marker(
                    point: pet['position'] as LatLng,
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () => _showPetDetails(pet),
                      child: Container(
                        decoration: BoxDecoration(
                          color: pet['color'] as Color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: (pet['color'] as Color).withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.pets, color: Colors.white, size: 24),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // HEADER
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: 20, right: 20, bottom: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.45),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Localización',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (_loadingLocation)
                    const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // BOTONES FLOTANTES
          Positioned(
            bottom: 30, right: 20,
            child: Column(
              children: [
                // Satélite / Normal
                FloatingActionButton(
                  heroTag: 'mapType',
                  mini: true,
                  onPressed: () => setState(() => _isSatellite = !_isSatellite),
                  backgroundColor:
                      (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
                          .withOpacity(0.95),
                  child: Icon(
                    _isSatellite ? Icons.map_rounded : Icons.layers_rounded,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 12),
                // Mi ubicación
                FloatingActionButton(
                  heroTag: 'myLocation',
                  onPressed: _goToCurrentLocation,
                  backgroundColor: AppColors.primaryBlue,
                  child: const Icon(Icons.my_location_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
          // Botón volver a Home
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: SafeArea(
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                elevation: 4,
                shadowColor: Colors.black26,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => HomeNavigatorScope.of(context)?.goHome(),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.arrow_back_rounded, color: Colors.black87, size: 22),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
