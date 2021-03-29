import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/chat/screens/welcome_screen.dart';
import 'package:flutter_app_sp2/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'component/drawer.dart';
import 'provider_page.dart';

class GoogleMapPage extends StatefulWidget {
  static const String id = 'google_map';

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final LatLng _center = const LatLng(41.31183310448432, 69.27953177224906);

  _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    double distanceInKm = await Geolocator.distanceBetween(
            41.31183310448432,
            69.27953177224906,
            specify[POSITION].latitude,
            specify[POSITION].longitude) /
        1000;
    final Marker marker = Marker(
      markerId: markerId,
      position:
          LatLng(specify[POSITION].latitude, specify[POSITION].longitude),
      infoWindow: InfoWindow(
        title: specify[COMPANY_NAME],
        snippet: distanceInKm.toStringAsFixed(2)+'km',
      ),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() {
    FirebaseFirestore.instance
        .collection(COLLECTION)
        .get()
        .then((pos) {
      if (pos.docs.isNotEmpty) {
        for (int i = 0; i < pos.docs.length; ++i) {
          initMarker(pos.docs[i].data(), pos.docs[i].id);
        }
      }
    });
  }

  @override
  void initState() {
    getMarkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: Center(child: Text(GOOGLE_MAP_PAGE_APPBAR_TITLE)),
        ),
        body: GoogleMap(
          markers: Set<Marker>.of(markers.values),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 10,
          ),
        ),
        drawer:         
        Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text(DRAWER_LIST_TILE_TITLE_MAIN_MENU),
                decoration: BoxDecoration(color: Colors.blue),
              ),
              ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        URL_NETWORK_IMAGE)),
                title: Text(DRAWER_LIST_TILE_TITLE),
                subtitle: Text(DRAWER_MY_EMAIL),
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text(DRAWER_LIST_TILE_TITLE_CHAT),
                onTap: () {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text(DRAWER_LIST_TILE_TITLE_ADD),
                onTap: () {
                  Navigator.pushNamed(context, ProviderPage.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
