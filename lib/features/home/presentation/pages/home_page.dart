import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:olater/features/home/presentation/provider/home_provider.dart';
import 'package:olater/features/auth/presentation/provider/auth_provider.dart';
import 'package:olater/core/theme/app_theme.dart';
import 'package:olater/features/profile/presentation/pages/profile_page.dart';
import 'package:olater/features/home/domain/models/location_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();
  LatLng _initialPosition = const LatLng(12.9716, 77.5946); // Bangalore
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _initialPosition = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
        _mapController.move(_initialPosition, 15);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onLocationSelected(LocationModel location) {
    setState(() {
      _initialPosition = location.position;
      _searchController.clear();
    });
    _mapController.move(location.position, 15);
    context.read<HomeProvider>().searchLocation(''); // Clear search results
    context.read<HomeProvider>().addToRecent(location);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      body: Stack(
        children: [
          // OpenStreetMap
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialPosition,
                    initialZoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.olater',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _initialPosition,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

          // Header / Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Olater',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.white,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfilePage()),
                          );
                        },
                        icon: CircleAvatar(
                          backgroundColor: AppTheme.accentColor,
                          backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                          child: user?.photoURL == null 
                            ? const Icon(Icons.person, color: Colors.white) 
                            : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => homeProvider.searchLocation(value),
                      decoration: InputDecoration(
                        hintText: 'Where to?',
                        prefixIcon: const Icon(Icons.search, color: AppTheme.accentColor),
                        suffixIcon: _searchController.text.isNotEmpty 
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                homeProvider.searchLocation('');
                              },
                            )
                          : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  
                  // Search Results Overlay
                  if (homeProvider.searchResults.isNotEmpty || homeProvider.isSearching)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                      ),
                      child: homeProvider.isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: homeProvider.searchResults.length,
                              itemBuilder: (context, index) {
                                final location = homeProvider.searchResults[index];
                                return ListTile(
                                  leading: const Icon(Icons.location_on_outlined),
                                  title: Text(location.name),
                                  subtitle: Text(
                                    location.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () => _onLocationSelected(location),
                                );
                              },
                            ),
                    ),
                ],
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            right: 16,
            bottom: MediaQuery.of(context).size.height * 0.35 + 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _determinePosition,
              child: const Icon(Icons.my_location, color: AppTheme.primaryColor),
            ),
          ),

          // Bottom Sheet for Service Selection
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Choose a service',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ServiceCard(
                          title: 'Ride',
                          icon: Icons.directions_car,
                          isSelected: homeProvider.selectedService == ServiceType.ride,
                          onTap: () => homeProvider.selectService(ServiceType.ride),
                        ),
                        _ServiceCard(
                          title: 'Delivery',
                          icon: Icons.local_shipping,
                          isSelected: homeProvider.selectedService == ServiceType.delivery,
                          onTap: () => homeProvider.selectService(ServiceType.delivery),
                        ),
                      ],
                    ),
                    const Divider(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        'Recent Locations',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    if (homeProvider.recentLocations.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('No recent locations yet', style: TextStyle(color: Colors.grey)),
                      )
                    else
                      ...homeProvider.recentLocations.map((location) => ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(location.name),
                            subtitle: Text(location.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                            onTap: () => _onLocationSelected(location),
                          )),
                    const ListTile(
                      leading: Icon(Icons.star_border),
                      title: Text('Saved Places'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentColor.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accentColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? AppTheme.primaryColor : Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
